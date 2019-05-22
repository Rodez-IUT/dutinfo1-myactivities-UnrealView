CREATE OR REPLACE function register_user_on_activity(in_user_id bigint, in_activity_id bigint) RETURNS registration AS $$
    DECLARE
        res_registration registration%rowtype;
    BEGIN
        -- check existence
        SELECT * INTO res_registration from registration
        WHERE user_id = in_user_id and activity_id = in_activity_id;
        IF FOUND THEN
            raise exception 'registration_already_exists';
        END IF;
        -- insert
        INSERT INTO registration (id, user_id, activity_id)
        VALUES(nextval('id_generator'), in_user_id, in_activity_id);
        -- returns result
        SELECT * INTO res_registration FROM registration
        WHERE user_id = in_user_id AND activity_id = in_activity_id;
        return res_registration;
    END;
$$ LANGUAGE plpgsql;
 
 CREATE OR REPLACE FUNCTION unregister_user_on_activity(id_user bigint, id_activity bigint) RETURNS void AS $$
 	BEGIN
		-- Check existence
		DELETE FROM registration
		WHERE user_id = id_user AND activity_id = id_activity;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'registration_not_found';
		END IF;
	END;
 $$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS log_insert_delete_registration ON registration;

CREATE OR REPLACE FUNCTION log_insert_delete_registration() RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
        INSERT INTO action_log 
		VALUES (nextval('id_generator'),'delete','registration',OLD.id,user,now());
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO action_log 
		VALUES (nextval('id_generator'),'insert','registration',NEW.id,user,now());
        RETURN NEW;
    END IF;
    RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_insert_delete_registration
	AFTER DELETE OR INSERT ON registration
	FOR EACH ROW EXECUTE PROCEDURE log_insert_delete_registration();
