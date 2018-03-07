-- Create schools/classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(100, 'School 1', 'My Address','Duitama','Boyaca'); -- Schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(100, 100, '10-03'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(101, 100, '10-01'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(102, 100, '9-05'); -- Classes

-- Add users
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (100, 'MyTeacher','TR','Joe','Smith',NULL,'MyPhone','joe@smith.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (101, 'MyStudent','ST','Nic','Cage',NULL,'MyPhone','nic@cage.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (102, 'MyStudent','ST','Sean','Connery',NULL,'MyPhone','the@besht.com',NULL,0,NULL);

-- Add teacher info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(100, JSONB('{"deletedclasses": [],"currentclasses": [{"classid":100},{"classid":101}]}'));
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(100, JSONB('{"deletedclasses": [100,101],"currentclasses": [{"classid":102}]}'));

-- Add student info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(101,1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(102,1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(101,0);

-- Get school/class info
SELECT * FROM $DB_NAME$Views.SP_DCPGetSchool(100);
SELECT * FROM $DB_NAME$Views.SP_DCPGetClass(100);

-- Get user info
SELECT * FROM $DB_NAME$Views.SP_DCPGetStudent(101);
SELECT * FROM $DB_NAME$Views.SP_DCPGetTeacher(100);
SELECT * FROM $DB_NAME$Views.SP_DCPGetUser(100,'MyTeacher',NULL);

-- Other
SELECT * FROM $DB_NAME$Views.SP_DCPDeactivateUser(101);

-- Delete objects
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteUser(101);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteClass(100);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteSchool(100);

-- Other
SELECT * FROM $DB_NAME$Views.SP_DCPGetNextId('class');

-- Contracts
