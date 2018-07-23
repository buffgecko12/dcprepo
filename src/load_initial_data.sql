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

-- Load reputation events
INSERT INTO $APP_NAME$.Lookup_Reputation_Event
(ReputationEventId, EventClass, EventUserType, EventDisplayName, EventDescription, EventPointValue) VALUES 
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
(12, 'PF', 'AL', 'Experiencia negativa de grupo', '', -2)
;

-- Load badges
INSERT INTO $APP_NAME$.Lookup_Badge(BadgeId, BadgeClass, BadgeLevel, BadgeShortName, BadgeTitle, BadgeDescription) VALUES
(1,'PT','B','rookie','Novato',''),
(2,'PT','B','user','Usuario',''),
(3,'PT','S','superuser','Usuario super',''),
(4,'PT','G','eliteuser','Usuario ' || U&'\00E9' || 'lite',''),
(5,'PT','B','participant','Participante',''),
(6,'PF','B','achiever','Cumplidor',''),
(7,'PF','B','performer','Buen desempe'|| U&'\00F1' ||' o',''),
(8,'PF','B','topperformer','Mejor desempe' || U&'\00F1' || 'o','')
;