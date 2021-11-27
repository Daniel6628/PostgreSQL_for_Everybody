DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE state (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE iso (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE region (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- To load the CSV data for this assignment use the following copy command. Adding HEADER causes the CSV loader to skip the first line in the CSV file.
\copy unesco_raw(name,description,justification,year,longitude,latitude,area_hectares,category,state,region,iso) FROM 'whc-sites-2018-small.csv' WITH DELIMITER ',' CSV HEADER;

-- Normalize the data in the unesco_raw table by adding the entries to each of the lookup tables (category, etc.) and then adding the foreign key columns to the unesco_raw table. 
-- Then make a new table called unesco that removes all of the un-normalized redundant text columns like category.

INSERT INTO category(name) SELECT DISTINCT category FROM unesco_raw;
INSERT INTO state(name) SELECT DISTINCT state FROM unesco_raw;
INSERT INTO iso(name) SELECT DISTINCT iso FROM unesco_raw;
INSERT INTO region(name) SELECT DISTINCT region FROM unesco_raw;

--adding the foreign key columns to the unesco_raw 
UPDATE unesco_raw SET category_id = (SELECT category.id FROM category WHERE category.name = unesco_raw.category);
UPDATE unesco_raw SET state_id = (SELECT state.id FROM state WHERE state.name = unesco_raw.state);
UPDATE unesco_raw SET iso_id = (SELECT iso.id FROM iso WHERE iso.name = unesco_raw.iso);
UPDATE unesco_raw SET region_id = (SELECT region.id FROM region WHERE region.name = unesco_raw.region);

CREATE TABLE unesco(
	id SERIAL,
	name VARCHAR(300),
	description VARCHAR(300),
	justification VARCHAR(300),
	year INTEGER,
	category VARCHAR(300),
	state VARCHAR(300),
	region VARCHAR(300),
	iso VARCHAR(128),
	category_id INTEGER REFERENCES category(id) ON DELETE CASCADE,
	state_id INTEGER REFERENCES state(id) ON DELETE CASCADE,
	iso_id INTEGER REFERENCES iso(id) ON DELETE CASCADE,
	region_id INTEGER REFERENCES region(id) ON DELETE CASCADE,
	UNIQUE(name, category_id),
	UNIQUE(name, state_id),
	UNIQUE(name, iso_id),
	UNIQUE(name, region_id),
	PRIMARY KEY(id)
);

INSERT INTO unesco(name, year, category, state, region, iso, category_id, state_id, iso_id, region_id) 
SELECT DISTINCT name, year, category, state, region, iso, category_id, state_id, iso_id, region_id
FROM unesco_raw;


-- test:
SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY year, unesco.name
  LIMIT 3;
  
  
-- The expected result of this query on your database is:
Name	             Year	 Category	  State	   Region	                           iso
Aachen Cathedral	 1978	 Cultural	  Germany	 Europe and North America	         de
City of Quito	     1978	 Cultural	  Ecuador	 Latin America and the Caribbean	 ec
Gal pagos Islands	 1978	 Natural	  Ecuador	 Latin America and the Caribbean	 ec
