-- Create DEACTIVATED user
SELECT $DB_NAME$Views.SP_$DB_NAME$UpsertUser (0, 'DEACTIVATED', 'ST', '', '', NULL, NULL, NULL,NULL,NULL);
SELECT $DB_NAME$Views.SP_$DB_NAME$DeactivateUser(0);

-- Load NextId initial values
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('contract', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('user', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('school', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('class', 1);
