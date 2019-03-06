CREATE OR REPLACE FUNCTION find_all_activities_for_owner(username varchar(40)) RETURNS SETOF activity AS $$
SELECT A.*
FROM activity A
JOIN "user" U
ON U.id = owner_id
WHERE U.username = find_all_activities_for_owner.username
$$ LANGUAGE SQL;