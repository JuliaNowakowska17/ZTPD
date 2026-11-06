-- ZADANIE 1

CREATE TABLE movies AS
SELECT *
FROM ZTPD.MOVIES;

-- ZADANIE 2
DESC movies;

SELECT * FROM movies;

-- ZADANIE 3
SELECT id, title FROM movies WHERE cover IS NULL;

-- ZADANIE 4
SELECT id, title, DBMS_LOB.GETLENGTH(cover) AS filesize
FROM movies WHERE cover IS NOT NULL;

-- ZADANIE 5
SELECT id, title, DBMS_LOB.GETLENGTH(cover) AS filesize
FROM movies WHERE cover IS NULL;

-- ZADANIE 6
SELECT directory_name, directory_path
FROM all_directories
WHERE directory_name = 'TPD_DIR';

-- ZADANIE 7
UPDATE movies
SET cover = EMPTY_BLOB(), MIME_TYPE = 'image/jpeg'
WHERE id = 66;

COMMIT;

-- ZADANIE 8
SELECT id, title, DBMS_LOB.GETLENGTH(cover) AS filesize
FROM movies
WHERE id IN (65, 66);

-- ZADANIE 9
SET SERVEROUTPUT ON;

DECLARE
    plik BFILE;
    obrazek BLOB;
BEGIN
    plik := BFILENAME('TPD_DIR', 'escape.jpg');

    SELECT cover
    INTO obrazek
    FROM movies
    WHERE id = 66
    FOR UPDATE;

    DBMS_LOB.FILEOPEN(plik, DBMS_LOB.FILE_READONLY);

    DBMS_LOB.LOADFROMFILE(
        obrazek,
        plik,
        DBMS_LOB.GETLENGTH(plik)
    );

    DBMS_LOB.FILECLOSE(plik);

    COMMIT;
END;
/

-- ZADANIE 10
CREATE TABLE temp_covers (
movie_id NUMBER(12),
image BFILE,
mime_type VARCHAR2(50)
);

-- ZADANIE 11
INSERT INTO temp_covers VALUES (65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');

COMMIT;

-- ZADANIE 12
SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS filesize
FROM temp_covers
WHERE movie_id = 65;

-- ZADANIE 13
SET SERVEROUTPUT ON;

DECLARE
    plik BFILE;
    typ_mime VARCHAR2(50);
    obrazek BLOB;
BEGIN
    SELECT image, mime_type
    INTO plik, typ_mime
    FROM temp_covers
    WHERE movie_id = 65;
    
    DBMS_LOB.CREATETEMPORARY(obrazek, TRUE);

    DBMS_LOB.FILEOPEN(plik, DBMS_LOB.FILE_READONLY);

    DBMS_LOB.LOADFROMFILE(
        obrazek,
        plik,
        DBMS_LOB.GETLENGTH(plik)
    );

    DBMS_LOB.FILECLOSE(plik);
    
    UPDATE movies
    SET cover = obrazek, mime_type = typ_mime
    WHERE id = 65;
    
    DBMS_LOB.FREETEMPORARY(obrazek);

    COMMIT;
END;
/

-- ZADANIE  14
SELECT id AS movie_id, DBMS_LOB.GETLENGTH(cover) AS filesize
FROM movies
WHERE id IN (65, 66);

-- ZADANIE 15
DROP TABLE movies;

-- ZADANIE 16
CREATE TABLE dokumenty (
id NUMBER(12) PRIMARY KEY,
dokument CLOB
);

-- ZADANIE 17
DECLARE
    tekst CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(tekst, TRUE);

    FOR i IN 1..10000 LOOP
    DBMS_LOB.WRITEAPPEND(
            tekst,
            LENGTH('Oto tekst. '),
            'Oto tekst. '
        );
    END LOOP;
    
    INSERT INTO dokumenty VALUES (1, tekst);
    
    DBMS_LOB.FREETEMPORARY(tekst);
    
    COMMIT;
END;
/

-- ZADANIE 18
SELECT * FROM dokumenty;

SELECT id, UPPER(dokument) FROM dokumenty;

SELECT id, LENGTH(dokument) FROM dokumenty;

SELECT id, DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

SELECT id, SUBSTR(dokument, 5, 1000) FROM dokumenty;

SELECT id, DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

-- ZADANIE 19
INSERT INTO dokumenty VALUES(2, EMPTY_CLOB());

-- ZADANIE 20
INSERT INTO dokumenty VALUES(3, NULL);

COMMIT;

-- ZADANIE 21
SELECT * FROM dokumenty;

SELECT id, UPPER(dokument) FROM dokumenty;

SELECT id, LENGTH(dokument) FROM dokumenty;

SELECT id, DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

SELECT id, SUBSTR(dokument, 5, 1000) FROM dokumenty;

SELECT id, DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

-- ZADANIE 22
SET SERVEROUTPUT ON;

DECLARE
    plik BFILE;
    tekst CLOB;

    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    lang_ctx INTEGER := 0;
    warn INTEGER;

BEGIN
    plik := BFILENAME('TPD_DIR', 'dokument.txt');

    SELECT dokument
    INTO tekst
    FROM dokumenty
    WHERE id = 2
    FOR UPDATE;

    DBMS_LOB.FILEOPEN(plik, DBMS_LOB.FILE_READONLY);

    DBMS_LOB.LOADCLOBFROMFILE(
        dest_lob     => tekst,
        src_bfile    => plik,
        amount       => DBMS_LOB.LOBMAXSIZE,
        dest_offset  => dest_offset,
        src_offset   => src_offset,
        bfile_csid   => 0,
        lang_context => lang_ctx,
        warning      => warn
    );

    DBMS_LOB.FILECLOSE(plik);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Status kopiowania: ' || warn);

END;
/

-- ZADANIE 23
UPDATE dokumenty
SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'),0)
WHERE id = 3;

COMMIT;

-- ZADANIE 24
SELECT * FROM dokumenty;

-- ZADANIE 25
SELECT id, DBMS_LOB.GETLENGTH(dokument) AS rozmiar
FROM dokumenty;

-- ZADANIE 26
DROP TABLE dokumenty;