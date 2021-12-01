-- Reverse Index (with stop words) in SQL
--  create a table of documents and then produce a reverse index with stop words for those documents that identifies each document which contains a particular word using SQL.


CREATE TABLE docs02 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert02 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs02(id) ON DELETE CASCADE
);

INSERT INTO docs02 (doc) VALUES
('most used word was used is very easy for the computer'),
('Our personal information analysis assistant quickly told us that the'),
('word to was used sixteen times in the first three paragraphs of this'),
('This very fact that computers are good at things that humans are not is'),
('why you need to become skilled at talking computer language Once you'),
('learn this new language you can delegate mundane tasks to your partner'),
('uniquely suited for You bring creativity intuition and inventiveness'),
('While this book is not intended for professional programmers'),
('professional programming can be a very rewarding job both financially'),
('and personally Building useful elegant and clever programs for others');

CREATE TABLE stop_words (word TEXT unique);

INSERT INTO stop_words (word) VALUES 
('i'), ('a'), ('about'), ('an'), ('are'), ('as'), ('at'), ('be'), 
('by'), ('com'), ('for'), ('from'), ('how'), ('in'), ('is'), ('it'), ('of'), 
('on'), ('or'), ('that'), ('the'), ('this'), ('to'), ('was'), ('what'), 
('when'), ('where'), ('who'), ('will'), ('with');

-- thorw out the words in the stop word list
SELECT DISTINCT id, s.keyword AS keyword
FROM docs02 AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

-- put the stop_word free list into the invert02
INSERT INTO invert02 (doc_id, keyword)
SELECT DISTINCT id, s.keyword AS keyword
FROM docs02 AS D, unnest(string_to_array(lower(D.doc), ' ')) s(keyword)
WHERE s.keyword NOT IN (SELECT word FROM stop_words)
ORDER BY id;

-- test:
SELECT keyword, doc_id FROM invert02 ORDER BY keyword, doc_id LIMIT 10;

keyword    |  doc_id
-----------+--------
analysis   |    2    
and        |    7    
and        |    10   
assistant  |    2    
become     |    5    
book       |    8    
both       |    9    
bring      |    7    
building   |    10   
can        |    6    
