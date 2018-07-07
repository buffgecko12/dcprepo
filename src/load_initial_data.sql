-- Create DEACTIVATED lookup entries (must be done in correct orders)
SELECT $DB_NAME$Views.SP_DCPUpsertSchool (0, 'DEACTIVATED', 'DEACTIVATED', NULL, NULL, NULL);
SELECT $DB_NAME$Views.SP_DCPUpsertClass (0, 0, 'DEACTIVATED');

--SELECT $DB_NAME$Views.SP_DCPUpsertUser (-1, 'Anonymous', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);

SELECT $DB_NAME$Views.SP_DCPUpsertUser (0, 'DEACTIVATED', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);
SELECT $DB_NAME$Views.SP_DCPDeactivateUser(0);

SELECT $DB_NAME$Views.SP_DCPUpsertTeacher(0, 0, JSONB('{"currentclasses": [{"classid":0}]}'), NULL, NULL, NULL, NULL, NULL);
SELECT $DB_NAME$Views.SP_DCPUpsertStudent(0, 0, NULL, NULL, NULL, NULL, NULL);

-- Load NextId initial values
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES 
('contract', 1), 
('user', 1), 
('school', 1), 
('class', 1), 
('reward', 1);

-- Load contract status
INSERT INTO $DB_NAME$.Lookup_Status (Status, StatusDisplayName) VALUES 
('P','Pendiente'),
('D','Borrador'),
('C','Completo'),
('A','Activo');