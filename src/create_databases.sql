-- Objects should be created by application user

-- Create new DB and connect to it
CREATE DATABASE $DB_NAME$ ENCODING 'UTF8';
\connect $DB_NAME$;

-- Create schemas (namespaces) to separate base tables, views, functions, etc.
CREATE SCHEMA $DB_NAME$; -- Store base tables
CREATE SCHEMA $DB_NAME$views; -- Store views, functions, etc. (keep value lower case for PG)

-- Grant permissions: 
--GRANT ALL ON $DB_NAME$ TO $DB_NAME$Views;
