-- Load schools
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertSchool(NULL, 'GLV', 'Guillermo Leon Valencia Colegio (sede integrado)', 'Calle 15A Nro 7 - 48','Duitama','Boyaca');
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertSchool(NULL, 'ITIRR', 'Instituto Técnico Industrial Rafael Reyes', 'Carrera 18 # 23-116','Duitama','Boyaca');

SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, 2020, '10-03',10, NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, 2020, '10-01',10, NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, 2020, '10-05',10, NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, 2020, '9-03',9, NULL);

-- Add sample reward
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 2020, 'Tiquetes al cine', 'Tiquetes al cine en Innovo.', 6000, 'ET', 'Innovo', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 2020, 'Pizza', 'Pizza y gaseosa.', 5000, 'FD', 'Pizza Show', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 2020, 'Hamburguesa', 'Hamburguesa y gaseoas.', 5000, 'FD', 'Cowfish', NULL);
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, 2020, 'Guatika', 'Tiquete a Guatika.', 25000, 'ET', 'Guatika', NULL);