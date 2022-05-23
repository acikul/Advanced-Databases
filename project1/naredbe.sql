SELECT show_trgm('fakultet');

CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION pg_trgm;

SELECT AVG(pg_column_size(automotive.*)) from automotive;

CREATE TEXT SEARCH CONFIGURATION li51404 (copy = simple);

INSERT INTO automotive (product_id, title, summary, review) VALUES ('1234567890', 'naslov', 'sazetak', 'Congratulations tHe a Riječ nuMw0rd hosT.com');
SELECT * FROM ts_debug('li51404', (SELECT review FROM automotive WHERE product_id = '1234567890'));

SELECT * FROM ts_debug('english', (SELECT review FROM automotive LIMIT 1));
SELECT * FROM ts_debug('li51404', (SELECT review FROM automotive LIMIT 1));


ALTER TEXT SEARCH CONFIGURATION li51404 ALTER MAPPING FOR word, asciiword WITH english_stem, simple;
SELECT * FROM ts_debug('li51404', (SELECT review FROM automotive ORDER BY id DESC LIMIT 1));



CREATE TEXT SEARCH DICTIONARY li51404Syn (TEMPLATE = synonym, SYNONYMS = li51404Syn);
CREATE TEXT SEARCH CONFIGURATION mySyn (copy = english);
ALTER TEXT SEARCH CONFIGURATION mySyn ALTER MAPPING FOR word, asciiword WITH li51404Syn, english_stem;
SELECT * FROM ts_debug('mySyn', (SELECT review FROM automotive LIMIT 1));



ALTER TEXT SEARCH CONFIGURATION li51404 ALTER MAPPING FOR word, asciiword WITH li51404Syn, english_stem, simple;
SELECT * FROM ts_debug('li51404', (SELECT review FROM automotive LIMIT 1));


SELECT plainto_tsquery('english', 'Purchased a comfortable jacket');
SELECT to_tsvector('english', (SELECT review FROM automotive LIMIT 1));
select tsquery_phrase(plainto_tsquery('english', 'annoying'), plainto_tsquery('english', 'problem'), 2)
SELECT * FROM automotive WHERE to_tsvector('english', review) @@ plainto_tsquery('english', 'jacket Purchase price motorcycle');
SELECT * FROM automotive WHERE to_tsvector('english', review) @@ phraseto_tsquery('english', 'Old cruise control switches');
SELECT * FROM automotive WHERE to_tsvector('english', review) @@ tsquery_phrase(plainto_tsquery('english', 'annoying'), plainto_tsquery('english', 'problem'), 2);


UPDATE automotive SET tsr_tsvector = setweight(to_tsvector('english', title), 'A') || setweight(to_tsvector('english', summary), 'B') || setweight(to_tsvector('english', review), 'C');
CREATE FUNCTION moj_trigger() RETURNS trigger AS $$
begin
  new.tsr_tsvector :=
     setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
     setweight(to_tsvector('pg_catalog.english', coalesce(new.summary,'')), 'B') ||
     setweight(to_tsvector('pg_catalog.english', coalesce(new.review,'')), 'C');
  return new;
end
$$ LANGUAGE plpgsql;
CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
    ON automotive FOR EACH ROW EXECUTE FUNCTION moj_trigger();

INSERT INTO automotive (product_id, title, summary, review) VALUES ('0000000000', 'riječ', 'riječ', 'riječ');
SELECT tsr_tsvector FROM automotive WHERE product_id = '0000000000';

//sedmi
SELECT ts_rank(setweight(to_tsvector('english', title), 'A'), to_tsquery('riječ')) AS title_rank FROM automotive WHERE product_id = '0000000000';
SELECT ts_rank(setweight(to_tsvector('english', summary), 'B'), to_tsquery('riječ')) AS summary_rank FROM automotive WHERE product_id = '0000000000';
SELECT ts_rank(setweight(to_tsvector('english', review), 'C'), to_tsquery('riječ')) AS review_rank FROM automotive WHERE product_id = '0000000000';

//osmi
SELECT summary, ts_rank(to_tsvector('english', summary), to_tsquery('good')) AS rank FROM automotive ORDER BY rank DESC;
SELECT summary, ts_rank(to_tsvector('english', summary), to_tsquery('bad')) AS rank FROM automotive WHERE id % 5 = 0 ORDER BY rank DESC;
SELECT summary, ts_rank(to_tsvector('english', summary), to_tsquery('perfect')) AS rank FROM automotive WHERE id % 3 = 0 ORDER BY rank DESC;
//osmi - druga tocka
SELECT id, summary, ts_rank(to_tsvector('english', summary), to_tsquery('riječ'), 2) AS rank FROM automotive ORDER BY rank DESC;
UPDATE automotive SET summary = summary || ' abcd' WHERE id = 663643;
UPDATE automotive SET summary = summary || ' the a' WHERE id = 663643;
UPDATE automotive SET summary = summary || ' efgh' WHERE id = 663643;

UPDATE automotive SET summary = 'riječ abcd the a' WHERE id = 663643;


//deveti
SELECT t1.summary, t2.summary, similarity(t1.summary, t2.summary) as q_gram_dist
FROM (SELECT * FROM automotive LIMIT 1000) t1 CROSS JOIN (SELECT * FROM automotive limit 1000) t2
WHERE t1.id != t2.id AND t1.summary != t2.summary
ORDER BY q_gram_dist DESC;






delete from automotive where product_id = '0000000000'


select * from ts_lexize('english_stem', 'pleasant');



drop text search dictionary li51404Syn cascade;



drop text search configuration li51404;



