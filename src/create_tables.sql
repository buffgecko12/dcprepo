-- Tables must be created in correct order to allow for referential integrity constraints

-- Permissions
CREATE TABLE $APP_NAME$.Role (
	RoleId INTEGER NOT NULL,
	Name VARCHAR(100) NOT NULL UNIQUE,
	Description VARCHAR(500),
	PublicFlag BOOLEAN,
	SchoolList INTEGER[],
	UserTypeList CHAR(2)[],
	UserList INTEGER[],
	PRIMARY KEY (RoleId)
);

CREATE TABLE $APP_NAME$.Role_ACL (
	RoleId INTEGER NOT NULL,
	ObjectId INTEGER NOT NULL,
	ObjectClass CHAR(2) NOT NULL,
	AccessLevel SMALLINT NOT NULL,
	PRIMARY KEY (RoleId, ObjectId, ObjectClass),
	FOREIGN KEY (RoleId) REFERENCES $APP_NAME$.Role (RoleId)
);

CREATE TABLE $APP_NAME$.Object(
	ObjectID INTEGER NOT NULL,
	ObjectClass CHAR(2) NOT NULL,
	ObjectName VARCHAR(100) NOT NULL UNIQUE,
	PRIMARY KEY(ObjectID)
);

-- LOOKUP: Next ID
CREATE TABLE $APP_NAME$.NextId (
    IDType VARCHAR(50) NOT NULL,
    NextValue INTEGER NOT NULL,
    PRIMARY KEY (IDType)
);

-- LOOKUP: Category
CREATE TABLE $APP_NAME$.Lookup_Category (
	CategoryClass VARCHAR(50) NOT NULL,
	CategoryType VARCHAR(10) NOT NULL,
	CategoryDisplayName VARCHAR(100),
	Description VARCHAR(500),
	PRIMARY KEY(CategoryClass, CategoryType)
);

-- LOOKUP: Rewards
CREATE TABLE $APP_NAME$.Reward (
	RewardId INTEGER NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	RewardDisplayName VARCHAR(100) NOT NULL,
	RewardDescription VARCHAR(500),
	RewardValue INTEGER NOT NULL DEFAULT 0,
	RewardCategory VARCHAR(10),
	Vendor VARCHAR(100),
    StartTS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndTS TIMESTAMP NOT NULL DEFAULT TIMESTAMP '9999-12-31 23:59:59',
	PRIMARY KEY(RewardId, EndTS)
);

-- LOOKUP: Profile pictures
CREATE TABLE $APP_NAME$.Lookup_Profile_Picture (
	ProfilePictureId SERIAL NOT NULL,
	BadgeLevel CHAR(1) NOT NULL,
    FilePath VARCHAR(250),
    FileName VARCHAR(250),
    FileExtension VARCHAR(50),
    Description VARCHAR(500),
	PRIMARY KEY(ProfilePictureId)
);

-- LOOKUP: Events
CREATE TABLE $APP_NAME$.Lookup_Event (
	EventId INTEGER NOT NULL,
	EventType CHAR(2) NOT NULL,
	EventClass CHAR(2) NOT NULL,
	EventUserType CHAR(2),
	EventDisplayName VARCHAR(100) NOT NULL,
	EventMessage VARCHAR(500),
	DefaultReputationPointValue INTEGER,
	PRIMARY KEY(EventId)
);

-- LOOKUP: Badges
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

-- Schools
CREATE TABLE $APP_NAME$.School (
	SchoolId INTEGER NOT NULL,
	SchoolAbbreviation VARCHAR(25) NOT NULL,
	SchoolDisplayName VARCHAR(100) NOT NULL,
	Address VARCHAR(100),
	City VARCHAR(100),
	Department VARCHAR(100),
    StartTS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndTS TIMESTAMP NOT NULL DEFAULT TIMESTAMP '9999-12-31 23:59:59',
	PRIMARY KEY (SchoolId, EndTS)
);

-- School calendar
CREATE TABLE $APP_NAME$.School_Calendar (
	CalendarItemId SERIAL NOT NULL,
	SchoolId INTEGER NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	ItemDate DATE NOT NULL,
	ItemType VARCHAR(10) NOT NULL,
	ItemNotes VARCHAR(500),
	Round SMALLINT,
	PRIMARY KEY (CalendarItemId)
--	FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School (SchoolId) -- Can't use with history rows
);

-- School rewards
CREATE TABLE $APP_NAME$.School_Reward (
	SchoolId INTEGER NOT NULL,
	RewardId INTEGER NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	RewardValue INTEGER NOT NULL,
	PRIMARY KEY (SchoolId, RewardId)
--	FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School (SchoolId) -- Can't use with history rows
--	FOREIGN KEY (RewardId) REFERENCES $APP_NAME$.Reward (RewardId) -- Can't use with history rows
);

-- School rubric
CREATE TABLE $APP_NAME$.School_Rubric (
	RubricItemId SERIAL NOT NULL,
	SchoolId INTEGER NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	Category CHAR(2) NOT NULL,
	Criterion VARCHAR(100) NOT NULL,
	Description VARCHAR(500),
	Weight SMALLINT,
	PRIMARY KEY (RubricItemId)
--	FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School (SchoolId) -- Can't use with history rows
);

-- Classes
CREATE TABLE $APP_NAME$.Class (
	ClassId INTEGER NOT NULL,
	SchoolId INTEGER NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	ClassDisplayName VARCHAR(100) NOT NULL,
	GradeLevel SMALLINT,
	NumStudentSurveys SMALLINT,
	PRIMARY KEY (ClassId)
--	FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School (SchoolId) -- Can't use with history rows
);

-- USER: Profile
CREATE TABLE $APP_NAME$.Users (
    UserId INTEGER NOT NULL,
    SchoolId INTEGER,
    UserName VARCHAR(50) NOT NULL,
    UserType CHAR(2) NOT NULL DEFAULT 'ST',
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    EmailAddress VARCHAR(250),
    Password VARCHAR(128),
    ReputationValue INTEGER DEFAULT 0,
    ReputationValueLastSeenTS TIMESTAMP WITH TIME ZONE,
    ProfilePictureId INTEGER,
    Last_Login TIMESTAMP WITH TIME ZONE,
	Is_Active BOOLEAN, -- Required for django authentication
    PRIMARY KEY(UserId)
--    FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School(SchoolId)
);

-- USER: Badges
CREATE TABLE $APP_NAME$.User_Badge (
	UserId INTEGER NOT NULL,
	BadgeId INTEGER NOT NULL,
	BadgeAchievedTS TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (UserId, BadgeId)
);

-- USER: Profile picture
CREATE TABLE $APP_NAME$.User_Profile_Picture (
	UserId INTEGER NOT NULL,
	ProfilePictureId INTEGER NOT NULL,
	SourceBadgeId INTEGER,
	ProfilePictureAddedTS TIMESTAMP WITH TIME ZONE,
	PRIMARY KEY(UserId, ProfilePictureId),
	FOREIGN KEY(UserId) REFERENCES $APP_NAME$.Users(UserId),
	FOREIGN KEY(ProfilePictureId) REFERENCES $APP_NAME$.Lookup_Profile_Picture(ProfilePictureId)
);

-- TEACHER: Program summary
CREATE TABLE $APP_NAME$.Teacher_Program (
	TeacherUserId INTEGER NOT NULL,
	SchoolYear SMALLINT NOT NULL,
	SchoolId INTEGER NOT NULL,
	MaxBudget INTEGER,
	TeacherSurveyTS TIMESTAMP WITH TIME ZONE,
	StudentSurveyURL VARCHAR(500),
	Notes VARCHAR(500),
    StartTS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndTS TIMESTAMP NOT NULL DEFAULT TIMESTAMP '9999-12-31 23:59:59',
	PRIMARY KEY (TeacherUserId, SchoolYear, EndTS),
	FOREIGN KEY (TeacherUserId) REFERENCES $APP_NAME$.Users (UserId)
--	FOREIGN KEY (SchoolId) REFERENCES $APP_NAME$.School (SchoolId) -- Can't use with history rows
);

-- TEACHER: Classes
CREATE TABLE $APP_NAME$.Teacher_Class (
	TeacherUserId INTEGER NOT NULL,
	ClassId INTEGER NOT NULL,
	PRIMARY KEY (TeacherUserId, ClassId),
	FOREIGN KEY (TeacherUserId) REFERENCES $APP_NAME$.Users (UserId),
	FOREIGN KEY (ClassId) REFERENCES $APP_NAME$.Class (ClassId)
);

-- CONTRACT: Info
CREATE TABLE $APP_NAME$.Contract (
    ContractId INTEGER NOT NULL,
    SchoolYear SMALLINT NOT NULL,
    ContractName VARCHAR(100),
    Round SMALLINT,
    ContractValidPeriod TSTZRANGE,
    ProposalTS TIMESTAMP WITH TIME ZONE,
    EvaluationTS TIMESTAMP WITH TIME ZONE,
    EvidenceTS TIMESTAMP WITH TIME ZONE,
    ContractStatus CHAR(1),
    Notes VARCHAR(500),
    StartTS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndTS TIMESTAMP NOT NULL DEFAULT TIMESTAMP '9999-12-31 23:59:59',
    PRIMARY KEY (ContractId, EndTS)
);

-- CONTRACT: Parties (i.e. classes)
CREATE TABLE $APP_NAME$.Contract_Party (
    ContractId INTEGER NOT NULL,
    TeacherUserId INTEGER NOT NULL,
    ClassId INTEGER NOT NULL DEFAULT 0,
    NumParticipants SMALLINT,
    NumWinners SMALLINT,
    PRIMARY KEY (ContractId, TeacherUserId, ClassId),
--    FOREIGN KEY (ContractId) REFERENCES $APP_NAME$.Contract (ContractId), -- Can't use with history rows
    FOREIGN KEY (TeacherUserId, ClassId) REFERENCES $APP_NAME$.Teacher_Class (TeacherUserId, ClassId)    
);

-- CONTRACT: Rewards
CREATE TABLE $APP_NAME$.Contract_Party_Reward (
	ContractId INTEGER NOT NULL,
	TeacherUserId INTEGER NOT NULL,
	ClassId INTEGER NOT NULL,
	RewardId INTEGER NOT NULL,
	Quantity SMALLINT NOT NULL,
	ActualRewardValue INTEGER NOT NULL,
	Status CHAR(1),
	PRIMARY KEY (ContractId, TeacherUserId, ClassId, RewardId),
	FOREIGN KEY (ContractId, TeacherUserId, ClassId) REFERENCES $APP_NAME$.Contract_Party (ContractId, TeacherUserId, ClassId)
--	FOREIGN KEY (RewardId) REFERENCES $APP_NAME$.Reward (RewardId) -- Can't use with history rows
);

-- USER: Reputation events
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

-- USER: Notifications
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

-- Files
CREATE TABLE $APP_NAME$.File (
    FileId INTEGER NOT NULL,
    FileName VARCHAR(500) NOT NULL,
    FileExtension VARCHAR(50),
    FileSize INTEGER,
    FileType VARCHAR(100),
    FileDescription VARCHAR(500),
    FileSource CHAR(2),
    FileData BYTEA,
    FileURL VARCHAR(500),
    FilePath VARCHAR(256),
    FileClass VARCHAR(50),
    FileCategory VARCHAR(10),
    FileAttributes JSONB,
    AlternateFileId VARCHAR(256),
    ContractId INTEGER,
    SchoolId INTEGER,
    SchoolYear SMALLINT,
    StartTS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    EndTS TIMESTAMP NOT NULL DEFAULT TIMESTAMP '9999-12-31 23:59:59',
    PRIMARY KEY (FileId, EndTS)
--    FOREIGN KEY (ContractId) REFERENCES $APP_NAME$.Contract (ContractId) -- Can't use with history rows
);

-- Sample table
CREATE TABLE $APP_NAME$.t1 (c1 VARCHAR(100));
INSERT INTO $APP_NAME$.t1 (c1) VALUES('$DB_CHECK_VALUE$');