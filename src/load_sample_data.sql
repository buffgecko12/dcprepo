-- Load schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'Guillermo Leon Valencia Colegio (sede integrado)', 'Calle 15A Nro 7 - 48','Duitama','Boyaca');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'Instituto Técnico Industrial Rafael Reyes', 'Carrera 18 # 23-116','Duitama','Boyaca');

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-03');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-01');

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

-- Add students
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertStudent(2,1);


/*
-- Create a contract (including participants)
SELECT $DB_NAME$Views.SP_DCPUpsertContract(
    NULL, 
    '903', 
    1, 
    CURRENT_TIMESTAMP, 
    CURRENT_TIMESTAMP + INTERVAL '20' DAY, 
    CURRENT_TIMESTAMP + INTERVAL '10' DAY, 
    NULL, NULL, NULL, NULL, NULL, 
    JSONB('{"participants": [{"userid": 1,"contractrole": "MR","signaturets" : "2017-10-29 12:00:00.000000"},{"userid": 2,"contractrole": "PL","signaturets" : "2017-10-29 12:00:00.000000"},{"userid": 3,"contractrole": "BL","signaturets" : "2017-10-29 12:00:00.000000"},{"userid": 4,"contractrole": "PT","signaturets" : "2017-10-29 12:00:00.000000"},{"userid": 5,"contractrole": "PT","signaturets" : "2017-10-29 12:00:00.000000"},{"userid": 6,"contractrole": "PT","signaturets" : "2017-10-29 12:00:00.000000"},{"userid": 7,"contractrole": "PT","signaturets" : null}]}'),
    NULL
);
*/