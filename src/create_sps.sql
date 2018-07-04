-- Install file for SPs
-- User
\i install/sps/SP_DCPUpsertUser.spl
\i install/sps/SP_DCPDeleteUser.spl
\i install/sps/SP_DCPGetUser.spl
\i install/sps/SP_DCPUpsertUserReputationEvent.spl
\i install/sps/SP_DCPGetUserReputationEvent.spl
\i install/sps/SP_DCPDeactivateUser.spl

-- Teacher
\i install/sps/SP_DCPUpsertTeacher.spl
\i install/sps/SP_DCPGetTeacher.spl
\i install/sps/SP_DCPGetTeacherClass.spl

-- Student
\i install/sps/SP_DCPUpsertStudent.spl
\i install/sps/SP_DCPGetStudent.spl

-- School
\i install/sps/SP_DCPUpsertSchool.spl
\i install/sps/SP_DCPDeleteSchool.spl
\i install/sps/SP_DCPGetSchool.spl

-- Class
\i install/sps/SP_DCPUpsertClass.spl
\i install/sps/SP_DCPDeleteClass.spl
\i install/sps/SP_DCPGetClass.spl

-- Contract
\i install/sps/SP_DCPUpsertContract.spl
\i install/sps/SP_DCPGetContract.spl

\i install/sps/SP_DCPUpsertContractGoal.spl
\i install/sps/SP_DCPDeleteContractGoal.spl
\i install/sps/SP_DCPGetContractGoal.spl

\i install/sps/SP_DCPUpsertContractGoalReward.spl
\i install/sps/SP_DCPDeleteContractGoalReward.spl
\i install/sps/SP_DCPGetContractGoalReward.spl

\i install/sps/SP_DCPGetContractParty.spl
\i install/sps/SP_DCPModifyContractParties.spl

\i install/sps/SP_DCPApproveContract.spl
\i install/sps/SP_DCPChangeContractStatus.spl
\i install/sps/SP_DCPReviseContract.spl
\i install/sps/SP_DCPAcceptContractGoal.spl

-- Other
\i install/sps/SP_DCPGetNextId.spl
