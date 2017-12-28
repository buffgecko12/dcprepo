-- Create tables
CREATE TABLE $DB_NAME$.User (
    UserId INTEGER NOT NULL,
    UserType CHAR(2) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    SignatureScanFile BYTEA,
    -- May need to add separate key to access source "user" table from school (i.e. cedula/StudentIdNo)
    PRIMARY KEY(UserId)
);

CREATE TABLE $DB_NAME$.Contract (
    ContractId INTEGER NOT NULL,
    ClassId VARCHAR(50) NOT NULL,
    TeacherUserId INTEGER NOT NULL,
    ContractStartTS TIMESTAMPTZ NOT NULL,
    ContractEndTS TIMESTAMPTZ NOT NULL,
    RevisionDeadlineTS TIMESTAMPTZ NOT NULL,
    RewardNotes VARCHAR(500),
    StudentLeaderRequirements VARCHAR(500),
    TeacherRequirements VARCHAR(500),
    StudentRequirements VARCHAR(500),
    ContractScanFile BYTEA, -- Same as BLOB data type
    PRIMARY KEY (ContractId),
    FOREIGN KEY (TeacherUserId) REFERENCES $DB_NAME$.User (UserId)
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
    SignatureTS TIMESTAMPTZ,
    PRIMARY KEY (ContractId, PartyUserId),
    FOREIGN KEY (ContractId) REFERENCES $DB_NAME$.Contract(ContractId),
    FOREIGN KEY (PartyUserId) REFERENCES $DB_NAME$.User(UserId)    
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