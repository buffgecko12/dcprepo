-- Update files
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertFile(100,'MySchoolDataPolicy','.pdf',1000,'pdf','My description',NULL,'PB');

-- Create schools/classes
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertSchool(100, 'Test School 1', 'TS1', 'My Address','Duitama','Boyaca', 100, NULL); -- Schools
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(100, 100, '10-03'); -- Classes
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(101, 100, '10-01'); -- Classes
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(102, 100, '9-05'); -- Classes

-- Add users
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertUser (100, 'MyTeacher','TR','Joe','Smith',NULL,'MyPhone','joe1@smith.com',NULL,'U',NULL,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertUser (101, 'MyStudent1','ST','Nic','Cage',NULL,'MyPhone','nic@cage.com',NULL,'U',NULL,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertUser (102, 'MyStudent2','ST','Sean','Connery',NULL,'MyPhone','the@besht.com',NULL,'U',NULL,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertUser (103, 'MyStudent3','ST','Elsa','Benitez',NULL,'MyPhone1','the@shipoopee.com',NULL,'U',NULL,NULL);

-- Add user notification
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertUserNotification (100, 1001, NULL);

-- Add teacher info
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertTeacher(100, 100, 200000, JSONB('{"deletedclasses": [],"currentclasses": [{"classid":100},{"classid":101}]}'));
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertTeacher(100, 100, 200000, JSONB('{"deletedclasses": [101],"currentclasses": [{"classid":102}]}'));
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertTeacherBudget(100,500000);

-- Add student info
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertStudent(101,100);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertStudent(102,100);

-- Modify student info
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertStudent(101,0);

-- Add reward info
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 'Tiquetes al cine', 'Tiquetes al cine en Innovo.', 6000, True, 0);
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 'Pizza', 'Pizza y gaseosa.', 5000, True, 0);

-- Get reward info
SELECT * FROM $APP_NAME$Views.SP_DCPGetReward(1,NULL,NULL,NULL);

-- Deactivate reward
SELECT * FROM $APP_NAME$Views.SP_DCPDeactivateReward(1);
SELECT * FROM $APP_NAME$Views.SP_DCPDeactivateReward(2);

-- Add contract
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertContract(
	100,100,'G',100,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some student leader requirements',NULL,NULL,NULL,
	JSONB('{"currentgoals": [{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null, "rewardinfo":{"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}},{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null,"rewardinfo":{"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}}]}'),
	JSONB('{"currentparties": [{"partyuserid": 100,"contractrole": "MR"},{"partyuserid": 101,"contractrole": "PL"},{"partyuserid": 102,"contractrole": "BL"},{"partyuserid": 103,"contractrole": "PT"}]}')
);

-- Modify contact
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertContract(
	100,102,'G',100,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some REALLY leader requirements','dadada',NULL,NULL,
	JSONB('{"deletedgoals": [1],"currentgoals": [{"goalid": 2, "difficultylevel": "D","goaldescription": "Some new description","rewardinfo":{"deletedrewards": [1],"currentrewards": [{"rewardid": 2}]}}]}'),
	JSONB('{"deletedparties": [101],"currentparties": [{"partyuserid": 100,"contractrole": "MR"},{"partyuserid": 103,"contractrole": "PL"}]}')
);

-- Duplicate contract
SELECT * FROM $APP_NAME$Views.SP_DCPDuplicateContract(100, 102, 100, NULL);

-- Change status to 'active'
SELECT * FROM $APP_NAME$Views.SP_DCPChangeContractStatus(100,'A');

-- Add / modify /delete contract goals / rewards
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertContractGoal(100,NULL,'E','Goal 1',NULL,NULL,
JSONB('{"deletedrewards": [],"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}'));

SELECT * FROM $APP_NAME$Views.SP_DCPUpsertContractGoal(100,1,'M','Goal 1',NULL,NULL,
JSONB('{"deletedrewards": [],"currentrewards": [{"rewardid": 1},{"rewardid": 2}]}'));

SELECT * FROM $APP_NAME$Views.SP_DCPUpsertContractGoalReward(100,2,1);

-- Delete goal reward and goal
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteContractGoalReward(100,2,1);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteContractGoalReward(100,NULL,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteContractGoal(100,2);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteContractGoal(100,NULL);

SELECT * FROM $APP_NAME$Views.SP_DCPModifyContractParties(
	100,
	JSONB('{"deletedparties": [100],"currentparties": [{"partyuserid": null,"contractrole": "MR"},{"partyuserid": 103,"contractrole": "PL"}]}')
);

-- Get contract info
SELECT * FROM $APP_NAME$Views.SP_DCPGetContract(100,NULL,NULL,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetContractInfo(100);
SELECT * FROM $APP_NAME$Views.SP_DCPGetContractGoal(100,2,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetContractGoalReward(100,2,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetContractParty(100,100,NULL);

-- Approve initial contract
SELECT * FROM $APP_NAME$Views.SP_DCPApproveContract(100, 102, 'C', 1, NULL, 101);

-- Revise contract
SELECT * FROM $APP_NAME$Views.SP_DCPReviseContract(100,'test revision');

-- Get school/class info
SELECT * FROM $APP_NAME$Views.SP_DCPGetSchool(100);
SELECT * FROM $APP_NAME$Views.SP_DCPGetClass(100,NULL,NULL,NULL);

-- Get user info
SELECT * FROM $APP_NAME$Views.SP_DCPGetStudent(101, NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetTeacher(100);
SELECT * FROM $APP_NAME$Views.SP_DCPGetTeacherClass(100, 100);
SELECT * FROM $APP_NAME$Views.SP_DCPGetTeacherClass(100, NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetTeacherBudget(100);
SELECT * FROM $APP_NAME$Views.SP_DCPGetUser(100,'MyTeacher',NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetUserReputationEvent(100,NULL,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetUserBadge(100,NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPGetUserNotification(100,NULL,NULL,NULL,NULL);

-- Other
SELECT * FROM $APP_NAME$Views.SP_DCPDeactivateUser(101);
SELECT * FROM $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'getuserdisplayinfo',NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearnewrepnotification',NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearusernotifications',NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearusernotifications','BD');

SELECT * FROM SP_DCPGetFile(100);

-- Delete objects
SELECT * FROM $APP_NAME$Views.SP_DCPClearUserNotification(100, NULL, NULL, NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPClearUserNotification(100, NULL, NULL, 'BD');
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteClass(100);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteSchool(100);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteFile(100);

SELECT * FROM $APP_NAME$Views.SP_DCPDeleteUser(100);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteUser(101);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteUser(102);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteUser(103);

SELECT * FROM $APP_NAME$Views.SP_DCPChangeContractStatus(100,'D');
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteContract(100);
SELECT * FROM $APP_NAME$Views.SP_DCPDeleteContract(1); -- Delete duplicate contract

-- Meta
SELECT * FROM $APP_NAME$Views.SP_DCPGetNextId('dummyvalue');
