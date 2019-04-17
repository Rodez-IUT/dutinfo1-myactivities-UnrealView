DROP TRIGGER IF EXISTS log_delete_activity ON activity;

CREATE OR REPLACE FUNCTION log_delete_activity() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO action_log 
	VALUES (nextval('id_generator'),'delete','activity',OLD.id,user,now());
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_delete_activity
	AFTER DELETE ON activity
	FOR EACH ROW EXECUTE PROCEDURE log_delete_activity();
