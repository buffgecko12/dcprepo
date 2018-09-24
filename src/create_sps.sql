-- Install file for SPs
-- User
\i install/sps/SP_DCPUpsertUser.spl
\i install/sps/SP_DCPDeleteUser.spl
\i install/sps/SP_DCPGetUser.spl
\i install/sps/SP_DCPGetUserReputationEvent.spl
\i install/sps/SP_DCPManageUserDisplayInfo.spl
\i install/sps/SP_DCPProcessUserEvent.spl
\i install/sps/SP_DCPGetUserBadge.spl
\i install/sps/SP_DCPGetUserNotification.spl
\i install/sps/SP_DCPUpsertUserNotification.spl
\i install/sps/SP_DCPClearUserNotification.spl
\i install/sps/SP_DCPDeactivateUser.spl
\i install/sps/SP_DCPGetUserProfilePicture.spl

-- User groups
\i install/sps/SP_DCPUpsertUserGroup.spl
\i install/sps/SP_DCPGetUserGroup.spl
\i install/sps/SP_DCPDeleteUserGroup.spl


-- Teacher
\i install/sps/SP_DCPUpsertTeacher.spl
\i install/sps/SP_DCPGetTeacher.spl
\i install/sps/SP_DCPGetTeacherClass.spl
\i install/sps/SP_DCPGetTeacherBudget.spl
\i install/sps/SP_DCPUpsertTeacherBudget.spl

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

-- Reward
\i install/sps/SP_DCPUpsertReward.spl
\i install/sps/SP_DCPDeactivateReward.spl
\i install/sps/SP_DCPGetReward.spl

-- Contract
\i install/sps/SP_DCPUpsertContract.spl
\i install/sps/SP_DCPDeleteContract.spl
\i install/sps/SP_DCPGetContract.spl
\i install/sps/SP_DCPGetContractValue.spl
\i install/sps/SP_DCPGetContractInfo.spl

\i install/sps/SP_DCPApproveContract.spl
\i install/sps/SP_DCPChangeContractStatus.spl
\i install/sps/SP_DCPReviseContract.spl
\i install/sps/SP_DCPEvaluateContract.spl
\i install/sps/SP_DCPEvaluateContractParty.spl
\i install/sps/SP_DCPApproveContract.spl
\i install/sps/SP_DCPDuplicateContract.spl
\i install/sps/SP_DCPCopyContract.spl

\i install/sps/SP_DCPUpsertContractGoal.spl
\i install/sps/SP_DCPDeleteContractGoal.spl
\i install/sps/SP_DCPGetContractGoal.spl

\i install/sps/SP_DCPUpsertContractGoalReward.spl
\i install/sps/SP_DCPDeleteContractGoalReward.spl
\i install/sps/SP_DCPGetContractGoalReward.spl

\i install/sps/SP_DCPGetContractParty.spl
\i install/sps/SP_DCPModifyContractParties.spl
\i install/sps/SP_DCPGetContractPartyGoalEvaluation.spl
\i install/sps/SP_DCPResetContractPartyVote.spl

-- Other
\i install/sps/SP_DCPGetFile.spl
\i install/sps/SP_DCPUpsertFile.spl
\i install/sps/SP_DCPDeleteFile.spl
\i install/sps/SP_DCPGetNextId.spl
