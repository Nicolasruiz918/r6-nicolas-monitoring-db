param(
  [string]$EnvFile = '.env.develop',
  [ValidateSet('develop','qa','staging','main')][string]$Environment = 'develop',
  [ValidateRange(1,1)][int]$Count = 1,
  [string]$InfraPath = '',
  [switch]$AllowIsolatedEnvironment
)

if (-not $AllowIsolatedEnvironment) {
  throw 'Rollback bloqueado por seguridad. Use -AllowIsolatedEnvironment solo contra una base local aislada.'
}
if ($Environment -eq 'main') {
  throw 'El perfil main no se revierte directamente; replique su configuración en una base aislada.'
}
if ($InfraPath) {
  $infraPath = (Resolve-Path -LiteralPath $InfraPath).Path
} else {
  $infraPath = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..\design-software-docker-infra')).Path
}
if (-not [System.IO.Path]::IsPathRooted($EnvFile)) { $EnvFile = Join-Path $infraPath $EnvFile }
if (-not (Test-Path -LiteralPath $EnvFile)) { throw "No existe el archivo de ambiente: $EnvFile" }

$outDir = Join-Path $PSScriptRoot ("..\evidencias\06-rollback\" + $Environment)
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$before = Join-Path $outDir '01-before.txt'
$rollback = Join-Path $outDir '02-rollback.txt'
$after = Join-Path $outDir '03-after.txt'

function Invoke-LiquibaseSql([string]$Sql, [string]$OutputFile) {
  docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring-contract execute-sql "--sql=$Sql" | Tee-Object -FilePath $OutputFile
  if ($LASTEXITCODE -ne 0) { throw "La consulta Liquibase falló con exit code $LASTEXITCODE" }
}

$expectedId = 'r6-monitoring-contract-specific-actions-v2-993'
$expectedAuthor = 'codex'
$expectedFile = '01_ddl/04_alter/r6-contract.yaml'
$historySql = "SELECT id, author, filename, exectype FROM databasechangelog WHERE id='$expectedId' AND author='$expectedAuthor' AND filename='$expectedFile' AND exectype='EXECUTED' ORDER BY orderexecuted DESC LIMIT 1; SELECT id, author, filename, exectype FROM databasechangelog ORDER BY orderexecuted DESC LIMIT 1;"
$beforeSql = "SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_schema='monitoring' AND table_name='improvement_plan' AND column_name IN ('specific_actions','specific_actions_v2') ORDER BY column_name; SELECT count(*) AS total_rows, count(*) FILTER (WHERE specific_actions IS NULL) AS null_actions, count(*) FILTER (WHERE jsonb_typeof(specific_actions) <> 'object') AS non_object_actions FROM monitoring.improvement_plan;"
$afterSql = "SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_schema='monitoring' AND table_name='improvement_plan' AND column_name IN ('specific_actions','specific_actions_v2') ORDER BY column_name; SELECT count(*) AS total_rows, count(*) FILTER (WHERE specific_actions IS NULL) AS null_actions, count(*) FILTER (WHERE specific_actions_v2 IS NULL) AS null_transitional, count(*) FILTER (WHERE specific_actions_v2->'actions'->0->>'text' IS DISTINCT FROM specific_actions) AS mismatched_rows FROM monitoring.improvement_plan;"
$beforeDataSql = "SELECT md5(COALESCE(string_agg(id::text || '=' || COALESCE(specific_actions->'actions'->0->>'text', '<NULL>'), '|' ORDER BY id), '')) AS content_fingerprint, count(*) AS total_rows FROM monitoring.improvement_plan;"
$afterDataSql = "SELECT md5(COALESCE(string_agg(id::text || '=' || COALESCE(specific_actions, '<NULL>'), '|' ORDER BY id), '')) AS content_fingerprint, count(*) AS total_rows FROM monitoring.improvement_plan;"

Push-Location $infraPath
try {
docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring-contract history | Tee-Object -FilePath $before
docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring-contract status --verbose | Tee-Object -FilePath $before -Append

$history = Join-Path $outDir '00-validated-changeset.txt'
Invoke-LiquibaseSql $historySql $history
$historyText = Get-Content -Raw -LiteralPath $history
$expectedRow = (($expectedId, $expectedAuthor, $expectedFile, 'EXECUTED') -join '|') -replace '\s', ''
$normalizedHistory = ($historyText -replace '\s', '')
if ($normalizedHistory -notmatch [regex]::Escape($expectedRow)) { throw 'El changeset 993 no coincide exactamente en id, autor, ruta y estado; se aborta sin modificar la base.' }
$lastLines = $historyText -split "`r?`n" | Where-Object { $_ -match '\| EXECUTED \|' }
$lastNormalized = if ($lastLines) { $lastLines[-1] -replace '\s', '' } else { '' }
if ($lastNormalized -ne $expectedRow) { throw 'El último changeset aplicado no es exactamente CONTRACT 993; se aborta sin modificar la base.' }

$beforeSqlFile = Join-Path $outDir '00-before-structure-data.txt'
Invoke-LiquibaseSql $beforeSql $beforeSqlFile
$beforeDataFile = Join-Path $outDir '00-before-content-fingerprint.txt'
Invoke-LiquibaseSql $beforeDataSql $beforeDataFile
$beforeSqlText = Get-Content -Raw -LiteralPath $beforeSqlFile
if ($beforeSqlText -notmatch 'specific_actions \| jsonb') { throw 'La estructura previa no está en CONTRACT JSONB; se aborta.' }
if ($beforeSqlText -match 'specific_actions_v2 \|') { throw 'La columna transitoria sigue presente; se aborta para evitar un rollback ambiguo.' }
if ($beforeSqlText -match 'null_actions \| [1-9]') { throw 'Hay datos nulos antes del rollback; se aborta.' }

"Revirtiendo exactamente el último changeset R6: r6-monitoring-contract-specific-actions-v2-993 (rollback-count 1)." | Tee-Object -FilePath $rollback
docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring-contract rollback-count 1 | Tee-Object -FilePath $rollback -Append
if ($LASTEXITCODE -ne 0) { throw "Liquibase rollback falló con exit code $LASTEXITCODE" }

docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring-contract status --verbose | Tee-Object -FilePath $after
$afterSqlFile = Join-Path $outDir '04-after-structure-data.txt'
Invoke-LiquibaseSql $afterSql $afterSqlFile
$afterDataFile = Join-Path $outDir '04-after-content-fingerprint.txt'
Invoke-LiquibaseSql $afterDataSql $afterDataFile
$afterSqlText = Get-Content -Raw -LiteralPath $afterSqlFile
if ($afterSqlText -notmatch 'specific_actions \| text') { throw 'Después del rollback no se restauró specific_actions TEXT.' }
if ($afterSqlText -notmatch 'specific_actions_v2 \| jsonb \| YES') { throw 'Después del rollback no se restauró specific_actions_v2 JSONB nullable.' }
if ($afterSqlText -notmatch 'specific_actions \| text \| NO') { throw 'Después del rollback no se restauró specific_actions TEXT NOT NULL.' }
if ($afterSqlText -match 'null_actions \| [1-9]|null_transitional \| [1-9]|mismatched_rows \| [1-9]') { throw 'El rollback dejó datos nulos o inconsistentes.' }
$beforeFingerprint = [regex]::Match((Get-Content -Raw -LiteralPath $beforeDataFile), 'content_fingerprint\s*\|\s*([0-9a-f]+)').Groups[1].Value
$afterFingerprint = [regex]::Match((Get-Content -Raw -LiteralPath $afterDataFile), 'content_fingerprint\s*\|\s*([0-9a-f]+)').Groups[1].Value
if (-not $beforeFingerprint -or $beforeFingerprint -ne $afterFingerprint) { throw 'El contenido de los registros cambió durante el rollback.' }
"Validación automática aprobada: estructura y datos conservados después del rollback de CONTRACT $expectedId." | Tee-Object -FilePath $after -Append
} finally {
  Pop-Location
}
