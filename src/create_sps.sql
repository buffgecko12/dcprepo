-- Automate run-time generation of this file (scan SP source files in "sps" directory)
-- Install file for SPs
\i install/sps/SP_DCPUpsertContract.spl

-- User
\i install/sps/SP_DCPUpsertUser.spl
\i install/sps/SP_DCPDeleteUser.spl
\i install/sps/SP_DCPGetUser.spl
\i install/sps/SP_DCPDeactivateUser.spl

-- School
\i install/sps/SP_DCPUpsertSchool.spl
\i install/sps/SP_DCPDeleteSchool.spl
\i install/sps/SP_DCPGetSchool.spl

-- Class
\i install/sps/SP_DCPUpsertClass.spl
\i install/sps/SP_DCPDeleteClass.spl
\i install/sps/SP_DCPGetClass.spl

-- Other
\i install/sps/SP_DCPGetNextId.spl
