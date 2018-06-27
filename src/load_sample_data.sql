-- Load schools
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'Guillermo Leon Valencia Colegio (sede integrado)', 'GLV (Integrado)', 'Calle 15A Nro 7 - 48','Duitama','Boyaca');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertSchool(NULL, 'Instituto Técnico Industrial Rafael Reyes', 'ITIRR', 'Carrera 18 # 23-116','Duitama','Boyaca');

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-03');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-01');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '10-05');
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertClass(NULL, 1, '9-03');

-- Add teacher info + classes
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(3, 1,
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

SELECT * FROM $DB_NAME$Views.SP_DCPUpsertTeacher(4, 1,
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

-- Add contract
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertContract(
	NULL,1,'G',3,TSTZRANGE(current_timestamp,current_timestamp + INTERVAL '1' MONTH,'[]'),FALSE,current_timestamp + INTERVAL '14' DAY,NULL,'Some student leader requirements',NULL,NULL,NULL,
	JSONB('{"currentgoals": [{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null},{"goalid": null, "difficultylevel": "M","goaldescription": "Some description","achievedflag": null}]}'),
	JSONB('{"currentrewards": [{"rewardid": null, "difficultylevel": "M","rewarddescription": "Some description"},{"rewardid": null, "difficultylevel": "M","rewarddescription": "Some description"}]}'),
	JSONB('{"currentparties": [{"partyuserid": 2,"contractrole": "MR"},{"partyuserid": 3,"contractrole": "PL"},{"partyuserid": 4,"contractrole": "BL"},{"partyuserid": 5,"contractrole": "PT"}]}')
);

-- Add reputation events
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUserReputationEvent(3,'BP', current_timestamp, 10, 1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUserReputationEvent(3,'OP', current_timestamp, 30, 1);
SELECT * FROM $DB_NAME$Views.SP_DCPUpsertUserReputationEvent(4,'TP', current_timestamp, 15, 1);
