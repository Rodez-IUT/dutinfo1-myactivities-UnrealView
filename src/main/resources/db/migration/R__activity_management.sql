CREATE OR REPLACE FUNCTION add_activity(in_title varchar(200), in_description text,in_owner_id bigint) RETURNS activity AS $$
	DECLARE
		newActivity activity%ROWTYPE;
		defaultOwnerId "user".id%TYPE;
		defaultOwnerUsername varchar(500) := 'Default Owner';
	BEGIN
		SELECT id INTO defaultOwnerId FROM "user"
		WHERE username = defaultOwnerUsername;
		INSERT INTO activity
		VALUES(nextval('id_generator'), in_title, in_descritpion, now(), now(), in_owner_id);
		
		SELECT * INTO newActivity
		FROM activity
		WHERE id = lastval();
		RETURN newActivity;
	END
$$ LANGUAGE plpgsql;