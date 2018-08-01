-- Environment
CREATE OR REPLACE VIEW $APP_NAME$Views.UsersAll AS SELECT * FROM $APP_NAME$.Users;
CREATE OR REPLACE VIEW $APP_NAME$Views.School AS SELECT * FROM $APP_NAME$.School WHERE SchoolId <> 0;
CREATE OR REPLACE VIEW $APP_NAME$Views.Class AS SELECT * FROM $APP_NAME$.Class WHERE ClassId <> 0;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Teacher AS SELECT * FROM $APP_NAME$.User_Teacher WHERE TeacherUserId <> 0;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Teacher_Class AS SELECT * FROM $APP_NAME$.User_Teacher_Class;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Student AS SELECT * FROM $APP_NAME$.User_Student WHERE StudentUserId <> 0;

CREATE OR REPLACE VIEW $APP_NAME$Views.User_Reputation_Event AS SELECT * FROM $APP_NAME$.User_Reputation_Event;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Badge AS SELECT * FROM $APP_NAME$.User_Badge;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Notification AS SELECT * FROM $APP_NAME$.User_Notification;

CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Reward AS SELECT * FROM $APP_NAME$.Lookup_Reward;
CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Status AS SELECT * FROM $APP_NAME$.Lookup_Status;
CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Event AS SELECT * FROM $APP_NAME$.Lookup_Event;
CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Badge AS SELECT * FROM $APP_NAME$.Lookup_Badge;

CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Badge_Profile_Picture AS 
SELECT ProfilePictureId, BadgeLevel, FilePath AS ProfilePictureFilePath, CAST(FileName || '.' || FileExtension AS VARCHAR(300)) AS ProfilePictureFileName
FROM $APP_NAME$.Lookup_Badge_Profile_Picture;

-- User info
CREATE OR REPLACE VIEW $APP_NAME$Views.Users AS 
SELECT UserId, UserName, UserType, FirstName, LastName, DefaultSignatureScanFile, PhoneNumber, EmailAddress, Password, 
		ReputationValue, ReputationValueLastSeenTS, UserRole, ProfilePictureId, 
		Last_Login, Is_Active -- Required for django authentication
FROM $APP_NAME$.Users u
WHERE Is_Active IS TRUE -- Ignore deactivated users
AND UserId <> 0 -- Ignore reserve fields
;

-- Student info
CREATE OR REPLACE VIEW $APP_NAME$Views.Students AS 
SELECT us.StudentUserId, us.Classid, u.Firstname, u.Lastname, u.DefaultSignatureScanFile, u.PhoneNumber, u.EmailAddress, u.ReputationValue, u.ProfilePictureId
FROM $APP_NAME$Views.Users u
INNER JOIN $APP_NAME$Views.User_Student us ON u.UserId = us.StudentUserId
;

-- Teacher info
CREATE OR REPLACE VIEW $APP_NAME$Views.Teachers AS 
SELECT ut.TeacherUserId, ut.SchoolId, ut.MaxBudget, u.Firstname, u.Lastname, u.DefaultSignatureScanFile, u.PhoneNumber, u.EmailAddress, u.ReputationValue, u.ProfilePictureId
FROM $APP_NAME$Views.Users u
INNER JOIN $APP_NAME$Views.User_Teacher ut ON u.UserId = ut.TeacherUserId
;

-- Contract info
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract AS SELECT * FROM $APP_NAME$.Contract;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Party AS SELECT * FROM $APP_NAME$.Contract_Party;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Party_Approval AS SELECT * FROM $APP_NAME$.Contract_Party_Approval;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Goal AS SELECT * FROM $APP_NAME$.Contract_Goal;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Goal_Reward AS SELECT * FROM $APP_NAME$.Contract_Goal_Reward;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Party_Goal_Reward AS SELECT * FROM $APP_NAME$.Contract_Party_Goal_Reward;

CREATE OR REPLACE VIEW $APP_NAME$Views.NextId AS SELECT * FROM $APP_NAME$.NextId;

-- Sample view
CREATE OR REPLACE VIEW $APP_NAME$Views.t1 AS SELECT * FROM $APP_NAME$.t1;
