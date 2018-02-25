-- Create DEACTIVATED user
SELECT $DB_NAME$Views.SP_$DB_NAME$UpsertUser (0, 'DEACTIVATED', 'ST', '', '', NULL, NULL, NULL,NULL,NULL);
SELECT $DB_NAME$Views.SP_$DB_NAME$DeactivateUser(0);

-- Load NextId initial values
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('Contract', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('User', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('School', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('Class', 1);
