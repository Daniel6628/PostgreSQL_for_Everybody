-- create a table of documents and then produce a reverse index for those documents that identifies each document which contains a particular word (lower case) using SQL.

CREATE TABLE docs01 (id SERIAL, doc TEXT, PRIMARY KEY(id));

DROP TABLE invert01;
CREATE TABLE invert01 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs01(id) ON DELETE CASCADE
);

INSERT INTO docs01 (doc) VALUES
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

INSERT INTO invert01(doc_id, keyword)
SELECT DISTINCT id, s.keyword AS keyword
FROM docs01 AS D, unnest((string_to_array(lower(D.doc), ' '))) s(keyword)
ORDER BY id;

-- test:
SELECT keyword, doc_id FROM invert01 ORDER BY keyword, doc_id LIMIT 10;

keyword    |  doc_id
-----------+--------
a          |    9    
analysis   |    2    
and        |    7    
and        |    10   
are        |    4    
assistant  |    2    
at         |    4    
at         |    5    
be         |    9    
become     |    5    
