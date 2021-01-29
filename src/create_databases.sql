-- TO-DO: Check for correct default encoding (UTF8 vs. WIN1252)
-- Objects should be created by application user

/*
-- Create new DB and connect to it
CREATE DATABASE $APP_DATABASE$ ENCODING 'UTF8';
\connect $APP_DATABASE$;
*/
-- Create schemas (namespaces) to separate base tables, views, functions, etc.
CREATE SCHEMA IF NOT EXISTS $APP_NAME$; -- Store base tables
CREATE SCHEMA IF NOT EXISTS $APP_NAME$Views; -- Store views, functions, etc.