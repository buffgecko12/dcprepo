-- Tables must be created in correct order to allow for referential integrity constraints
-- TO-DO: Add temporal support (DEFAULT(TSTZRANGE(current_timestamp,'infinity','[]')))

-- Schools
CREATE TABLE $DB_NAME$.School (
	SchoolId INTEGER NOT NULL,
	SchoolDisplayName VARCHAR(100) NOT NULL,
	Address VARCHAR(100),
	City VARCHAR(100),
	Department VARCHAR(100),
	PRIMARY KEY (SchoolId)
);

-- Classes
CREATE TABLE $DB_NAME$.Class (
	ClassId INTEGER NOT NULL,
	SchoolId INTEGER NOT NULL,
	ClassDisplayName VARCHAR(100) NOT NULL,
	PRIMARY KEY (ClassId),
	FOREIGN KEY (SchoolId) REFERENCES $DB_NAME$.School (SchoolId)
);

-- User profiles
CREATE TABLE $DB_NAME$.Users (
    UserId INTEGER NOT NULL,
    UserName VARCHAR(50) NOT NULL,
    UserType CHAR(2) NOT NULL DEFAULT 'ST',
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DefaultSignatureScanFile BYTEA,
    PhoneNumber VARCHAR(25),
    EmailAddress VARCHAR(250),
    Password VARCHAR(128),
    ReputationValue INTEGER DEFAULT 0,
    UserRole CHAR(1),
    Last_Login TIMESTAMP WITH TIME ZONE,
    DeactivatedTS TIMESTAMP WITH TIME ZONE,
    -- TO-DO: May need to add separate field to access source "user" table from school (i.e. cedula/StudentIdNo)
    PRIMARY KEY(UserId)
);

-- Additional teacher user info
CREATE TABLE $DB_NAME$.User_Teacher (
	TeacherUserId INTEGER NOT NULL,
	PRIMARY KEY (TeacherUserId),
	FOREIGN KEY (TeacherUserId) REFERENCES $DB_NAME$.Users (UserId)

);

-- Classes associated with a teacher
CREATE TABLE $DB_NAME$.User_Teacher_Class (
	TeacherUserId INTEGER NOT NULL,
	ClassId INTEGER NOT NULL,
	PRIMARY KEY (TeacherUserId, ClassId),
	FOREIGN KEY (TeacherUserId) REFERENCES $DB_NAME$.User_Teacher (TeacherUserId),
	FOREIGN KEY (ClassId) REFERENCES $DB_NAME$.Class (ClassId)
);

-- Additional student user info
CREATE TABLE $DB_NAME$.User_Student (
	StudentUserId INTEGER NOT NULL,
	ClassId INTEGER NOT NULL,
	PRIMARY KEY (StudentUserId),
	FOREIGN KEY (StudentUserId) REFERENCES $DB_NAME$.Users (UserId),
	FOREIGN KEY (ClassId) REFERENCES $DB_NAME$.Class (ClassId)
);

-- Main contract
CREATE TABLE $DB_NAME$.Contract (
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
    PRIMARY KEY (ContractId),
    FOREIGN KEY (ClassId, TeacherUserId) REFERENCES $DB_NAME$.User_Teacher_Class (ClassId, TeacherUserId)
);

-- Contract parties (students, teachers)
CREATE TABLE $DB_NAME$.Contract_Party (
    ContractId INTEGER NOT NULL,
    PartyUserId INTEGER NOT NULL,
    ContractRole CHAR(2) NOT NULL DEFAULT 'PT', -- Set default to "participant"
    PRIMARY KEY (ContractId, PartyUserId),
    FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract (ContractId),
    FOREIGN KEY (PartyUserId) REFERENCES $DB_NAME$.Users (UserId)    
);

CREATE TABLE $DB_NAME$.Contract_Party_Approval (
	ContractId INTEGER NOT NULL,
	PartyUserId INTEGER NOT NULL,
	ApprovalType CHAR(1) NOT NULL,
	SignatureScanFile BYTEA,
	ApprovalTS TIMESTAMP WITH TIME ZONE,
	LogonUserId INTEGER NOT NULL,
	PRIMARY KEY (ContractId, PartyUserId, ApprovalType),
	FOREIGN KEY (LogonUserId) REFERENCES $DB_NAME$.Users (UserId),
	FOREIGN KEY (ContractId, PartyUserId) REFERENCES $DB_NAME$.Contract_Party(ContractId, PartyUserId)
);

-- Contract goals
CREATE TABLE $DB_NAME$.Contract_Goal (
    ContractId INTEGER NOT NULL,
    GoalId INTEGER NOT NULL,
    DifficultyLevel CHAR(1) NOT NULL DEFAULT 'M',
    GoalDescription VARCHAR(500) NOT NULL,
    AcceptedFlag BOOLEAN,
    AchievedFlag BOOLEAN,
    PRIMARY KEY (ContractId, GoalId),
    FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract (ContractId)
);

-- Contract rewards
CREATE TABLE $DB_NAME$.Contract_Reward (
	ContractId INTEGER NOT NULL,
	RewardId INTEGER NOT NULL,
	DifficultyLevel CHAR(1) NOT NULL DEFAULT 'M',
	RewardDescription VARCHAR(500) NOT NULL,
	PRIMARY KEY (ContractId, RewardId),
	FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract (ContractId)
);

-- Reward selected for each contract goal for each student
CREATE TABLE $DB_NAME$.Contract_Party_Goal_Reward (
	ContractId INTEGER NOT NULL,
	PartyUserId INTEGER NOT NULL,
	GoalId INTEGER NOT NULL,
	RewardId INTEGER NOT NULL,
	RewardDeliveredFlag BOOLEAN,
	PRIMARY KEY (ContractId, PartyUserId, GoalId, RewardId),
	FOREIGN KEY (ContractId, GoalId) REFERENCES $DB_NAME$.Contract_Goal (ContractId, GoalId),
	FOREIGN KEY (ContractId, RewardId) REFERENCES $DB_NAME$.Contract_Reward (ContractId, RewardId),
	FOREIGN KEY (ContractId, PartyUserId) REFERENCES $DB_NAME$.Contract_Party (ContractId, PartyUserId)
);

-- Events that affect user reputation
CREATE TABLE $DB_NAME$.User_Reputation_Event (
	EventId BIGSERIAL NOT NULL,
	UserId INTEGER NOT NULL,
	EventType CHAR(2) NOT NULL,
	EventTS TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PointValue INTEGER NOT NULL,
	ContractId INTEGER,
	PRIMARY KEY (EventId),
	FOREIGN KEY (UserId) REFERENCES $DB_NAME$.Users (UserId),
	FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract (ContractId)
);

-- Next ID lookup
CREATE TABLE $DB_NAME$.NextId (
    IDType VARCHAR(50) NOT NULL,
    NextValue INTEGER NOT NULL,
    PRIMARY KEY (IDType)
);

-- Sample table
CREATE TABLE $DB_NAME$.t1 (c1 VARCHAR(100));
INSERT INTO $DB_NAME$.t1 (c1) VALUES('$DB_CHECK_VALUE$');
