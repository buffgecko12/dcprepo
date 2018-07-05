-- Create schools/classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(100, 'Test School 1', 'TS1', 'My Address','Duitama','Boyaca'); -- Schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(100, 100, '10-03'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(101, 100, '10-01'); -- Classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(102, 100, '9-05'); -- Classes

-- Add users
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (100, 'MyTeacher','TR','Joe','Smith',NULL,'MyPhone','joe1@smith.com',NULL,'U',NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (101, 'MyStudent1','ST','Nic','Cage',NULL,'MyPhone','nic@cage.com',NULL,'U',NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (102, 'MyStudent2','ST','Sean','Connery',NULL,'MyPhone','the@besht.com',NULL,'U',NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUser (103, 'MyStudent3','ST','Elsa','Benitez',NULL,'MyPhone1','the@shipoopee.com',NULL,'U',NULL);

-- Add teacher info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(100, 100, JSONB('{"deletedclasses": [],"currentclasses": [{"classid":100},{"classid":101}]}'), NULL, NULL, NULL, NULL, NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(100, 100, JSONB('{"deletedclasses": [101],"currentclasses": [{"classid":102}]}'), NULL, NULL, NULL, NULL, NULL);

-- Add student info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(101,100, NULL, NULL, NULL, NULL, NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(102,100, NULL, NULL, NULL, NULL, NULL);

-- Modify student info
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(101,0, NULL, NULL, NULL, NULL, NULL);

-- Add reward info
SELECT $DB_NAME$Views.SP_DCPUpsertReward(NULL, 'Tiquetes al cine', 'Tiquetes al cine en Innovo.', 6000, 0);
SELECT $DB_NAME$Views.SP_DCPUpsertReward(NULL, 'Pizza', 'Pizza y gaseosa.', 5000, 0);

-- Get reward info
SELECT * FROM $DB_NAME$Views.SP_DCPGetReward(1,NULL,NULL);

-- Deactivate reward
SELECT * FROM $DB_NAME$Views.SP_DCPDeactivateReward(1);

-- Add contract
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContract(
	100,100,'G',100,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some student leader requirements',NULL,NULL,NULL,
	JSONB('{"currentgoals": [{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null, "rewardinfo":{"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}},{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null,"rewardinfo":{"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}}]}'),
	JSONB('{"currentparties": [{"partyuserid": 100,"contractrole": "MR"},{"partyuserid": 101,"contractrole": "PL"},{"partyuserid": 102,"contractrole": "BL"},{"partyuserid": 103,"contractrole": "PT"}]}')
);

-- Modify contact
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContract(
	100,1,'G',3,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some REALLY leader requirements','dadada',NULL,NULL,
	JSONB('{"deletedgoals": [1],"currentgoals": [{"goalid": 2, "difficultylevel": "D","goaldescription": "Some new description","rewardinfo":{"deletedrewards": [1],"currentrewards": [{"rewardid": 2}]}}]}'),
	JSONB('{"deletedparties": [101],"currentparties": [{"partyuserid": 100,"contractrole": "MR"},{"partyuserid": 103,"contractrole": "PL"}]}')
);

-- Change status to 'active'
SELECT * FROM $DB_NAME$Views.SP_DCPChangeContractStatus(100,'A');

-- Add / modify /delete contract goals / rewards
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContractGoal(1,NULL,'E','Goal 1',NULL,NULL,
JSONB('{"deletedrewards": [],"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}'));

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContractGoal(1,1,'M','Goal 1',NULL,NULL,
JSONB('{"deletedrewards": [],"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}'));

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContractGoalReward(1,2,1);

-- Delete goal reward and goal
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteContractGoalReward(1,2,1);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteContractGoalReward(1,NULL,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteContractGoal(1,2);
SELECT * FROM $DB_NAME$Views.SP_DCPDeleteContractGoal(1,NULL);

SELECT * FROM $DB_NAME$Views.SP_DCPModifyContractParties(
	100,
	JSONB('{"deletedparties": [100],"currentparties": [{"partyuserid": null,"contractrole": "MR"},{"partyuserid": 103,"contractrole": "PL"}]}')
);

-- Get contract info
SELECT * FROM $DB_NAME$Views.SP_DCPGetContract(100);
SELECT * FROM $DB_NAME$Views.SP_DCPGetContractGoal(100,2,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPGetContractGoalReward(100,2,NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPGetContractParty(100,100,NULL);

-- Accept contract goal
SELECT * FROM $DB_NAME$Views.SP_DCPAcceptContractGoal(100,2);
-- Approve initial contract
SELECT * FROM $DB_NAME$Views.SP_DCPApproveContract(100, 102, 'C', NULL, current_timestamp, 101);

-- Revise contract
SELECT * FROM $DB_NAME$Views.SP_DCPReviseContract(100,'test revision');

-- Add reputation events
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUserReputationEvent(101, 'BP', NULL, 10, 1);

-- Get school/class info
SELECT * FROM $DB_NAME$Views.SP_DCPGetSchool(100);
SELECT * FROM $DB_NAME$Views.SP_DCPGetClass(100,NULL,NULL);

-- Get user info
SELECT * FROM $DB_NAME$Views.SP_DCPGetStudent(101, NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPGetTeacher(100);
SELECT * FROM $DB_NAME$Views.SP_DCPGetTeacherClass(100, 100);
SELECT * FROM $DB_NAME$Views.SP_DCPGetTeacherClass(100, NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPGetUser(100,'MyTeacher',NULL);
SELECT * FROM $DB_NAME$Views.SP_DCPGetUserReputationEvent(1,NULL,NULL);

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
