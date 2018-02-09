DROP TABLE IF EXISTS sushi;
CREATE TABLE sushi (c1 INT, c2 tstzrange);
INSERT INTO sushi VALUES(1, tstzrange(CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'[]'));
    
-- Check overlap    
SELECT *
FROM   sushi
WHERE tstzrange(CURRENT_TIMESTAMP - INTERVAL '1' MONTH, CURRENT_TIMESTAMP + INTERVAL '1' YEAR, '[]')
 && c2;

-- Extract start/end times
SELECT LOWER(c2), UPPER(c2) 
FROM sushi;


-- current_timestamp returns with timezoe
-- use localtimestamp to return without timezone

-- use tsrange instead of tstzrange for no time zone
-- https://www.postgresql.org/docs/10/static/functions-range.html