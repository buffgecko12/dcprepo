/*
	Upgrade script steps
	1. Apply DDL changes
	2. Re-install logic (views, SPs, UDFs)

	How to Test Upgrade
	1. Install source version (i.e. 2.0.0)
	2. Run upgrade script (2.0.0 to 2.0.1)

*/

-- Update Contract table
ALTER TABLE $APP_NAME$.Reward ADD COLUMN SourceRewardId INTEGER;
