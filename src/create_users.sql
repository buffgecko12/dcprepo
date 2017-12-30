-- Create new application user
CREATE ROLE $DB_USER$ WITH 
LOGIN
PASSWORD '$DB_PASS$' 
CREATEDB;

-- Set default search path to "Views" schema (similar to default database)
ALTER ROLE $DB_USER$ SET search_path TO "$DB_NAME$views"; -- This schema will be created soon in the install process

-- Grant permissions (if needed)