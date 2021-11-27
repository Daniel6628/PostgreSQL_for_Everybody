-- This application will read an iTunes library in comma-separated-values (CSV) format and produce properly normalized tables as specified below.
-- We will ignore the artist field for this assignment and focus on the many-to-one relationship between tracks and albums.

-- Create tables:
CREATE TABLE album (
  id SERIAL,
  title VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE track (
    id SERIAL,
    title VARCHAR(128),
    len INTEGER, rating INTEGER, count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS track_raw;
CREATE TABLE track_raw
 (title TEXT, artist TEXT, album TEXT, album_id INTEGER,
  count INTEGER, rating INTEGER, len INTEGER);
  
  -- Load the CSV data file into the track_raw table using the \copy command
  -- Then write SQL commands to insert all of the distinct albums into the album table
  -- Then set the album_id in the track_raw table
  
  \copy track_raw(title, artist, album, album_id, count, rating) FROM 'library.csv' WITH DELIMITER ',' CSV;
  INSERT INTO album(title) SELECT DISTINCT album FROM track_raw;
  UPDATE track_raw SET album_id = (SELECT album.id FROM album WHERE album.title = track_raw.album);
  
  -- Then use a INSERT ... SELECT statement to copy the corresponding data from the track_raw table to the track table
  INSERT INTO track(title, len, rating, count, album_id) SELECT DISTINCT title, len, rating, count, album_id FROM track_raw;
  
  
  -- Test:
  SELECT track.title, album.title
    FROM track
    JOIN album ON track.album_id = album.id
    ORDER BY track.title LIMIT 3;
    
 The expected result of this query on your database is:
track	album
A Boy Named Sue (live)	The Legend Of Johnny Cash
A Brief History of Packets	Computing Conversations
Aguas De Marco	Natural Wonders Music Sampler 1999
