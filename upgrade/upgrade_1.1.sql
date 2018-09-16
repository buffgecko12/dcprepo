/* Upgrade process

- check in all changes
- update repository (prod)
- push changes to Heroku

 */

-- Update Contract table
ALTER TABLE $APP_NAME$.Contract 
	ADD COLUMN ContractEvaluationTS TIMESTAMP WITH TIME ZONE,
	ADD COLUMN ContractFinalizationTS TIMESTAMP WITH TIME ZONE;

-- Fix up Contract_Party_Goal_Reward
DROP VIEW IF EXISTS $APP_NAME$Views.Contract_Party_Goal_Reward;
DROP TABLE IF EXISTS $APP_NAME$.Contract_Party_Goal_Reward;

CREATE TABLE $APP_NAME$.Contract_Party_Goal_Evaluation (
	ContractId INTEGER NOT NULL,
	PartyUserId INTEGER NOT NULL,
	GoalId INTEGER NOT NULL,
	AchievedFlag BOOLEAN,
	ExperienceRating SMALLINT,
	HighPerformerFlag BOOLEAN,
	TopPerformerFlag BOOLEAN,
	FeedbackMsg VARCHAR(500),
	RewardId INTEGER,
	RewardDeliveredFlag BOOLEAN,
	ActualRewardValue INTEGER,
	PRIMARY KEY (ContractId, PartyUserId, GoalId),
	FOREIGN KEY (ContractId, PartyUserId) REFERENCES $APP_NAME$.Contract_Party (ContractId, PartyUserId)
);
	
-- Update status table
UPDATE $APP_NAME$.Lookup_Status SET Status = 'F', StatusDisplayName = 'Finalizado' WHERE Status = 'C';
INSERT INTO $APP_NAME$.Lookup_Status VALUES('E','Evaluaci' || U&'\00F3' || 'n') ON CONFLICT DO NOTHING;

-- Update lookup info (events / badges)
DELETE FROM $APP_NAME$.Lookup_Badge;
DELETE FROM $APP_NAME$.Lookup_Event;

-- Load events
INSERT INTO $APP_NAME$.Lookup_Event 
(EventId, EventType, EventClass, EventUserType, EventDisplayName, EventMessage, DefaultReputationPointValue) VALUES
-- General events
(1, 'BD', 'PT', 'ST', 'Ganar puntos de reputaci' || U&'\00F3' || 'n', '', 0),
(2, 'BD', 'PT', 'ST', 'Completar exitosamente una meta de contrato', '', 0),

-- Notifications - General
(1001, 'NT', 'RP', 'AL', '', 'Ha ganado nuevos puntos de reputaci' || U&'\00F3' || 'n', 0),
(1002, 'NT', 'BD', 'AL', '', 'Ha ganado una nueva medalla', 0),

-- Notifications - Contract
(1101, 'NT', 'CT', 'AL', '', 'Su contrato ha sido aprobado', 0),
(1102, 'NT', 'CT', 'AL', '', 'Su contrato ha sido actualizado', 0), -- Draft edit
(1103, 'NT', 'CT', 'AL', '', 'Su contrato ha sido eliminado', 0),
(1104, 'NT', 'CT', 'AL', '', 'Tiene un contrato nuevo para revisar', 0),
(1105, 'NT', 'CT', 'AL', '', 'Su contrato ha sido modificado', 0), -- Active revision
(1106, 'NT', 'CT', 'AL', '', 'Su contrato ha sido modificado - votaci' || U&'\00F3' || 'n requerida', 0), -- Active revision (re-vote required)
(1107, 'NT', 'CT', 'AL', '', 'Ha sido retirado de un contrato', 0),

-- Reputation events
(2001, 'RP', 'PT', 'AL', 'Crear una cuenta de usuario', '', 5), -- Create user account
(2002, 'RP', 'PT', 'ST', 'Aceptar una meta de contrato', '', 5), -- Accept contract goal
(2003, 'RP', 'PF', 'ST', 'Completar exitosamente una meta f' || U&'\00E1' || 'cil de contrato', '', 15), -- Complete easy goal
(2004, 'RP', 'PF', 'ST', 'Completar exitosamente una meta media de contrato', '', 30), -- Complete medium goal
(2005, 'RP', 'PF', 'ST', 'Completar exitosamente una meta dif' || U&'\00ED' || 'cil de contrato', '', 50), -- Complete difficult goal
(2006, 'RP', 'PF', 'ST', 'Alto desempe' || U&'\00F1' || 'o en un contrato', '', 25), -- High performance on contract
(2007, 'RP', 'PF', 'ST', 'Mejor desempe' || U&'\00F1' || 'o en un contrato', '', 50), -- Top performance on contract
(2008, 'RP', 'PF', 'AL', 'Recibir feedback positivo', '', 10), -- Receive positive feedback
(2012, 'RP', 'PF', 'AL', 'Recibir feedback negativo', '', -2),
(2013, 'RP', 'PF', 'ST', 'Enviar feedback', '', 5), -- Send feedback
(2014, 'RP', 'PF', 'TR', 'Enviar un contrato', '', 15), -- Send contract 
(2015, 'RP', 'PF', 'TR', 'Evaluar un contrato', '', 15) -- Evaluate contract
;

-- Load badges
INSERT INTO $APP_NAME$.Lookup_Badge
(BadgeId, BadgeLevel, BadgeThresholdValue, BadgeShortName, BadgeDisplayName, BadgeDescription, SourceEventId) VALUES
-- General
(1, 'B', NULL, 'rookie', 'Novato', 'Crear una cuenta de usuario', 2001), -- New account

-- Contract goals
(6, 'B', NULL, 'achiever', 'Cumplidor', 'Completar exitosamente una meta f' || U&'\00E1' || 'cil de contrato', 2003), -- Complete easy goal
(7, 'S', NULL, 'mediumachiever', 'Triunfador ', 'Completar exitosamente una meta media de contrato', 2004), -- Complete medium goal
(8, 'G', NULL, 'highachiever', 'Triunfador Alto', 'Completar exitosamente una meta dif' || U&'\00ED' || 'cil de contrato', 2005), -- Complete difficult goal

-- Contract performance
(5, 'S', NULL, 'higherformer', 'Alto desempe' || U&'\00F1' || 'o', 'Alto desempe' || U&'\00F1' || 'o en un contrato', 2006), -- Voted high performer
(10, 'G', NULL, 'topperformer', 'Mejor desempe' || U&'\00F1' || 'o', 'Mejor desempe' || U&'\00F1' || 'o en un contrato', 2007), -- Voted top performer

(19, 'B', NULL, 'feedback', 'Comunidad', 'Enviar feedback', 2013),

-- Receive Positive Feedback (experience rating)
(20, 'B', 1, 'performer', 'Buen desempe'|| U&'\00F1' ||'o', 'Recibir feedback positivo', 2008), -- Positive feedback
(21, 'S', 10, 'performer', 'Super desempe'|| U&'\00F1' ||'o', 'Recibir 10 feedback positivo', 2008), -- Positive feedback
(22, 'G', 50, 'performer', U&'\00E9' || 'lite desempe'|| U&'\00F1' ||'o', 'Recibir 50 feedback positivo', 2008), -- Positive feedback

-- Reputation
(2, 'B', 50, 'junioruser','Usuario junior', 'Ganar 50 puntos de reputaci' || U&'\00F3' || 'n', 1), 
(3, 'S', 200, 'superuser','Usuario super', 'Ganar 200 puntos de reputaci' || U&'\00F3' || 'n', 1),
(4, 'G', 500, 'eliteuser','Usuario ' || U&'\00E9' || 'lite', 'Ganar 500 puntos de reputaci' || U&'\00F3' || 'n', 1),

-- Send contract
(11, 'B', 1, 'participant','Participante', 'Enviar un contrato', 2014), 
(12, 'S', 5, 'involved','Involucrado', 'Enviar 5 contratos', 2014), 
(13, 'G', 25, 'motivated','Motivado', 'Enviar 50 contratos', 2014), 

-- Accept contract goal
(14, 'B', 1, 'participant', 'Participante', 'Aceptar un contrato', 2002),
(15, 'S', 3, 'involved', 'Involucrado', 'Aceptar 3 contratos', 2002),
(16, 'G', 10, 'motivated', 'Motivado', 'Aceptar 10 contratos', 2002),

-- Complete contract goal
(17, 'S', 3, '', '', 'Completar exitosamente 3 metas de contrato', 2),
(18, 'G', 10, '', '', 'Completar exitosamente 10 metas de contrato', 2)
;

-- Recreate all views (create_views.sql)

-- Recreate modified SPs
-- SP_DCPCopyContract
-- SP_DCPDeleteUser
-- SP_DCPGetContract (drop function first)
-- SP_DCPGetContractValue
-- SP_DCPGetUserBadge
-- SP_DCPProcessUserEvent
-- SP_DCPEvaluateContract
-- SP_DCPGetContractPartyGoalEvaluation
