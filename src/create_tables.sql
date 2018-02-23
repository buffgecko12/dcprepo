-- TO-DO: Add temporal support (DEFAULT(TSTZRANGE(current_timestamp,'infinity','[]')))

-- Create tables
CREATE TABLE $DB_NAME$.Users (
    UserId INTEGER NOT NULL,
    UserName VARCHAR(50),
    UserType CHAR(2) NOT NULL DEFAULT 'ST',
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DefaultSignatureScanFile BYTEA,
    PhoneNumber VARCHAR(25),
    EmailAddress VARCHAR(250),
    Password VARCHAR(128),
    Last_Login TIMESTAMP WITH TIME ZONE,
    -- TO-DO: May need to add separate field to access source "user" table from school (i.e. cedula/StudentIdNo)
    PRIMARY KEY(UserId)
);

CREATE TABLE $DB_NAME$.Contract (
    ContractId INTEGER NOT NULL,
    ClassId VARCHAR(50) NOT NULL,
    ContractType CHAR(1) NOT NULL DEFAULT 'G',
    TeacherUserId INTEGER NOT NULL,
    ContractValidPeriod TSTZRANGE NOT NULL,
    RevisionDeadlineTS TIMESTAMP WITH TIME ZONE NOT NULL,
    StudentLeaderRequirements VARCHAR(500),
    TeacherRequirements VARCHAR(500),
    StudentRequirements VARCHAR(500)
    PRIMARY KEY (ContractId),
    FOREIGN KEY (TeacherUserId) REFERENCES $DB_NAME$.Users (UserId)
);

CREATE TABLE $DB_NAME$.Contract_Goal (
    ContractId INTEGER NOT NULL,
    GoalId INTEGER NOT NULL,
    GoalDescription VARCHAR(500) NOT NULL,
    RewardDescription VARCHAR(500) NOT NULL,
    AchievedFlag BOOLEAN,
    RewardDeliveredFlag BOOLEAN,
    Comments VARCHAR(1000),
    PRIMARY KEY (ContractId, GoalId),
    FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract(ContractId) -- Produces error if row deleted from referenced table first
);

CREATE TABLE $DB_NAME$.Contract_Party (
    ContractId INTEGER NOT NULL,
    PartyUserId INTEGER NOT NULL,
    ContractRole CHAR(2) NOT NULL DEFAULT 'PT', -- Set default to "participant"
    SignatureTS TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (ContractId, PartyUserId),
    FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract(ContractId),
    FOREIGN KEY (PartyUserId) REFERENCES $DB_NAME$.Users(UserId)    
);

CREATE TABLE $DB_NAME$.NextId (
    IDType VARCHAR(50) NOT NULL,
    NextValue INTEGER NOT NULL,
    PRIMARY KEY (IDType)
);

-- SAMPLE TABLE
CREATE TABLE $DB_NAME$.t1 (c1 VARCHAR(100));
INSERT INTO $DB_NAME$.t1 (c1) VALUES('$DB_CHECK_VALUE$');

-- Load default values
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('Contract', 1);
INSERT INTO $DB_NAME$.NextId (IdType, NextValue) VALUES ('User', 1);