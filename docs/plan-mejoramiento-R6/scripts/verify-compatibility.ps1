param([string]$ServicePath = '..\..\..\..\design-software-monitoring-service')
Push-Location $ServicePath
python -m pytest -q tests/test_specific_actions_compat.py
Pop-Location
