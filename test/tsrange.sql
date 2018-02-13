DROP TABLE IF EXISTS sushi;
CREATE TABLE sushi (c1 INT, c2 tstzrange);
INSERT INTO sushi VALUES(1, tstzrange(TIMESTAMP '2018-01-01 00:00:00', TIMESTAMP '2019-01-01 00:00:00','[]'));
INSERT INTO sushi VALUES(2, tstzrange(TIMESTAMP '2018-01-01 00:00:00', TIMESTAMP '2019-01-01 00:00:00','(]'));
    
-- Check overlap    
SELECT *
FROM sushi
WHERE c2 @> TIMESTAMP WITH TIME ZONE '2018-01-01 00:00:00'
OR c2 @> TIMESTAMP WITH TIME ZONE '2019-01-01 00:00:00'
;

-- Extract start/end times
SELECT LOWER(c2), UPPER(c2) 
FROM sushi;

-- current_timestamp returns with timezoe
-- use localtimestamp to return without timezone

-- use tsrange instead of tstzrange for no time zone
-- https://www.postgresql.org/docs/10/static/functions-range.html