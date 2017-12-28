-- Kick off any users connected to application DB
SELECT pg_terminate_backend (pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$DB_NAME$';

-- Clean up DB objects
DROP DATABASE $DB_NAME$;
DROP ROLE $DB_USER$;