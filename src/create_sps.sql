-- Automate run-time generation of this file (scan SP source files in "sps" directory)
-- Install file for SPs
\i install/sps/SP_DCPUpsertContract.spl

\i install/sps/SP_DCPUpsertUser.spl
\i install/sps/SP_DCPDeleteUser.spl
\i install/sps/SP_DCPGetUser.spl
\i install/sps/SP_DCPDeactivateUser.spl

\i install/sps/SP_DCPUpsertSchool.spl
\i install/sps/SP_DCPGetSchool.spl

\i install/sps/SP_DCPGetNextId.spl
