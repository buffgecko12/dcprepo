-- Create objects
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'contract');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(2, 'VW', 'download_file');

-- Create Roles (do NULL ID upsert first to preserve next ID ordering)
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, 'Some role', 'Some description', NULL, '{200}', NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(2, 'Some role (school 1)', 'Some description', NULL, '{100}', NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(3, 'Some role (school 2)', 'Some description', NULL, '{200}', NULL, NULL);

-- Update files
SELECT $APP_NAME$Views.SP_DCPUpsertFile(100,'MySchoolDataPolicy','.pdf',1000,'pdf','My description','DB',NULL,NULL,NULL,'Other','MS',NULL,CAST(2020 AS SMALLINT));
SELECT $APP_NAME$Views.SP_DCPUpsertFile(200,'MySchoolDataPolicy2','.pdf',1000,'pdf','My description','DB',NULL,NULL,NULL,'Other','MS',NULL,CAST(2020 AS SMALLINT));

SELECT $APP_NAME$Views.SP_DCPUpsertRoleACL(2, 200, 'FL', CAST(4 AS SMALLINT)); -- Set role ACL

-- Add reward info
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, CAST(2020 AS SMALLINT), 'Pizza', 'Pizza y gaseosa.', 5000, 'Pizza Show');
SELECT $APP_NAME$Views.SP_DCPUpsertReward(2, CAST(2020 AS SMALLINT), 'Tiquetes al cine', 'Tiquetes al cine en Innovo.', 6000, 'Innovo');

-- Create schools/classes
SELECT $APP_NAME$Views.SP_DCPUpsertSchool(100, 'TS1', 'Test School 1', 'My Address','Duitama','Boyaca'); -- Schools
SELECT $APP_NAME$Views.SP_DCPUpsertSchool(200, 'TS1', 'Test School 2', 'My Address','Tunja','Boyaca'); -- Schools
SELECT $APP_NAME$Views.SP_DCPUpsertClass(100, 100, CAST(2020 AS SMALLINT), '10-03', CAST(10 AS SMALLINT), NULL); -- Classes
SELECT $APP_NAME$Views.SP_DCPUpsertClass(101, 100, CAST(2020 AS SMALLINT), '10-01', CAST(10 AS SMALLINT), NULL); -- Classes
SELECT $APP_NAME$Views.SP_DCPUpsertClass(102, 100, CAST(2020 AS SMALLINT), '9-05', CAST(9 AS SMALLINT), NULL); -- Classes

-- Create school-related items (rubric, calendar, rewards)
SELECT $APP_NAME$Views.SP_DCPUpsertSchoolReward(100,1,NULL,CAST(2020 AS SMALLINT));
SELECT $APP_NAME$Views.SP_DCPUpsertSchoolReward(200,NULL,'{1,2}',CAST(2020 AS SMALLINT));
SELECT $APP_NAME$Views.SP_DCPGetSchoolReward(100,1,NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertSchoolCalendar(NULL,100,CAST(2020 AS SMALLINT),CURRENT_DATE,'Entrega de propuestas','Entrega',CAST(1 AS SMALLINT));
SELECT $APP_NAME$Views.SP_DCPGetSchoolCalendar(NULL,NULL,NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertSchoolRubric(NULL,100,CAST(2020 AS SMALLINT),'PT','Entrega de los contratos','Entrega',CAST(50 AS SMALLINT));
SELECT $APP_NAME$Views.SP_DCPUpsertSchoolRubric(NULL,100,CAST(2020 AS SMALLINT),'PT','Entrega de las evidencias','Evidencias',CAST(50 AS SMALLINT));
SELECT $APP_NAME$Views.SP_DCPGetSchoolRubric(NULL,NULL,NULL);

-- Add users
SELECT $APP_NAME$Views.SP_DCPUpsertUser (100, 100, 'MyTeacher','TR','Joe','Smith','joe1@smith.com',NULL,'U',NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUser (101, 100, 'MyStudent1','ST','Nic','Cage','nic@cage.com',NULL,'U',NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUser (102, 100, 'MyStudent2','ST','Sean','Connery','the@besht.com',NULL,'U',NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertUser (103, 100, 'MyStudent3','ST','Elsa','Benitez','the@shipoopee.com',NULL,'U',NULL,NULL);

-- Add user notification
SELECT $APP_NAME$Views.SP_DCPUpsertUserNotification (100, 1001, NULL);

-- Add teacher info
SELECT $APP_NAME$Views.SP_DCPUpsertTeacherClass(100,100,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertTeacherClass(100,NULL,'{101,102}');
SELECT $APP_NAME$Views.SP_DCPUpsertTeacherProgram(100, CAST(2020 AS SMALLINT), 100, 400000, NULL, NULL, NULL);

-- Get reward info
SELECT $APP_NAME$Views.SP_DCPGetReward(1,CAST(NULL AS SMALLINT));

-- Delete school-related items
SELECT $APP_NAME$Views.SP_DCPDeleteSchoolReward(100,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteSchoolCalendar(NULL,100,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteSchoolRubric(NULL,100,NULL);

-- Delete reward
SELECT $APP_NAME$Views.SP_DCPDeleteReward(1);
SELECT $APP_NAME$Views.SP_DCPDeleteReward(2);

-- Add contract
SELECT $APP_NAME$Views.SP_DCPUpsertContract(
	100, CAST(2020 AS SMALLINT), 'Reading activity', CAST(1 AS SMALLINT), TSTZRANGE(CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1' MONTH),
	NULL, NULL, NULL, 'A', 'Some notes'
);

-- Contract party / reward info
SELECT $APP_NAME$Views.SP_DCPUpsertContractParty(100,100,100,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertContractParty(100,NULL,NULL,NULL,NULL,JSONB('[
	{"contractid":100,"teacheruserid":100,"classid":100,"numparticipants":null,"numwinners":null},
	{"contractid":100,"teacheruserid":100,"classid":101,"numparticipants":10,"numwinners":null},
	{"contractid":100,"teacheruserid":100,"classid":102,"numparticipants":10,"numwinners":5}
]')
);
SELECT $APP_NAME$Views.SP_DCPUpsertContractPartyReward(100,100,100,1, CAST(10 AS SMALLINT), 10000,NULL);

-- Object
SELECT $APP_NAME$Views.SP_DCPGetObject(NULL, 'BO');

-- Role
SELECT $APP_NAME$Views.SP_DCPGetRole(NULL);
SELECT $APP_NAME$Views.SP_DCPCheckUserObjectAccess(100,200,'FL','R'); -- Check read access on specified file for given user

-- Get contract info
SELECT $APP_NAME$Views.SP_DCPGetContract(100,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetContractValue(NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetContractParty(100,100,NULL);
SELECT $APP_NAME$Views.SP_DCPGetContractPartyReward(100,NULL,NULL,NULL);

-- Get school / class info
SELECT $APP_NAME$Views.SP_DCPGetSchool(100);
SELECT $APP_NAME$Views.SP_DCPGetClass(100,NULL,NULL,NULL,NULL);

-- Get user info
SELECT $APP_NAME$Views.SP_DCPGetTeacherClass(100, 100);
SELECT $APP_NAME$Views.SP_DCPGetTeacherClass(100, NULL);
SELECT $APP_NAME$Views.SP_DCPGetTeacherProgram(100, NULL);
SELECT $APP_NAME$Views.SP_DCPGetUser(100,'MyTeacher',NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserReputationEvent(100,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserBadge(100,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserNotification(100,NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPGetUserProfilePicture(100);

-- Other
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'getuserdisplayinfo',NULL);
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearnewrepnotification',NULL);
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearusernotifications',NULL);
SELECT $APP_NAME$Views.SP_DCPManageUserDisplayInfo(100,'clearusernotifications','BD');

SELECT SP_DCPGetFile(100, NULL, NULL, NULL, NULL);

-- Delete objects
SELECT $APP_NAME$Views.SP_DCPClearUserNotification(100, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPClearUserNotification(100, NULL, NULL, 'BD');
SELECT $APP_NAME$Views.SP_DCPDeleteClass(100);
SELECT $APP_NAME$Views.SP_DCPDeleteSchool(100);
SELECT $APP_NAME$Views.SP_DCPDeleteFile(100, NULL);

-- Object
SELECT $APP_NAME$Views.SP_DCPDeleteObject(NULL,NULL);

-- Role / ACL
SELECT $APP_NAME$Views.SP_DCPDeleteRoleACL(3, 200, 'FL');
SELECT $APP_NAME$Views.SP_DCPDeleteRole(2);
SELECT $APP_NAME$Views.SP_DCPDeleteRole(NULL);

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
SELECT $APP_NAME$Views.SP_DCPDeleteContract(1); -- Duplicate Contract
SELECT $APP_NAME$Views.SP_DCPDeleteContract(2); -- Revise Contract
SELECT $APP_NAME$Views.SP_DCPDeleteContract(999); -- Copy Contract

SELECT $APP_NAME$Views.SP_DCPDeleteTeacherClass(100,100);
SELECT $APP_NAME$Views.SP_DCPDeleteTeacherProgram(100,CAST(2020 AS SMALLINT));

-- Meta
SELECT $APP_NAME$Views.SP_DCPGetNextId('dummyvalue');
