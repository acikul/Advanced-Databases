--peti
SELECT firstandlastname, COUNT(*) noOfTracks, rank() OVER (ORDER BY COUNT(*) DESC) rang
FROM (SELECT unnest(castandcrew) AS firstandlastname FROM track) tempTab
WHERE firstandlastname LIKE 'Kate %'
GROUP BY firstandlastname
ORDER BY nooftracks DESC





--cetvrti
SELECT tracktitle, CAST(viewstartdatetime AS TIME), COUNT(*) OVER( PARTITION BY tracktitle--, viewstartdatetime::TIME
																   ORDER BY viewstartdatetime::TIME::INTERVAL
																   RANGE BETWEEN '4 h'::INTERVAL PRECEDING AND CURRENT ROW
																 ) currentandprev4h
FROM track NATURAL JOIN trackview NATURAL JOIN showep
WHERE (SELECT COUNT(*) 
		FROM unnest(string_to_array(tracktitle, ' ')) AS wrd 
		WHERE levenshtein(lower(wrd), 'vidaut') < 4) > 0;







--treci
WITH RECURSIVE zanrovi(genreid, genrename, supgenreid) AS
	(
		SELECT genreid, genrename, supgenreid
		FROM genre
		
		UNION
		
		SELECT zanrovi.genreid, genre.genrename, genre.supgenreid
		FROM genre, zanrovi
		WHERE zanrovi.supgenreid = genre.genreid
		
	)
SELECT DISTINCT genre.genreid, genrename, SUM(viewenddatetime-viewstartdatetime) AS totalTime
FROM trackview NATURAL JOIN trackgenre NATURAL JOIN zanrovi JOIN genre USING(genrename)
GROUP BY genrename, genre.genreid





--drugi

DROP TABLE IF EXISTS langs;
CREATE TEMP TABLE langs(langn varchar);
INSERT INTO langs VALUES('English');
INSERT INTO langs VALUES('German');
INSERT INTO langs VALUES('Indonesian');
INSERT INTO langs VALUES('Korean');

SELECT * FROM crosstab('
SELECT tagerestriction, langname, COUNT(DISTINCT profilename)
FROM movie JOIN track ON movie.trackId = track.trackId
		   JOIN trackview ON movie.trackId = trackview.trackId
		   JOIN audiolang ON movie.trackId = audiolang.trackId
		   JOIN language ON language.langid = audiolang.audiolangid
WHERE to_tsvector(''english'', tracktitle) || to_tsvector(''english'', description) @@ to_tsquery(''english'', ''activ | ride'')
		AND (langname = ''English'' or langname = ''German'' or langname = ''Indonesian'' or langname = ''Korean'')
GROUP BY tagerestriction, langname
ORDER BY tagerestriction, langname', 'SELECT langn FROM langs') AS pivotTab(agerestriction INT, english INT, german INT, indonesian INT, korean INT)
ORDER BY agerestriction;



--prvi

SELECT tracktitle, castandcrew[1] AS firstcastcrew
FROM track
WHERE castandcrew[1] IS NOT NULL AND (
	SELECT COUNT(*) FROM unnest(string_to_array(tracktitle, ' ')) AS wrd 
	WHERE wrd % 'magia'
	) > 0




