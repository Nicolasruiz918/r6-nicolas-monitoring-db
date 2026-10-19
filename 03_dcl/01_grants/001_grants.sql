-- Grants least-privilege dominio monitoring
GRANT USAGE ON SCHEMA monitoring TO monitoring_reader, monitoring_writer, monitoring_admin;
GRANT SELECT ON ALL TABLES IN SCHEMA monitoring TO monitoring_reader;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA monitoring TO monitoring_writer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA monitoring TO monitoring_writer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA monitoring TO monitoring_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA monitoring TO monitoring_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA monitoring GRANT SELECT ON TABLES TO monitoring_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA monitoring GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO monitoring_writer;
ALTER DEFAULT PRIVILEGES IN SCHEMA monitoring GRANT ALL ON TABLES TO monitoring_admin;
