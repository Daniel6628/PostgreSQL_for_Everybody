-- Create this table:
CREATE TABLE keyvalue ( 
  id SERIAL,
  key VARCHAR(128) UNIQUE,
  value VARCHAR(128) UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY(id)
);
-- Add a stored procedure so that every time a record is updated, the updated_at variable is automatically set to the current time.

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON keyvalue
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
