CREATE OR REPLACE VIEW $APP_NAME$Views.NextId AS SELECT * FROM $APP_NAME$.NextId;
CREATE OR REPLACE VIEW $APP_NAME$Views.Object AS SELECT * FROM $APP_NAME$.Object;

-- File
CREATE OR REPLACE VIEW $APP_NAME$Views.FileAll AS SELECT * FROM $APP_NAME$.File; -- History rows
CREATE OR REPLACE VIEW $APP_NAME$Views.File AS SELECT * FROM $APP_NAME$Views.FileAll WHERE EndTS = TIMESTAMP '9999-12-31 23:59:59';

-- Role
CREATE OR REPLACE VIEW $APP_NAME$Views.Role AS SELECT * FROM $APP_NAME$.Role;
CREATE OR REPLACE VIEW $APP_NAME$Views.Role_ACL AS SELECT * FROM $APP_NAME$.Role_ACL;

-- School / class
CREATE OR REPLACE VIEW $APP_NAME$Views.SchoolAll AS SELECT * FROM $APP_NAME$.School WHERE SchoolId <> 0; -- History rows
CREATE OR REPLACE VIEW $APP_NAME$Views.School AS SELECT * FROM $APP_NAME$Views.SchoolAll WHERE SchoolId <> 0 AND EndTS = TIMESTAMP '9999-12-31 23:59:59';
CREATE OR REPLACE VIEW $APP_NAME$Views.School_Calendar AS SELECT * FROM $APP_NAME$.School_Calendar;
CREATE OR REPLACE VIEW $APP_NAME$Views.School_Reward AS SELECT * FROM $APP_NAME$.School_Reward;
CREATE OR REPLACE VIEW $APP_NAME$Views.School_Rubric AS SELECT * FROM $APP_NAME$.School_Rubric;
CREATE OR REPLACE VIEW $APP_NAME$Views.Class AS SELECT * FROM $APP_NAME$.Class WHERE ClassId <> 0;

-- Contracts
CREATE OR REPLACE VIEW $APP_NAME$Views.ContractAll AS SELECT * FROM $APP_NAME$.Contract;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract AS SELECT * FROM $APP_NAME$Views.ContractAll WHERE EndTS = TIMESTAMP '9999-12-31 23:59:59';
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Party AS SELECT * FROM $APP_NAME$.Contract_Party;
CREATE OR REPLACE VIEW $APP_NAME$Views.Contract_Party_Reward AS SELECT * FROM $APP_NAME$.Contract_Party_Reward;

-- Users
CREATE OR REPLACE VIEW $APP_NAME$Views.UsersAll AS SELECT * FROM $APP_NAME$.Users;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Reputation_Event AS SELECT * FROM $APP_NAME$.User_Reputation_Event;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Badge AS SELECT * FROM $APP_NAME$.User_Badge;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Notification AS SELECT * FROM $APP_NAME$.User_Notification;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Profile_Picture AS SELECT * FROM $APP_NAME$.User_Profile_Picture;

-- Users
CREATE OR REPLACE VIEW $APP_NAME$Views.Users AS 
SELECT UserId, SchoolId, UserName, UserType, FirstName, LastName, CAST(FirstName || ' ' || LastName AS VARCHAR(250)) AS UserDisplayName, 
	   EmailAddress, Password, ReputationValue, ReputationValueLastSeenTS, ProfilePictureId, 
	   Last_Login, Is_Active -- Required for django authentication
FROM $APP_NAME$.Users u
WHERE UserId <> 0 -- Ignore reserve fields
;

CREATE OR REPLACE VIEW $APP_NAME$Views.UsersActive AS SELECT * FROM $APP_NAME$.Users WHERE Is_Active IS TRUE;

-- Lookup
CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Category AS SELECT * FROM $APP_NAME$.Lookup_Category;
CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Event AS SELECT * FROM $APP_NAME$.Lookup_Event;
CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Badge AS SELECT * FROM $APP_NAME$.Lookup_Badge;

CREATE OR REPLACE VIEW $APP_NAME$Views.RewardAll AS 
SELECT r.RewardId, r.SchoolYear, r.RewardDisplayName, r.RewardDescription, r.RewardValue, r.RewardCategory, rc.CategoryDisplayName AS RewardCategoryDisplayName, r.Vendor, r.StartTS, r.EndTS
FROM $APP_NAME$.Reward r
INNER JOIN $APP_NAME$Views.Lookup_Category rc ON r.RewardCategory = rc.CategoryType AND rc.CategoryClass = 'reward';

CREATE OR REPLACE VIEW $APP_NAME$Views.Reward AS SELECT * FROM $APP_NAME$Views.RewardAll WHERE EndTS = TIMESTAMP '9999-12-31 23:59:59';

CREATE OR REPLACE VIEW $APP_NAME$Views.Lookup_Profile_Picture AS 
SELECT 
  ProfilePictureId, BadgeLevel, FilePath AS ProfilePictureFilePath, 
  CAST(FileName || '.' || FileExtension AS VARCHAR(300)) AS ProfilePictureFileName
FROM $APP_NAME$.Lookup_Profile_Picture;

-- Teacher
CREATE OR REPLACE VIEW $APP_NAME$Views.User_ProgramAll AS SELECT * FROM $APP_NAME$.User_Program;
CREATE OR REPLACE VIEW $APP_NAME$Views.User_Program AS SELECT * FROM $APP_NAME$Views.User_ProgramAll WHERE EndTS = TIMESTAMP '9999-12-31 23:59:59';
CREATE OR REPLACE VIEW $APP_NAME$Views.Teacher_Class AS SELECT * FROM $APP_NAME$.Teacher_Class;

CREATE OR REPLACE VIEW $APP_NAME$Views.Teacher_Program_Info AS 
SELECT up.UserId, up.ProgramName, up.SchoolId, up.SchoolYear, up.MaxBudget, 
	up.Details->'teachersurveyts' AS TeacherSurveyTS, 
	up.Details->'studentsurveyURL' AS StudentSurveyURL, 
	up.Details->'notes' AS Notes,
	COALESCE(sv.NumStudentSurveys, 0) AS NumStudentSurveys
FROM $APP_NAME$Views.User_Program up
LEFT JOIN (
	SELECT tc.TeacherUserId, c.SchoolYear, SUM(c.NumStudentSurveys) AS NumStudentSurveys
	FROM $APP_NAME$Views.Teacher_Class tc
	INNER JOIN $APP_NAME$Views.Class c ON tc.ClassId = c.ClassId -- Get class info
	GROUP BY tc.TeacherUserId, c.SchoolYear
) sv ON up.UserId = sv.TeacherUserId AND up.SchoolYear = sv.SchoolYear -- Get class survey info
;

-- Sample view
CREATE OR REPLACE VIEW $APP_NAME$Views.t1 AS SELECT * FROM $APP_NAME$.t1;