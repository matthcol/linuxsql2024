SELECT * FROM persons;
SELECT * FROM movies;

-- projection
SELECT title, YEAR FROM movies;

-- selection (filter)
SELECT * FROM movies WHERE YEAR = 1984;

-- selection + projection
SELECT title, YEAR FROM movies WHERE YEAR = 1984;

-- films de l'année 2015 et d'une durée > 2H
SELECT *
FROM movies
WHERE
	YEAR = 2015
	AND duration > 120
ORDER BY duration
;

SELECT * 
FROM movies 
WHERE YEAR BETWEEN 2010 AND 2019
ORDER BY YEAR, title;

-- film: The Terminator
SELECT * FROM movies WHERE title = 'The Terminator';

-- film dont le titre contient: Terminator
SELECT * FROM movies WHERE title LIKE '%Terminator%';
SELECT * FROM movies WHERE title LIKE '%terminator%'; -- ci: case insensitive
SELECT * FROM persons WHERE id = 116;

-- predicates (WHERE, selection)
--
-- year = 2010
-- year <> 2010
-- year != 2010
-- year > 2000    year >= 2000   year < 2000   year <= 2000
-- year between 2010 and 2019  (both limits included)
-- title like '%Terminator%'
--
-- combine with: AND, OR, NOT

SELECT * 
FROM movies 
WHERE 
	YEAR BETWEEN 2010 AND 2019
	AND YEAR <> 2015  
	-- AND YEAR != 2015
ORDER BY YEAR, title;

SELECT *
FROM movies
WHERE 
	title LIKE '%Terminator%'
	OR title LIKE '%Jaws%'
;

SELECT *
FROM persons
WHERE birthdate IS NULL
;

SELECT *
FROM persons
WHERE birthdate IS NOT NULL
;

SELECT *
FROM movies
WHERE YEAR IN (1954, 1984, 2010)
ORDER BY YEAR, title
; 

SELECT *
FROM movies
WHERE
	YEAR BETWEEN 1980 AND 1989 
	AND YEAR NOT IN (1981, 1987)
ORDER BY YEAR, title
; 

-- homonymes
SELECT id, title, YEAR
FROM movies
WHERE title = 'The Man Who Knew Too Much'
;

SELECT *
FROM persons
WHERE NAME = 'Steve McQueen'
;

-- functions
-- link doc: https://mariadb.com/kb/en/built-in-functions/
-- * math: abs, sqrt, round, floor, ceil, ...
-- * texte: lower, upper, 
SELECT
	UPPER(title) AS title
	, year
	, FLOOR(YEAR / 10) * 10 AS decade
FROM movies
WHERE YEAR >= 1980
ORDER BY YEAR
;

SELECT
	UPPER(title) AS title                 -- 3: projection
	, year
	, FLOOR(YEAR / 10) * 10 AS decade
FROM movies                              -- 1: source
WHERE FLOOR(YEAR / 10) * 10 = 1980       -- 2: selection (where)
ORDER BY YEAR                            -- 4: order by
;

SELECT
	UPPER(title) AS title                           -- 3: projection
	, YEAR
	, FLOOR(YEAR / 10) * 10 AS decade
FROM movies                                        -- 1: source
WHERE FLOOR(YEAR / 10) * 10 IN (1980, 1983, 1985)  -- 2: selection (where)
ORDER BY decade                                    -- 4: order by
;

-- join(ture)

-- films Terminator avec leur réalisteur
SELECT 
	m.id
	, m.title
	, m.year
	, m.director_id
	, d.id
	, d.name
FROM 
	movies m
	INNER JOIN persons d ON m.director_id = d.id
WHERE m.title LIKE '%Terminator%';

-- filmographie du réalisateur James Cameron

SELECT
	m.year
	, m.title
	, d.id
	, d.name
FROM
	movies m
	JOIN persons d ON m.director_id = d.id
WHERE
	d.name = 'James Cameron'
ORDER BY d.id, m.year DESC
;

-- actors
SELECT
	m.title
	, m.year
	, a.name
FROM
	movies m
	JOIN play pl ON m.id = pl.movie_id
	JOIN persons a ON pl.actor_id = a.id
WHERE
	m.title = 'The Terminator'
	AND m.year = 1984
;

-- filmographie en tant qu'acteur de Clint Eastwood
SELECT 
	m.title
	, m.year
	, a.id
	, a.name
	, a.birthdate
	, YEAR(a.birthdate) AS birth_year
	, EXTRACT(YEAR FROM a.birthdate) AS birth_year2
FROM
	movies m
	JOIN play pl ON m.id = pl.movie_id
	JOIN persons a ON pl.actor_id = a.id
WHERE
  	a.name = 'Clint Eastwood'
ORDER BY a.id, m.year DESC 
;

-- filmographie en tant qu'acteur de Schwarzy
SELECT
	m.title
	, m.year
	, a.name AS actor_name
FROM
	movies m
	JOIN play pl ON m.id = pl.movie_id
	JOIN persons a ON pl.actor_id = a.id
WHERE a.name LIKE '%warze%'
ORDER BY m.year
;

-- titre le plus long
SELECT 
    m.title,
    m.year,
    LENGTH(m.title) AS title_length
FROM
    movies m
ORDER BY 
    title_length DESC
LIMIT 1;
;

-- aggregate functions (statistics)
SELECT 
	COUNT(*) AS nb_movie
	, COUNT(duration) AS nb_duration
	, MIN(m.year) AS first_year
	, MAX(m.year) AS last_year
	, ROUND(AVG(m.duration)) AS avg_duration
	, ROUND(SUM(m.duration) / 60) AS total_duration_h
FROM movies m;
	

SELECT
	m.year
	, COUNT(*) AS nb_movie
FROM movies m
GROUP BY m.year
ORDER BY m.year;


SELECT
	m.year
	, COUNT(*) AS nb_movie
FROM movies m
GROUP BY m.year
ORDER BY nb_movie DESC;
 
SELECT                        -- 4: projection
	m.year
	, COUNT(*) AS nb_movie
FROM movies m                 -- 1: source
WHERE m.duration >= 120       -- 2: filter/selection (where)
GROUP BY m.year               -- 3: grouping
ORDER BY nb_movie DESC;			-- 5: sorting

SELECT                        -- 5: projection
	m.year
	, COUNT(*) AS nb_movie
FROM movies m                 -- 1: source
WHERE m.duration >= 120       -- 2: filter/selection (where): row
GROUP BY m.year               -- 3: grouping
HAVING COUNT(*) >= 10         -- 4: filter/selection (having): group
ORDER BY nb_movie DESC;			-- 6: sorting

-- DML: add (INSERT), modify (UPDATE), remove (DELETE)
-- verify integrity constraints (not null, unique, check, foreign key)
INSERT INTO movies (title, YEAR) VALUES ('Kingdom of the Planet of the Apes', 2024);
-- id: 8079249

-- INSERT INTO movies (title, YEAR) VALUES ('Kingdom of the Planet of the Apes', 2024); -- constraint error
INSERT INTO movies (title, YEAR) VALUES ('Dune: Part Two', 2024);
INSERT INTO movies (title, YEAR) VALUES ('Joker: Folie à Deux', 2024);

SELECT * FROM movies WHERE YEAR = 2024;

-- INSERT INTO movies (title) VALUES ('Avatar 2'); -- year mandatory
-- INSERT INTO movies (title, year) VALUES ('Avatar 2, 2022); -- syntax error

SELECT * FROM persons WHERE NAME = 'Wes Ball'; -- no one
INSERT INTO persons (NAME) VALUES ('Wes Ball');
SELECT * FROM persons WHERE NAME = 'Wes Ball'; -- id: 11903874

UPDATE movies SET director_id = 11903874 WHERE id = 8079249;
SELECT * FROM movies WHERE YEAR = 2024;

-- inner join: only movies with director
SELECT 
	* 
FROM 
	movies m
	JOIN  persons d ON m.director_id = d.id
WHERE m.year = 2024;


SELECT 
	* 
FROM 
	movies m 
	LEFT JOIN  persons d ON m.director_id = d.id
WHERE m.year = 2024
;

-- UPDATE movies SET director_id = 12000000 WHERE id = 8079251; -- foreign key constraint error




















