/*
-- Kick off any users connected to application DB
SELECT pg_terminate_backend (pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$APP_DATABASE$';
*/

-- Suppress "NOTICE" messages
SET client_min_messages=WARNING;

-- Clean up DB objects
DROP SCHEMA IF EXISTS $APP_NAME$ CASCADE; -- Store base tables
DROP SCHEMA IF EXISTS $APP_NAME$Views CASCADE; -- Store views, functions, etc. (keep value lower case for PG)

/*
DROP OWNED BY $APP_USER$;
DROP DATABASE IF EXISTS $APP_DATABASE$;
DROP ROLE IF EXISTS $APP_USER$;
*/