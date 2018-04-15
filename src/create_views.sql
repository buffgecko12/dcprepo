-- User info
CREATE OR REPLACE VIEW $DB_NAME$Views.Users AS 
SELECT UserId, UserName, UserType, FirstName, LastName, DefaultSignatureScanFile, PhoneNumber, EmailAddress, Password, ReputationValue, UserRole, Last_Login 
FROM $DB_NAME$.Users 
WHERE DeactivatedTS IS NULL;

CREATE OR REPLACE VIEW $DB_NAME$Views.UsersAll AS SELECT * FROM $DB_NAME$.Users;
CREATE OR REPLACE VIEW $DB_NAME$Views.School AS SELECT * FROM $DB_NAME$.School;
CREATE OR REPLACE VIEW $DB_NAME$Views.Class AS SELECT * FROM $DB_NAME$.Class;
CREATE OR REPLACE VIEW $DB_NAME$Views.User_Teacher AS SELECT * FROM $DB_NAME$.User_Teacher;
CREATE OR REPLACE VIEW $DB_NAME$Views.User_Teacher_Class AS SELECT * FROM $DB_NAME$.User_Teacher_Class;
CREATE OR REPLACE VIEW $DB_NAME$Views.User_Student AS SELECT * FROM $DB_NAME$.User_Student;
CREATE OR REPLACE VIEW $DB_NAME$Views.User_Reputation_Event AS SELECT * FROM $DB_NAME$.User_Reputation_Event;

-- Contract info
CREATE OR REPLACE VIEW $DB_NAME$Views.Contract AS SELECT * FROM $DB_NAME$.Contract;
CREATE OR REPLACE VIEW $DB_NAME$Views.Contract_Party AS SELECT * FROM $DB_NAME$.Contract_Party;
CREATE OR REPLACE VIEW $DB_NAME$Views.Contract_Party_Approval AS SELECT * FROM $DB_NAME$.Contract_Party_Approval;
CREATE OR REPLACE VIEW $DB_NAME$Views.Contract_Goal AS SELECT * FROM $DB_NAME$.Contract_Goal;
CREATE OR REPLACE VIEW $DB_NAME$Views.Contract_Reward AS SELECT * FROM $DB_NAME$.Contract_Reward;
CREATE OR REPLACE VIEW $DB_NAME$Views.Contract_Party_Goal_Reward AS SELECT * FROM $DB_NAME$.Contract_Party_Goal_Reward;

CREATE OR REPLACE VIEW $DB_NAME$Views.NextId AS SELECT * FROM $DB_NAME$.NextId;

-- Sample view
CREATE OR REPLACE VIEW $DB_NAME$Views.t1 AS SELECT * FROM $DB_NAME$.t1;
