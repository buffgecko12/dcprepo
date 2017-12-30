-- Create some users
SELECT $DB_NAME$Views.SP_DCPUpsertUser(NULL,NULL,NULL,NULL,NULL,
    JSONB('
		{
		    "users": 
		    [
		        {
		            "firstname": "Juan Martin",
		            "lastname": "del Potro",
		            "userid": 1,
		            "usertype": "TR"
		        },
		        {
		            "firstname": "Garbine",
		            "lastname": "Muguruza",
		            "userid": 2,
		            "usertype": "ST"
		        },
		        {
		            "firstname": "Fernando",
		            "lastname": "Verdasco",
		            "userid": 3,
		            "usertype": "ST"
		        },
		        {
		            "firstname": "James",
		            "lastname": "Rodriguez",
		            "userid": 4,
		            "usertype": "ST"
		        },
		        {
		            "firstname": "Cristiano Bob",
		            "lastname": "Pipe Ronaldo",
		            "userid": 5,
		            "usertype": "ST"
		        },
		        {
		            "firstname": "Juan Manuel",
		            "lastname": "Santiago",
		            "userid": 6,
		            "usertype": "ST"
		        },
		        {
		            "firstname": "Michelle",
		            "lastname": "Bachelet",
		            "userid": 7,
		            "usertype": "ST"
		        }
		    ]
		}
    ')
);
 
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