-- TO-DO: Check for correct default encoding (UTF8 vs. WIN1252)
-- Objects should be created by application user

/*
-- Create new DB and connect to it
CREATE DATABASE $DB_APP_DATABASE$ ENCODING 'UTF8';
\connect $DB_APP_DATABASE$;
*/
-- Create schemas (namespaces) to separate base tables, views, functions, etc.
CREATE SCHEMA $DB_NAME$; -- Store base tables
CREATE SCHEMA $DB_NAME$Views; -- Store views, functions, etc.