-- Create DEACTIVATED lookup entries (must be done in correct orders)
SELECT $APP_NAME$Views.SP_DCPUpsertSchool (0, 'DEACTIVATED', 'DEACTIVATED', NULL, NULL, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertClass (0, 0, 'DEACTIVATED', 0);

--SELECT $APP_NAME$Views.SP_DCPUpsertUser (-1, 'Anonymous', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertUser (0, 0, 'DEACTIVATED', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPDeactivateUser(0);

SELECT $APP_NAME$Views.SP_DCPUpsertTeacher(0, NULL, JSONB('{"currentclasses": [{"classid":0}]}'));
SELECT $APP_NAME$Views.SP_DCPUpsertStudent(0, 0);

-- Load NextId initial values
INSERT INTO $APP_NAME$.NextId (IdType, NextValue) VALUES 
('contract', 1),
('user', 1), 
('school', 1), 
('class', 1), 
('reward', 1),
('file', 1);

-- Load contract status
INSERT INTO $APP_NAME$.Lookup_Status (Status, StatusDisplayName) VALUES 
('P','Pendiente'),
('D','Borrador'),
('C','Completo'),
('A','Activo'),
('R','Revisi' || U&'\00F3' || 'n')
;

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
(2012, 'RP', 'PF', 'AL', 'Experiencia negativa de grupo', '', -2),
(2013, 'RP', 'PF', 'AL', 'Enviar feedback', '', 2),
(2014, 'RP', 'PF', 'TR', 'Enviar un contrato', '', 15),
(2015, 'RP', 'PF', 'TR', 'Finalizar un contrato', '', 10)
;

-- Load badges
INSERT INTO $APP_NAME$.Lookup_Badge
(BadgeId, BadgeLevel, BadgeThresholdValue, BadgeShortName, BadgeDisplayName, BadgeDescription, SourceEventId) VALUES
-- General
(1, 'B', NULL, 'rookie', 'Novato', 'Crear una cuenta de usuario', 2001), -- New account
(6, 'B', NULL, 'achiever', 'Cumplidor', 'Completar exitosamente una meta f' || U&'\00E1' || 'cil de contrato', 2003), -- Complete easy goal
(7, 'S', NULL, 'mediumachiever', 'Triunfador ', 'Completar exitosamente una meta media de contrato', 2004), -- Complete medium goal
(8, 'G', NULL, 'highachiever', 'Triunfador Alto', 'Completar exitosamente una meta dif' || U&'\00ED' || 'cil de contrato', 2005), -- Complete difficult goal
(9, 'B', NULL, 'performer', 'Buen desempe'|| U&'\00F1' ||'o', 'Feedback positivo (por los integrantes)', 2008), -- Positive feedback
(10, 'B', NULL, 'topperformer', 'Mejor desempe' || U&'\00F1' || 'o', 'Mejor desempe' || U&'\00F1' || 'o en un contrato', 2006), -- Voted top performer
(19, 'B', NULL, 'feedback', 'Comunidad', 'Enviar feedback', 2013),

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

-- Badge profile pictures
INSERT INTO $APP_NAME$.Lookup_Profile_Picture
(BadgeLevel, FilePath, FileName, FileExtension, Description) VALUES

-- Default pictures
('D', 'avengers/','11','png','Avenger 11'),
('D', 'avengers/','12','png','Avenger 12'),

-- Bronze level
('B', 'avengers/','1','png','Avenger 1'),
('B', 'avengers/','2','png','Avenger 2'),
('B', 'avengers/','3','png','Avenger 3'),
('B', 'avengers/','4','png','Avenger 4'),
('B', 'avengers/','5','png','Avenger 5'),
('B', 'avengers/','6','png','Avenger 6'),
('B', 'avengers/','7','png','Avenger 7'),
('B', 'avengers/','8','png','Avenger 8'),
('B', 'avengers/','9','png','Avenger 9'),
('B', 'avengers/','10','png','Avenger 10'),

-- Silver level
('S', 'countries/','argentina1','png','Argetina flag (round)'),
('S', 'countries/','argentina2','png','Argetina flag (texture)'),
('S', 'countries/','brazil1','png','Brazil flag'),
('S', 'countries/','brazil2','png','Brazil flag (round)'),
('S', 'countries/','canada1','png','Canada flag (texture)'),
('S', 'countries/','canada2','png','Canada flag (round)'),
('S', 'countries/','colombia1','png','Colombia flag (wave)'),
('S', 'countries/','colombia2','png','Colombia flag'),
('S', 'countries/','england1','png','England flag (button)'),
('S', 'countries/','england2','png','England flag'),
('S', 'countries/','france1','png','Eiffel Tower'),
('S', 'countries/','france2','png','France flag (texture)'),
('S', 'countries/','us1','png','US flag'),
('S', 'countries/','us2','png','US flag (wave)'),

-- Gold level
('G', 'sports/','basketball1','png','Basketball (dark)'),
('G', 'sports/','basketball2','png','Basketball'),
('G', 'sports/','cycling2','png','Bicycle wheel'),
('G', 'sports/','cycling2','png','Bicycle helmet'),
('G', 'sports/','soccerball1','png','Soccer ball (reflection)'),
('G', 'sports/','soccerball2','png','Soccer ball (gold)'),
('G', 'sports/','soccerfield1','png','Soccer field (elevated)'),
('G', 'sports/','soccerfield2','png','Soccer field'),
('G', 'sports/','soccershoe1','png','Cleats'),
('G', 'sports/','soccerstadium1','png','Soccer stadium'),
('G', 'sports/','trophy1','png','Soccer trophy')
;