/* 
	Cleanup script to remove all logic (i.e. views, SPs, udfs).
	Must be removed in proper order because of dependencies.
*/

-- Suppress "NOTICE" messages
SET client_min_messages=WARNING;

DO
$$
DECLARE
  l_rec record;
  l_stmt text;
BEGIN
    FOR l_rec IN (
        SELECT ObjectType, SchemaName, ObjectName
        FROM (
            -- Functions
            SELECT 
                n.nspname AS SchemaName,
                p.proname AS ObjectName,
                CASE p.prokind WHEN 'f' THEN'FUNCTION' WHEN'p' THEN 'PROCEDURE' WHEN 'a' THEN 'AGGREGATE' WHEN 'w' THEN 'WINDOW' END AS ObjectType
            FROM pg_proc p
            LEFT JOIN pg_namespace n ON p.pronamespace = n.oid
            LEFT JOIN pg_language l ON p.prolang = l.oid
            LEFT JOIN pg_type t ON t.oid = p.prorettype 
            
            UNION ALL
            
            -- Views
            SELECT SchemaName, ViewName AS ObjectName, 'VIEW' AS ObjectType
            from pg_views 
        ) src
        WHERE LOWER(SchemaName) = LOWER('$APP_NAME$Views')
        ORDER BY SchemaName, ObjectType, ObjectName
    )
  LOOP
    l_stmt := FORMAT('DROP %s IF EXISTS %I.%I CASCADE;', l_rec.ObjectType, l_rec.SchemaName, l_rec.ObjectName);
    RAISE NOTICE 'Dropping %', l_stmt;
    EXECUTE l_stmt;
  END LOOP;
end;
$$
;