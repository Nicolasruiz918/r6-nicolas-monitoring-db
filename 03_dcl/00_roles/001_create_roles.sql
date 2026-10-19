-- Roles de aplicacion (least-privilege) para el dominio monitoring
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='monitoring_reader') THEN CREATE ROLE monitoring_reader NOLOGIN; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='monitoring_writer') THEN CREATE ROLE monitoring_writer NOLOGIN; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='monitoring_admin')  THEN CREATE ROLE monitoring_admin  NOLOGIN; END IF;
END $$;
