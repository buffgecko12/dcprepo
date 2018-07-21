/*
-- Kick off any users connected to application DB
SELECT pg_terminate_backend (pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$DB_APP_DATABASE$';
*/

-- Clean up DB objects
DROP SCHEMA IF EXISTS $DB_NAME$ CASCADE; -- Store base tables
DROP SCHEMA IF EXISTS $DB_NAME$Views CASCADE; -- Store views, functions, etc. (keep value lower case for PG)

/*
DROP OWNED BY $DB_APP_USER$;
DROP DATABASE IF EXISTS $DB_APP_DATABASE$;
DROP ROLE IF EXISTS $DB_APP_USER$;
*/