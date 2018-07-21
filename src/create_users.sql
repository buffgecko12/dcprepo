-- Create new application user
/*
CREATE ROLE $APP_USER$ WITH 
LOGIN
PASSWORD '$APP_PASSWORD$' 
CREATEDB;
*/

-- Set default search path to "Views" schema (similar to default database)
ALTER ROLE $APP_USER$ SET search_path TO "$APP_NAME$views"; -- must be lower case