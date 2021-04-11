CREATE EXTENSION postgis;
SELECT PostGIS_full_version();
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;
select * from pg_extension;