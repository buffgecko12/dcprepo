-- Create DEACTIVATED lookup entries (must be done in correct orders)
SELECT $APP_NAME$Views.SP_DCPUpsertSchool (0, 'DEACTIVATED', 'DEACTIVATED', NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertClass (0, 0, 'DEACTIVATED');

--SELECT $APP_NAME$Views.SP_DCPUpsertUser (-1, 'Anonymous', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertUser (0, 'DEACTIVATED', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);
SELECT $APP_NAME$Views.SP_DCPDeactivateUser(0);

SELECT $APP_NAME$Views.SP_DCPUpsertTeacher(0, 0, NULL, JSONB('{"currentclasses": [{"classid":0}]}'), NULL, NULL, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertStudent(0, 0, NULL, NULL, NULL, NULL, NULL);

-- Load NextId initial values
INSERT INTO $APP_NAME$.NextId (IdType, NextValue) VALUES 
('contract', 1),
('user', 1), 
('school', 1), 
('class', 1), 
('reward', 1);

-- Load contract status
INSERT INTO $APP_NAME$.Lookup_Status (Status, StatusDisplayName) VALUES 
('P','Pendiente'),
('D','Borrador'),
('C','Completo'),
('A','Activo')
;

-- Load events
INSERT INTO $APP_NAME$.Lookup_Event 
(EventId, EventClass, EventUserType, EventDisplayName, EventDescription, DefaultReputationPointValue) VALUES
-- Reputation events
(1, 'PT', 'AL', 'Crear una cuenta de usuario', '', 5),
(2, 'PT', 'ST', 'Aceptar una meta de contrato', '', 5),
(3, 'PF', 'ST', 'Completar exitosamente una meta f' || U&'\00E1' || 'cil de contrato', '', 15),
(4, 'PF', 'ST', 'Completar exitosamente una meta media de contrato', '', 30),
(5, 'PF', 'ST', 'Completar exitosamente una meta dif' || U&'\00ED' || 'cil de contrato', '', 50),
(6, 'PF', 'ST', 'Mejor desempe' || U&'\00F1' || 'o en un contrato', '', 50),
(7, 'PF', 'ST', 'Feedback positivo (por el docente)', '', 20),
(8, 'PF', 'ST', 'Feedback positivo (por los integrantes)', '', 10),
(9, 'PF', 'ST', 'Experiencia positiva de grupo (por el docente)', '', 10),
(10, 'PF', 'ST', 'Experiencia positiva de grupo (por los integrantes)', '', 5),
(11, 'PF', 'TR', 'Feedback positivo (por los integrantes)', '', 25),
(12, 'PF', 'AL', 'Experiencia negativa de grupo', '', -2),

-- Non-reputation events
(1001, 'PT', 'ST', 'Ganar puntos de reputaci' || U&'\00F3' || 'n', '', 0)
;

-- Load badges
INSERT INTO $APP_NAME$.Lookup_Badge
(BadgeId, BadgeLevel, BadgeThresholdValue, BadgeShortName, BadgeDisplayName, SourceEventId) VALUES
-- General badges
(1, 'B', NULL, 'rookie', 'Novato', 1), -- New account
(5, 'B', NULL, 'participant', 'Participante', 2), -- Accept contract goal
(6, 'B', NULL, 'achiever', 'Cumplidor', 3), -- Complete easy goal
(7, 'S', NULL, 'mediumachiever', 'Triunfador ', 4), -- Complete medium goal
(8, 'G', NULL, 'highachiever', 'Triunfador Alto', 5), -- Complete difficult goal
(9, 'B', NULL, 'performer', 'Buen desempe'|| U&'\00F1' ||'o', 8), -- Positive feedback
(10, 'B', NULL, 'topperformer', 'Mejor desempe' || U&'\00F1' || 'o', 6), -- Voted top performer

-- Reputation badges
(2, 'B', 100, 'user','Usuario junior', 1001), 
(3, 'S', 200, 'superuser','Usuario super', 1001),
(4, 'G', 1000, 'eliteuser','Usuario ' || U&'\00E9' || 'lite', 1001)

;