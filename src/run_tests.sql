-- Create schools/classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'School 1', 'My Address','Duitama','Boyaca'); -- Schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-03'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-01'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '9-05'); -- Classes

-- Add users
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (NULL, 'MyTeacher','TR','Joe','Smith',NULL,'MyPhone','joe@smith.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (NULL, 'MyStudent','ST','Nic','Cage',NULL,'MyPhone','nic@cage.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (NULL, 'MyStudent','ST','Sean','Connery',NULL,'MyPhone','the@besht.com',NULL,0,NULL);

-- Add teacher info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(1, JSONB('{"deletedclasses": [],"currentclasses": [{"classid":1},{"classid":2}]}'));
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(1, JSONB('{"deletedclasses": [1,2],"currentclasses": [{"classid":3}]}'));

-- Add student info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(2,1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(3,1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(2,0);

-- Get school/class info
SELECT * FROM $DB_NAME$Views.SP_DCPGetSchool(1);
SELECT * FROM $DB_NAME$Views.SP_DCPGetClass(1);

-- Get user info
SELECT * FROM $DB_NAME$Views.SP_DCPGetStudent(1);
SELECT * FROM $DB_NAME$Views.SP_DCPGetTeacher(1);
SELECT * FROM $DB_NAME$Views.SP_DCPGetUser(1,'MyTeacher',NULL);

-- Other
SELECT * FROM $DB_NAME$Views.SP_DCPDeactivateUser(2);

-- Delete objects
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteUser(2);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteClass(1);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteSchool(1);

-- Other
SELECT * FROM $DB_NAME$Views.SP_DCPGetNextId('class');

-- Contracts
