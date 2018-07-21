-- Create new application user
/*
CREATE ROLE $DB_APP_USER$ WITH 
LOGIN
PASSWORD '$DB_APP_PASSWORD$' 
CREATEDB;
*/

-- Set default search path to "Views" schema (similar to default database)
ALTER ROLE $DB_APP_USER$ SET search_path TO "$DB_NAME$views"; -- must be lower case