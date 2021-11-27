-- We will do some things differently in this assignment. We will not use a separate "raw" table, we will just use ALTER TABLE statements to remove columns after we don't need them (i.e. we converted them into foreign keys).
-- We will use the same CSV track data as in prior exercises - this time we will build a many-to-many relationship using a junction/through/join table between tracks and artists.

DROP TABLE album CASCADE;
CREATE TABLE album (
    id SERIAL,
    title VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE track CASCADE;
CREATE TABLE track (
    id SERIAL,
    title TEXT, 
    artist TEXT, 
    album TEXT, 
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    count INTEGER, 
    rating INTEGER, 
    len INTEGER,
    PRIMARY KEY(id)
);

DROP TABLE artist CASCADE;
CREATE TABLE artist (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

DROP TABLE tracktoartist CASCADE;
CREATE TABLE tracktoartist (
    id SERIAL,
    track VARCHAR(128),
    track_id INTEGER REFERENCES track(id) ON DELETE CASCADE,
    artist VARCHAR(128),
    artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
);

INSERT INTO album (title) SELECT DISTINCT album FROM track;
UPDATE track SET album_id = (SELECT album.id FROM album WHERE album.title = track.album);

INSERT INTO tracktoartist (track, artist) SELECT DISTINCT title, artist FROM track;
INSERT INTO artist (name) SELECT DISTINCT artist FROM tracktoartist;

UPDATE tracktoartist SET track_id = (SELECT track.id FROM track WHERE track.title = tracktoartist.track);
UPDATE tracktoartist SET artist_id = (SELECT artist.id FROM artist WHERE artist.name = tracktoartist.artist);

ALTER TABLE track DROP COLUMN album;
ALTER TABLE track DROP COLUMN artist;
ALTER TABLE tracktoartist DROP COLUMN track;
ALTER TABLE tracktoartist DROP COLUMN artist;


-- Test:
SELECT track.title, album.title, artist.name
FROM track
JOIN album ON track.album_id = album.id
JOIN tracktoartist ON track.id = tracktoartist.track_id
JOIN artist ON tracktoartist.artist_id = artist.id
ORDER BY track.title
LIMIT 3;

--The expected result of this query on your database is:
title	                      album	                                   artist
A Boy Named Sue (live)	    The Legend Of Johnny Cash	               Johnny Cash
A Brief History of Packets	Computing Conversations	IEEE             Computer Society
Aguas De Marco	            Natural Wonders Music Sampler 1999	     Rosa Passos
