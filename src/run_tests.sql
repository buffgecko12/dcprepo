-- Create objects
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'some_object');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(2, 'VW', 'some_view');

-- Create Roles (do NULL ID upsert first to preserve next ID ordering)
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, NULL, 'Some role', 'Some description', NULL, '{200}', NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(2, 'PG', 'Some role (school 1)', 'Some description', NULL, '{100}', NULL, NULL, TRUE);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(3, NULL, 'Some role (school 2)', 'Some description', NULL, '{200}', NULL, NULL, NULL);

-- Update files
SELECT $APP_NAME$Views.SP_DCPUpsertFile(100,'MySchoolDataPolicy','.pdf',1000,'pdf','My description','DB',NULL,NULL,NULL,'Other','MS',NULL,NULL,NULL,NULL,2020);
SELECT $APP_NAME$Views.SP_DCPUpsertFileBatch(JSONB('[{"filename": "filetest1", "filesource":"GD", "alternatefileid": "12345"}]'));
SELECT $APP_NAME$Views.SP_DCPUpdateFileAttributes(ARRAY[ 1,2], JSONB('{"fileclass":"PG"}'), JSONB('[{"roleid": "3", "aclinfo": [{"objectid": 2, "objectclass": "FL", "accesslevel": 4}]}]'));

SELECT $APP_NAME$Views.SP_DCPUpsertRoleACL(2, 100, 'FL', 4, NULL); -- Set role ACL

-- Add reward info
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 2020, 'Pizza', 'Pizza y gaseosa.', 5000, 'FD', 'Pizza Show', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertReward(2, 2020, 'Tiquetes al cine', 'Tiquetes al cine en Innovo.', 6000, 'ET', 'Innovo', NULL);

-- Create schools/classes
SELECT $APP_NAME$Views.SP_DCPUpsertSchool(100, 'TS1', 'Test School 1', 'My Address','Duitama','Boyaca'); -- Schools
SELECT $APP_NAME$Views.SP_DCPUpsertSchool(200, 'TS1', 'Test School 2', 'My Address','Tunja','Boyaca'); -- Schools
SELECT $APP_NAME$Views.SP_DCPUpsertClass(100, 100, 2020, '10-03', 10, NULL); -- Classes
SELECT $APP_NAME$Views.SP_DCPUpsertClass(101, 100, 2020, '10-01', 10, NULL); -- Classes
SELECT $APP_NAME$Views.SP_DCPUpsertClass(102, 100, 2020, '9-05', 9, NULL); -- Classes

-- Create school-related items (rubric, calendar, rewards)
SELECT $APP_NAME$Views.SP_DCPUpsertSchoolReward(100,1,NULL,2020,1000);
SELECT $APP_NAME$Views.SP_DCPUpsertSchoolReward(200,NULL,JSONB('[{"rewardid":1,"rewardvalue":1000},{"rewardid":2,"rewardvalue":4000}]'),2020,0);
SELECT $APP_NAME$Views.SP_DCPGetSchoolReward(100, 1, NULL, NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertSchoolCalendar(NULL,100,2020,CURRENT_DATE,'CTE','Entrega',1,NULL);
SELECT $APP_NAME$Views.SP_DCPGetSchoolCalendar(NULL,NULL,NULL,NULL,NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertSchoolRubric(NULL,100,2020,'PT','Entrega de los contratos','Entrega',50);
SELECT $APP_NAME$Views.SP_DCPUpsertSchoolRubric(NULL,100,2020,'PT','Entrega de las evidencias','Evidencias',50);
SELECT $APP_NAME$Views.SP_DCPGetSchoolRubric(NULL,NULL,NULL);

-- Add users
SELECT $APP_NAME$Views.SP_DCPUpsertUser (100, 100, 'MyTeacher','TR','Joe','Smith','joe1@smith.com',NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUser (101, 100, 'MyStudent1','ST','Nic','Cage','nic@cage.com',NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUser (102, 100, 'MyStudent2','ST','Sean','Connery','the@besht.com',NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUser (103, 100, 'MyStudent3','ST','Elsa','Benitez','the@burger.com',NULL,NULL,NULL,NULL);

-- Add user notification
SELECT $APP_NAME$Views.SP_DCPUpsertUserNotification (100, 1001, NULL);

-- Add teacher info
SELECT $APP_NAME$Views.SP_DCPUpsertTeacherClass(100,100,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertTeacherClass(100,NULL,'{101,102}');

-- Program
SELECT $APP_NAME$Views.SP_DCPUpsertProgram('testprogram', 0, 2020, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUserProgram(100, 'testprogram', 100, 2020, 400000, NULL, NULL);

-- Get reward info
SELECT $APP_NAME$Views.SP_DCPGetReward(1,NULL);

-- Delete school-related items
SELECT $APP_NAME$Views.SP_DCPDeleteSchoolReward(100,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteSchoolCalendar(NULL,100,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteSchoolRubric(NULL,100,NULL);

-- Delete reward
SELECT $APP_NAME$Views.SP_DCPDeleteReward(1);
SELECT $APP_NAME$Views.SP_DCPDeleteReward(2);

-- Add contract
SELECT $APP_NAME$Views.SP_DCPUpsertContract( -- No party info
	100, 2020, 'Reading activity', 1, TSTZRANGE(CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1' MONTH),
	NULL, NULL, NULL, 'A', 'Some notes', JSONB('[{"teacheruserid":100,"classid":101},{"teacheruserid":100,"classid":102}]')
);

-- Update contract
SELECT $APP_NAME$Views.SP_DCPUpsertContract( -- Change (no party info)
	100, 2020, 'Reading activity', 2, TSTZRANGE(CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1' MONTH),
	NULL, NULL, NULL, 'A', 'Some notes', NULL
);

-- Contract party / reward info
SELECT $APP_NAME$Views.SP_DCPUpsertContractParty(100,100,100,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertContractParty(100,NULL,NULL,NULL,NULL,JSONB('[
	{"teacheruserid":100,"classid":100,"numparticipants":null,"numwinners":null},
	{"teacheruserid":100,"classid":101,"numparticipants":10,"numwinners":null},
	{"teacheruserid":100,"classid":102,"numparticipants":10,"numwinners":5}
]')
);
SELECT $APP_NAME$Views.SP_DCPUpsertContractPartyReward(100,100,100,1, 10, 10000,NULL);

-- Object
SELECT $APP_NAME$Views.SP_DCPGetObject(NULL, 'BO', NULL);

-- Role / ACL
SELECT $APP_NAME$Views.SP_DCPGetRole();
SELECT $APP_NAME$Views.SP_DCPGetRoleACL(NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPCheckUserObjectAccess(100,100,'FL',4); -- Check read access on specified file for given user
SELECT $APP_NAME$Views.SP_DCPModifyRoleItem(1,100,NULL,NULL,'A');

-- Get contract info
SELECT $APP_NAME$Views.SP_DCPGetContract(100,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetContractValue(NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetContractParty(100,100,NULL);
SELECT $APP_NAME$Views.SP_DCPGetContractPartyReward(100,NULL,NULL,NULL);

-- Get school / class info
SELECT $APP_NAME$Views.SP_DCPGetSchool(100);
SELECT $APP_NAME$Views.SP_DCPGetClass(100,NULL,NULL,NULL,NULL);

-- Program
SELECT $APP_NAME$Views.SP_DCPGetProgram();

-- Get user info
SELECT $APP_NAME$Views.SP_DCPGetTeacherClass(100, 100);
SELECT $APP_NAME$Views.SP_DCPGetTeacherClass(100, NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserProgram(100, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPGetUser(100,'MyTeacher',NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserReputationEvent(100,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserBadge(100,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserNotification(100,NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserProfilePicture(100);

-- Other
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'getuserdisplayinfo',NULL);
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearnewrepnotification',NULL);
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearusernotifications',NULL);
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearusernotifications','BD');

SELECT SP_DCPGetFile(NULL, NULL,NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT SP_DCPGetFileHierarchy(NULL, NULL,NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- Delete objects
SELECT $APP_NAME$Views.SP_DCPClearUserNotification(100, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPClearUserNotification(100, NULL, NULL, 'BD');
SELECT $APP_NAME$Views.SP_DCPDeleteClass(100);
SELECT $APP_NAME$Views.SP_DCPDeleteSchool(100);
SELECT $APP_NAME$Views.SP_DCPDeleteSchool(200);
SELECT $APP_NAME$Views.SP_DCPDeleteFile(100, NULL, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteFile(NULL, NULL, NULL, '12345', NULL);

-- Object
SELECT $APP_NAME$Views.SP_DCPDeleteObject(NULL,NULL);

-- Role / ACL
SELECT $APP_NAME$Views.SP_DCPDeleteRoleACL(3, 100, 'FL');
SELECT $APP_NAME$Views.SP_DCPDeleteRole(2, NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteRole(NULL, TRUE);

-- User
SELECT $APP_NAME$Views.SP_DCPDeleteUser(100);
SELECT $APP_NAME$Views.SP_DCPDeleteUser(101);
SELECT $APP_NAME$Views.SP_DCPDeleteUser(102);
SELECT $APP_NAME$Views.SP_DCPDeleteUser(103);

-- Delete contract party / reward
SELECT $APP_NAME$Views.SP_DCPDeleteContractPartyReward(100,1,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteContractPartyReward(100,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteContractParty(100,100,NULL);

SELECT $APP_NAME$Views.SP_DCPDeleteContract(100);

SELECT $APP_NAME$Views.SP_DCPDeleteTeacherClass(100,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteUserProgram(100,'testprogram',100,2020);

-- Program
SELECT $APP_NAME$Views.SP_DCPDeleteProgram('testprogram', NULL, 2020);

-- Meta
SELECT $APP_NAME$Views.SP_DCPGetNextId('dummyvalue');
SELECT $APP_NAME$Views.SP_DCPGetCategory('reward','PT');

-- Reset counters
-- UPDATE $APP_NAME$.NextId SET NextValue = 1;
