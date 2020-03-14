-- Create DEACTIVATED lookup entries (must be done in correct orders)
SELECT $APP_NAME$Views.SP_DCPUpsertSchool (0, 'DEACTIVATED', 'DEACTIVATED', NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertClass (0, 0, 2020, 'DEACTIVATED', 0, NULL);

--SELECT $APP_NAME$Views.SP_DCPUpsertUser (-1, 'Anonymous', 'OT', '', '', NULL, NULL, NULL,NULL,'U',NULL);

SELECT $APP_NAME$Views.SP_DCPUpsertUser (0, 0, 'DEACTIVATED', 'OT', '', '', NULL,NULL,NULL,NULL);
SELECT $APP_NAME$Views.SP_DCPDeleteUser(0);

-- Load NextId initial values
INSERT INTO $APP_NAME$.NextId (IdType, NextValue) VALUES 
('object', 1), 
('user', 1),
('school', 1), 
('class', 1), 
('contract', 1),
('reward', 1),
('file', 1),
('role', 1);

-- Default Roles
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, 'General', 'Todos los usuarios', TRUE, NULL, NULL, NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, 'Docentes', 'Todos los docentes', FALSE, NULL, '{TR}', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, 'Administradores de colegio', 'Todos los administradores de colegio', FALSE, NULL, '{SF}', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, 'Administrador del sitio', 'Todos los administradores del sitio', FALSE, NULL, '{AD}', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertRole(NULL, 'S' || U&'\00FA' || 'per usuario', 'Todos los s' || U&'\00FA' || 'per usuarios', FALSE, NULL, '{SU}', NULL);

-- Default objects
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'school');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'class');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'contract');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'reward');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'file');
SELECT $APP_NAME$Views.SP_DCPUpsertObject(NULL, 'BO', 'role');

-- Load categories
INSERT INTO $APP_NAME$.Lookup_Category
(CategoryClass, CategoryType, CategoryDisplayName, Description) VALUES

-- Reward categories
('reward', 'PT', 'Participaci' || U&'\00F3' || 'n', NULL),
('reward', 'FD', 'Comida', NULL),
('reward', 'ET', 'Entretenimiento', NULL),
('reward', 'AC', 'Acad' || U&'\00E9' || 'mico', NULL),
('reward', 'OT', 'Otro', NULL),

-- Calendar items
('calendar', 'SP', 'Inicio de programa', NULL),
('calendar', 'EP', 'Fin de programa', NULL),
('calendar', 'CTP', 'Entregar los acuerdos (propuestas) con firmas', NULL),
('calendar', 'CTE', 'Entregar las evaluaciones y las evidencias', NULL),
('calendar', 'ID', 'Entrega de incentivos', NULL),
('calendar', 'SVS', 'Presentar las encuestas de estudiante', NULL),
('calendar', 'SVT', 'Presentar las encuestas de docente', NULL),
('calendar', 'FR', 'Recibir el informe con los resultados del programa', NULL),
('calendar', 'OT', 'Otro', NULL),

-- User types
('usertype', 'SA', 'Administrador del sitio', NULL),
('usertype', 'AD', 'Administrador del programa', NULL),
('usertype', 'SF', 'Administrador del colegio', NULL),
('usertype', 'TR', 'Docente', NULL),
('usertype', 'OT', 'Otro', NULL)
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
(1101, 'NT', 'CT', 'AL', '', 'Se ha recibido su contrato', 0),
(1102, 'NT', 'CT', 'AL', '', 'Se ha finalizado su contrato', 0), -- Draft edit


-- Reputation events # TO-DO: Clean these up
(2001, 'RP', 'PT', 'AL', 'Crear una cuenta de usuario', '', 5), -- Create user account
(2002, 'RP', 'PT', 'ST', 'Aceptar una meta de contrato', '', 5), -- Accept contract goal
(2003, 'RP', 'PF', 'ST', 'Completar exitosamente una meta f' || U&'\00E1' || 'cil de contrato', '', 15), -- Complete easy goal
(2004, 'RP', 'PF', 'ST', 'Completar exitosamente una meta media de contrato', '', 30), -- Complete medium goal
(2005, 'RP', 'PF', 'ST', 'Completar exitosamente una meta dif' || U&'\00ED' || 'cil de contrato', '', 50), -- Complete difficult goal
(2006, 'RP', 'PF', 'ST', 'Alto desempe' || U&'\00F1' || 'o en un contrato', '', 25), -- High performance on contract
(2007, 'RP', 'PF', 'ST', 'Mejor desempe' || U&'\00F1' || 'o en un contrato', '', 50), -- Top performance on contract
(2008, 'RP', 'PF', 'AL', 'Recibir feedback positivo de docente', '', 10), -- Receive positive feedback (from teacher)
(2009, 'RP', 'PF', 'AL', 'Recibir feedback positivo de estudiante', '', 5), -- Receive positive feedback (from student)
(2012, 'RP', 'PF', 'AL', 'Recibir feedback negativo de docente', '', -2), -- Negative feedback (from teacher)
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
(20, 'B', 1, 'performer', 'Buen desempe'|| U&'\00F1' ||'o', 'Recibir feedback positivo de docente', 2008), -- Positive feedback (from teacher)
(21, 'S', 10, 'superperformer', 'S' || U&'\00FA' || 'per desempe'|| U&'\00F1' ||'o', 'Recibir 10 feedback positivo de docente', 2008), -- Positive feedback (from teacher)
(22, 'G', 50, 'eliteperformer', U&'\00E9' || 'lite desempe'|| U&'\00F1' ||'o', 'Recibir 50 feedback positivo de docente', 2008), -- Positive feedback (from teacher)
(23, 'B', NULL, 'peerrecognition', 'Reconocido', 'Recibir feedback positivo de estudiante', 2009), -- Positive feedback (from student)

-- Reputation
(2, 'B', 50, 'junioruser','Usuario junior', 'Ganar 50 puntos de reputaci' || U&'\00F3' || 'n', 1), 
(3, 'S', 200, 'superuser','Usuario s' || U&'\00FA' || 'per', 'Ganar 200 puntos de reputaci' || U&'\00F3' || 'n', 1),
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