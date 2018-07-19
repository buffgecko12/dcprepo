-- Kick off any users connected to application DB
SELECT pg_terminate_backend (pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$DB_NAME$';

-- Clean up DB objects
DROP SCHEMA IF EXISTS $DB_NAME$ CASCADE; -- Store base tables
DROP SCHEMA IF EXISTS $DB_NAME$views CASCADE; -- Store views, functions, etc. (keep value lower case for PG)

DROP DATABASE IF EXISTS $DB_NAME$;
DROP ROLE IF EXISTS $DB_USER$;