-- Create schools/classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(100, 'School 1', 'My Address','Duitama','Boyaca'); -- Schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(100, 100, '10-03'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(101, 100, '10-01'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(102, 100, '9-05'); -- Classes

-- Add users
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (100, 'MyTeacher','TR','Joe','Smith',NULL,'MyPhone','joe@smith.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (101, 'MyStudent1','ST','Nic','Cage',NULL,'MyPhone','nic@cage.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (102, 'MyStudent2','ST','Sean','Connery',NULL,'MyPhone','the@besht.com',NULL,0,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (103, 'MyStudent3','ST','Elsa','Benitez',NULL,'MyPhone1','the@shipoopee.com',NULL,0,NULL);

-- Add teacher info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(100, JSONB('{"deletedclasses": [],"currentclasses": [{"classid":100},{"classid":101}]}'));
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(100, JSONB('{"deletedclasses": [101],"currentclasses": [{"classid":102}]}'));

-- Add student info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(101,100);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(102,100);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(103,100);

-- Modify student info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(101,0);

-- Add contract
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContract(
	100,100,'G',100,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some student leader requirements',NULL,NULL,NULL,
	JSONB('{"currentgoals": [{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null},{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null}]}'),
	JSONB('{"currentrewards": [{"rewardid": null, "difficultylevel": "M","rewarddescription": "Some description"},{"rewardid": null, "difficultylevel": "M","rewarddescription": "Some description"}]}'),
	JSONB('{"currentparties": [{"partyuserid": 100,"contractrole": "MR"},{"partyuserid": 101,"contractrole": "PL"},{"partyuserid": 102,"contractrole": "BL"},{"partyuserid": 103,"contractrole": "PT"}]}')
);

-- Modify contact
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContract(
	100,1,'G',1,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some REALLY leader requirements','dadada',NULL,NULL,
	JSONB('{"deletedgoals": [1],"currentgoals": [{"goalid": 2, "difficultylevel": "D","goaldescription": "Some new description"}]}'),
	JSONB('{"deletedrewards": [1],"currentrewards": [{"rewardid": 2, "difficultylevel": "E","rewarddescription": "Some new description"}]}'),
	JSONB('{"deletedparties": [101],"currentparties": [{"partyuserid": 100,"contractrole": "MR"},{"partyuserid": 103,"contractrole": "PL"}]}')
);

-- Approve initial contract
SELECT * FROM $DB_NAME$Views.SP_DCPApproveContract(100, 102, 'C', NULL, current_timestamp, 101);

-- Revise contract
SELECT * FROM $DB_NAME$Views.SP_DCPReviseContract(100,'test revision');


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
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteClass(100);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteSchool(100);

SELECT * FROM $DB_NAME$Views.SP_DCPDeleteUser(100);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteUser(101);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteUser(102);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteUser(103);

-- Meta
SELECT * FROM $DB_NAME$Views.SP_DCPGetNextId('class');
