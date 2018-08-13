-- Tables must be created in correct order to allow for referential integrity constraints
-- TO-DO: Add temporal support (DEFAULT(TSTZRANGE(current_timestamp,'infinity','[]')))

CREATE TABLE $APP_NAME$.Binary_File (
    FileId INTEGER NOT NULL,
    FileName VARCHAR(500),
    FileExtension VARCHAR(50),
    FileSize INTEGER,
    FileType VARCHAR(100),
    FileDescription VARCHAR(500),
    FileData BYTEA,
    AccessClass CHAR(2),
    PRIMARY KEY (FileId)
);

-- Schools
CREATE TABLE $APP_NAME$.School (
	SchoolId INTEGER NOT NULL,
	SchoolDisplayName VARCHAR(100) NOT NULL,
	SchoolAbbreviation VARCHAR(25),
	Address VARCHAR(100),
	City VARCHAR(100),
	Department VARCHAR(100),
	DataUsePolicyFileId INTEGER,
	GuardianApprovalPolicy JSONB,
	PRIMARY KEY (SchoolId),
	FOREIGN KEY (DataUsePolicyFileId) REFERENCES $APP_NAME$.Binary_File(FileId)
);

-- Classes
CREATE TABLE $APP_NAME$.Class (
	ClassId INTEGER NOT NULL,
	SchoolId INTEGER NOT NULL,
	ClassDisplayName VARCHAR(100) NOT NULL,
	PRIMARY KEY (ClassId),
	FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School (SchoolId)
);

CREATE TABLE $APP_NAME$.Lookup_Event (
	EventId INTEGER,
	EventType CHAR(2) NOT NULL,
	EventClass CHAR(2) NOT NULL,
	EventUserType CHAR(2),
	EventDisplayName VARCHAR(100) NOT NULL,
	EventMessage VARCHAR(500),
	DefaultReputationPointValue INTEGER,
	PRIMARY KEY(EventId)
);

-- Reputation event info
CREATE TABLE $APP_NAME$.Lookup_Badge (
	BadgeId INTEGER NOT NULL,
	BadgeLevel CHAR(1) NOT NULL,
	BadgeThresholdValue INTEGER,
	BadgeShortName VARCHAR(50), -- Used for icon
	BadgeDisplayName VARCHAR(50) NOT NULL,
	BadgeDescription VARCHAR(500),
	SourceEventId INTEGER,
	PRIMARY KEY(BadgeId),
	FOREIGN KEY(SourceEventId) REFERENCES $APP_NAME$.Lookup_Event(EventId)
);

-- Reputation event info
CREATE TABLE $APP_NAME$.Lookup_Profile_Picture (
	ProfilePictureId SERIAL NOT NULL,
	BadgeLevel CHAR(1) NOT NULL,
    FilePath VARCHAR(250),
    FileName VARCHAR(250),
    FileExtension VARCHAR(50),
    Description VARCHAR(500),
	PRIMARY KEY(ProfilePictureId)
);

-- Events that affect user reputation
CREATE TABLE $APP_NAME$.User_Badge (
	UserId INTEGER NOT NULL,
	BadgeId INTEGER NOT NULL,
	BadgeAchievedTS TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (UserId, BadgeId)
);

-- User profiles
CREATE TABLE $APP_NAME$.Users (
    UserId INTEGER NOT NULL,
    SchoolId INTEGER,
    UserName VARCHAR(50) NOT NULL UNIQUE,
    UserType CHAR(2) NOT NULL DEFAULT 'ST',
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DefaultSignatureScanFile BYTEA,
    PhoneNumber VARCHAR(25),
    EmailAddress VARCHAR(250),
    Password VARCHAR(128),
    ReputationValue INTEGER DEFAULT 0,
    ReputationValueLastSeenTS TIMESTAMP WITH TIME ZONE,
    UserRole CHAR(1),
    ProfilePictureId INTEGER,
    Last_Login TIMESTAMP WITH TIME ZONE,
	Is_Active BOOLEAN, -- Required for django authentication
	DataUsePolicyAcceptedTS TIMESTAMP WITH TIME ZONE,
    -- TO-DO: May need to add separate field to access source "user" table from school (i.e. cedula/StudentIdNo)
    PRIMARY KEY(UserId),
    FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School(SchoolId)
);

CREATE TABLE $APP_NAME$.User_Profile_Picture (
	UserId INTEGER NOT NULL,
	ProfilePictureId INTEGER NOT NULL,
	SourceBadgeId INTEGER,
	ProfilePictureAddedTS TIMESTAMP WITH TIME ZONE,
	PRIMARY KEY(UserId, ProfilePictureId),
	FOREIGN KEY(UserId) REFERENCES $APP_NAME$.Users(UserId),
	FOREIGN KEY(ProfilePictureId) REFERENCES $APP_NAME$.Lookup_Profile_Picture(ProfilePictureId)
);

-- Additional teacher user info
CREATE TABLE $APP_NAME$.User_Teacher (
	TeacherUserId INTEGER NOT NULL,
	MaxBudget INTEGER,
	PRIMARY KEY (TeacherUserId),
	FOREIGN KEY (TeacherUserId) REFERENCES $APP_NAME$.Users (UserId)
);

-- Classes associated with a teacher
CREATE TABLE $APP_NAME$.User_Teacher_Class (
	TeacherUserId INTEGER NOT NULL,
	ClassId INTEGER NOT NULL,
	PRIMARY KEY (TeacherUserId, ClassId),
	FOREIGN KEY (TeacherUserId) REFERENCES $APP_NAME$.User_Teacher (TeacherUserId),
	FOREIGN KEY (ClassId) REFERENCES $APP_NAME$.Class (ClassId)
);

-- Additional student user info
CREATE TABLE $APP_NAME$.User_Student (
	StudentUserId INTEGER NOT NULL,
	ClassId INTEGER NOT NULL,
	PRIMARY KEY (StudentUserId),
	FOREIGN KEY (StudentUserId) REFERENCES $APP_NAME$.Users (UserId),
	FOREIGN KEY (ClassId) REFERENCES $APP_NAME$.Class (ClassId)
);

-- Main contract
CREATE TABLE $APP_NAME$.Contract (
    ContractId INTEGER NOT NULL,
    ClassId INTEGER NOT NULL,
    ContractType CHAR(1) NOT NULL DEFAULT 'G',
    TeacherUserId INTEGER NOT NULL,
    ContractValidPeriod TSTZRANGE NOT NULL,
    GuardianApprovalFlag BOOLEAN,
    RevisionDeadlineTS TIMESTAMP WITH TIME ZONE NOT NULL,
    RevisionDescription VARCHAR(500),
    RevisionApprovalTS TIMESTAMP WITH TIME ZONE,
    StudentLeaderRequirements VARCHAR(500),
    TeacherRequirements VARCHAR(500),
    StudentRequirements VARCHAR(500),
    ContractScanFile BYTEA,
    ContractApprovalTS TIMESTAMP WITH TIME ZONE,
    ContractStatus CHAR(1),
    TempContractId INTEGER,
    PRIMARY KEY (ContractId),
    FOREIGN KEY (ClassId, TeacherUserId) REFERENCES $APP_NAME$.User_Teacher_Class (ClassId, TeacherUserId)
);

-- Contract parties (students, teachers)
CREATE TABLE $APP_NAME$.Contract_Party (
    ContractId INTEGER NOT NULL,
    PartyUserId INTEGER NOT NULL,
    ContractRole CHAR(2) NOT NULL DEFAULT 'PT', -- Set default to "participant"
    PRIMARY KEY (ContractId, PartyUserId),
    FOREIGN KEY (ContractId) REFERENCES $APP_NAME$.Contract (ContractId),
    FOREIGN KEY (PartyUserId) REFERENCES $APP_NAME$.Users (UserId)    
);

CREATE TABLE $APP_NAME$.Contract_Party_Approval (
	ContractId INTEGER NOT NULL,
	PartyUserId INTEGER NOT NULL,
	ApprovalType CHAR(1) NOT NULL,
	PreferredGoalId INTEGER,
	SignatureScanFile BYTEA,
	GuardianApprovalInfo JSONB,
	PartyApprovalTS TIMESTAMP WITH TIME ZONE,
	LogonUserId INTEGER NOT NULL,
	PRIMARY KEY (ContractId, PartyUserId, ApprovalType),
	FOREIGN KEY (LogonUserId) REFERENCES $APP_NAME$.Users (UserId),
	FOREIGN KEY (ContractId, PartyUserId) REFERENCES $APP_NAME$.Contract_Party(ContractId, PartyUserId)
);

-- Contract goals
CREATE TABLE $APP_NAME$.Contract_Goal (
    ContractId INTEGER NOT NULL,
    GoalId INTEGER NOT NULL,
    DifficultyLevel CHAR(1) NOT NULL DEFAULT 'M',
    GoalDescription VARCHAR(500) NOT NULL,
    AcceptedFlag BOOLEAN,
    MaxNumRewards INTEGER, -- 0 = no limit
    PRIMARY KEY (ContractId, GoalId),
    FOREIGN KEY (ContractId) REFERENCES $APP_NAME$.Contract(ContractId)
);

-- Contract rewards
CREATE TABLE $APP_NAME$.Contract_Goal_Reward (
	ContractId INTEGER NOT NULL,
	GoalId INTEGER NOT NULL,
	RewardId INTEGER NOT NULL,
	PRIMARY KEY (ContractId, GoalId, RewardId),
	FOREIGN KEY (ContractId, GoalId) REFERENCES $APP_NAME$.Contract_Goal (ContractId, GoalId)
);

-- Reward selected for each contract goal for each student
CREATE TABLE $APP_NAME$.Contract_Party_Goal_Reward (
	PartyUserId INTEGER NOT NULL,
	ContractId INTEGER NOT NULL,
	GoalId INTEGER NOT NULL,
	RewardId INTEGER,
	RewardDeliveredFlag BOOLEAN,
	ActualRewardValue INTEGER,
	PRIMARY KEY (ContractId, PartyUserId, GoalId),
	FOREIGN KEY (ContractId, GoalId, RewardId) REFERENCES $APP_NAME$.Contract_Goal_Reward (ContractId, GoalId, RewardId),
	FOREIGN KEY (ContractId, PartyUserId) REFERENCES $APP_NAME$.Contract_Party (ContractId, PartyUserId)
);

-- Events that affect user reputation
CREATE TABLE $APP_NAME$.User_Reputation_Event (
	UserId INTEGER NOT NULL,
	EventId BIGSERIAL NOT NULL,
	SourceEventId INTEGER NOT NULL,
	ContractId INTEGER,
	PointValue INTEGER NOT NULL,
	EventTS TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (EventId),
	FOREIGN KEY (UserId) REFERENCES $APP_NAME$.Users (UserId)
);

CREATE TABLE $APP_NAME$.User_Notification (
	UserId INTEGER NOT NULL,
	NotificationId BIGSERIAL NOT NULL,
	NotificationTS TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	NotificationSeen BOOLEAN,
	NotificationText VARCHAR(500),
	ContractId INTEGER,
	SourceEventId INTEGER,
	PRIMARY KEY (NotificationId),
	FOREIGN KEY (UserId) REFERENCES $APP_NAME$.Users (UserId)
);

-- Reward info
CREATE TABLE $APP_NAME$.Lookup_Reward (
	RewardId INTEGER NOT NULL,
	RewardDisplayName VARCHAR(100) NOT NULL,
	RewardDescription VARCHAR(500) NOT NULL,
	RewardValue INTEGER NOT NULL DEFAULT 0,
    DeactivatedTS TIMESTAMP WITH TIME ZONE,
    GlobalFlag BOOLEAN DEFAULT TRUE,
	CreatedByUserId INTEGER NOT NULL,
	PRIMARY KEY(RewardId),
	FOREIGN KEY(CreatedByUserId) REFERENCES $APP_NAME$.Users(UserId)
);

-- Contract status
CREATE TABLE $APP_NAME$.Lookup_Status (
	Status CHAR(1) NOT NULL,
	StatusDisplayName VARCHAR(50) NOT NULL,
	PRIMARY KEY(Status)
);

-- Next ID lookup
CREATE TABLE $APP_NAME$.NextId (
    IDType VARCHAR(50) NOT NULL,
    NextValue INTEGER NOT NULL,
    PRIMARY KEY (IDType)
);

-- Sample table
CREATE TABLE $APP_NAME$.t1 (c1 VARCHAR(100));
INSERT INTO $APP_NAME$.t1 (c1) VALUES('$DB_CHECK_VALUE$');
