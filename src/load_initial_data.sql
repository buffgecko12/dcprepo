-- Create DEACTIVATED lookup entries
SELECT $DB_NAME$Views.SP_DCPUpsertUser (0, 'DEACTIVATED', 'ST', '', '', NULL, NULL, NULL,NULL,0,NULL);
SELECT $DB_NAME$Views.SP_DCPDeactivateUser(0);

SELECT $DB_NAME$Views.SP_DCPUpsertSchool (0, 'DEACTIVATED', NULL, NULL, NULL);
SELECT $DB_NAME$Views.SP_DCPUpsertClass (0, 0, 'DEACTIVATED');

-- Load NextId initial values
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('contract', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('user', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('school', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('class', 1);
