
drop table if exists elsha;
create table elsha (
	c1 int, 
	t2 tstzrange
)
--PARTITION BY LIST ((CASE WHEN CAST(CAST(UPPER(t2) AS DATE) AS VARCHAR(20)) = '9999-12-31' THEN 1 ELSE 0 END))
;

insert into elsha values
(1, tstzrange(current_timestamp - INTERVAL '1' YEAR,current_timestamp + INTERVAL '1' YEAR,'[]')),
(2, tstzrange(current_timestamp - INTERVAL '1' MONTH,current_timestamp + INTERVAL '1' MONTH,'[]')),
(3, tstzrange(current_timestamp - INTERVAL '1' DAY,current_timestamp + INTERVAL '1' DAY,'[]')),
(4, tstzrange(current_timestamp + INTERVAL '1' DAY,'infinity','[]'));


select * from elsha 
where t2 @> current_timestamp + INTERVAL '1' DAY;

DROP INDEX IF EXISTS current_row;

CREATE INDEX current_row ON elsha(t2)
WHERE t2 IS NOT NULL


explain
select * from elsha
where t2 IS NOT NULL
