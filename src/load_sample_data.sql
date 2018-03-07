-- Load schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'Guillermo Leon Valencia Colegio (sede integrado)', 'Calle 15A Nro 7 - 48','Duitama','Boyaca');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'Instituto Técnico Industrial Rafael Reyes', 'Carrera 18 # 23-116','Duitama','Boyaca');

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-03');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-01');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-05');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '9-03');

-- Add teacher info + classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(1,
	JSONB(
	'{
		"deletedclasses": [],
		"currentclasses": [
			{"classid":1},
			{"classid":2}
		]	
	}'
	)
);

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(2,
	JSONB(
	'{
		"deletedclasses": [],
		"currentclasses": [
			{"classid":2},
			{"classid":3}
		]	
	}'
	)
);

-- Add students
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(3,1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(4,1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(5,1);
