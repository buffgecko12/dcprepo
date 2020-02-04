-- Load schools
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertSchool(NULL, 'GLV', 'Guillermo Leon Valencia Colegio (sede integrado)', 'Calle 15A Nro 7 - 48','Duitama','Boyaca');
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertSchool(NULL, 'ITIRR', 'Instituto Técnico Industrial Rafael Reyes', 'Carrera 18 # 23-116','Duitama','Boyaca');

SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, CAST(2020 AS SMALLINT), '10-03',CAST(10 AS SMALLINT), NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, CAST(2020 AS SMALLINT), '10-01',CAST(10 AS SMALLINT), NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, CAST(2020 AS SMALLINT), '10-05',CAST(10 AS SMALLINT), NULL);
SELECT * FROM $APP_NAME$Views.SP_DCPUpsertClass(NULL, 1, CAST(2020 AS SMALLINT), '9-03',CAST(9 AS SMALLINT), NULL);

-- Add sample reward
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, CAST(2020 AS SMALLINT), 'Tiquetes al cine', 'Tiquetes al cine en Innovo.', 6000, 'Innovo');
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, CAST(2020 AS SMALLINT), 'Pizza', 'Pizza y gaseosa.', 5000, 'Pizza Show');
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, CAST(2020 AS SMALLINT), 'Hamburguesa', 'Hamburguesa y gaseoas.', 5000, 'Cowfish');
SELECT $APP_NAME$Views.SP_DCPUpsertReward(NULL, CAST(2020 AS SMALLINT), 'Guatika', 'Tiquete a Guatika.', 25000, 'Guatika');