-- Create DEACTIVATED lookup entries (must be done in correct orders)
SELECT $APP_NAME$Views.SP_DCPUpsertSchool (0, 'DEACTIVATED', 'DEACTIVATED', NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertClass (0, 0, 'DEACTIVATED');

--SELECT $APP_NAME$Views.SP_DCPUpsertUser (-1, 'Anonymous', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertUser (0, 'DEACTIVATED', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);
SELECT $APP_NAME$Views.SP_DCPDeactivateUser(0);

SELECT $APP_NAME$Views.SP_DCPUpsertTeacher(0, 0, NULL, JSONB('{"currentclasses": [{"classid":0}]}'));
SELECT $APP_NAME$Views.SP_DCPUpsertStudent(0, 0);

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
(EventId, EventType, EventClass, EventUserType, EventDisplayName, EventMessage, DefaultReputationPointValue) VALUES
-- Misc events
(1, 'BD', 'PT', 'ST', 'Ganar puntos de reputaci' || U&'\00F3' || 'n', '', 0),

-- Notifications
(1001, 'NT', 'RP', 'AL', '', 'Ha ganado nuevos puntos de reputaci' || U&'\00F3' || 'n', 0),
(1002, 'NT', 'CT', 'AL', '', 'Su contrato ha sido aprobado', 0),
(1003, 'NT', 'CT', 'AL', '', 'Tiene un contrato nuevo para revisar', 0),
(1004, 'NT', 'BD', 'AL', '', 'Ha ganado una nueva medalla', 0),

-- Reputation events
(2001, 'RP', 'PT', 'AL', 'Crear una cuenta de usuario', '', 5),
(2002, 'RP', 'PT', 'ST', 'Aceptar una meta de contrato', '', 5),
(2003, 'RP', 'PF', 'ST', 'Completar exitosamente una meta f' || U&'\00E1' || 'cil de contrato', '', 15),
(2004, 'RP', 'PF', 'ST', 'Completar exitosamente una meta media de contrato', '', 30),
(2005, 'RP', 'PF', 'ST', 'Completar exitosamente una meta dif' || U&'\00ED' || 'cil de contrato', '', 50),
(2006, 'RP', 'PF', 'ST', 'Mejor desempe' || U&'\00F1' || 'o en un contrato', '', 50),
(2007, 'RP', 'PF', 'ST', 'Feedback positivo (por el docente)', '', 20),
(2008, 'RP', 'PF', 'ST', 'Feedback positivo (por los integrantes)', '', 10),
(2009, 'RP', 'PF', 'ST', 'Experiencia positiva de grupo (por el docente)', '', 10),
(2010, 'RP', 'PF', 'ST', 'Experiencia positiva de grupo (por los integrantes)', '', 5),
(2011, 'RP', 'PF', 'TR', 'Feedback positivo (por los integrantes)', '', 25),
(2012, 'RP', 'PF', 'AL', 'Experiencia negativa de grupo', '', -2)
;

-- Load badges
INSERT INTO $APP_NAME$.Lookup_Badge
(BadgeId, BadgeLevel, BadgeThresholdValue, BadgeShortName, BadgeDisplayName, SourceEventId) VALUES
-- General badges
(1, 'B', NULL, 'rookie', 'Novato', 2001), -- New account
(5, 'B', NULL, 'participant', 'Participante', 2002), -- Accept contract goal
(6, 'B', NULL, 'achiever', 'Cumplidor', 2003), -- Complete easy goal
(7, 'S', NULL, 'mediumachiever', 'Triunfador ', 2004), -- Complete medium goal
(8, 'G', NULL, 'highachiever', 'Triunfador Alto', 2005), -- Complete difficult goal
(9, 'B', NULL, 'performer', 'Buen desempe'|| U&'\00F1' ||'o', 2008), -- Positive feedback
(10, 'B', NULL, 'topperformer', 'Mejor desempe' || U&'\00F1' || 'o', 2006), -- Voted top performer

-- Reputation badges
(2, 'B', 100, 'junioruser','Usuario junior', 1), 
(3, 'S', 200, 'superuser','Usuario super', 1),
(4, 'G', 1000, 'eliteuser','Usuario ' || U&'\00E9' || 'lite', 1)

;