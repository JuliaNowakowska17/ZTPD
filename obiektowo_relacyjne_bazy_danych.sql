--ZADANIE 1
CREATE TYPE samochod AS OBJECT (
marka VARCHAR2(20),
model VARCHAR2(20),
kilometry NUMBER,
data_produkcji DATE,
cena NUMBER(10,2)
);
/

CREATE TABLE samochody OF samochod;

INSERT INTO samochody VALUES(
samochod('FIAT', 'BRAVA', 60000, DATE '1999-11-30', 25000)
);

INSERT INTO samochody VALUES(
samochod('FORD', 'MONDEO', 80000, DATE '1997-05-10', 45000)
);

INSERT INTO samochody VALUES(
samochod('MAZDA', '323', 12000, DATE '2000-09-22', 52000)
);

COMMIT;

DESC samochody;

SELECT * FROM samochody;

--ZADANIE 2
ALTER TYPE samochod
ADD MEMBER FUNCTION wartosc RETURN NUMBER
CASCADE;
/

CREATE OR REPLACE TYPE BODY samochod AS
MEMBER FUNCTION wartosc RETURN NUMBER IS 
wiek NUMBER;
BEGIN
wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, SELF.data_produkcji)/12);
RETURN ROUND(SELF.cena*POWER(0.9, GREATEST(wiek,0)),2);
END wartosc;
END;
/

SELECT s.marka, s.cena, s.wartosc()
FROM samochody s;

--ZADANIE 3
ALTER TYPE samochod
ADD MAP MEMBER FUNCTION porownaj RETURN NUMBER
CASCADE;
/


CREATE OR REPLACE TYPE BODY samochod AS

MEMBER FUNCTION wartosc RETURN NUMBER IS 
wiek NUMBER;
BEGIN
wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, SELF.data_produkcji)/12);
RETURN ROUND(SELF.cena*POWER(0.9, GREATEST(wiek,0)),2);
END wartosc;

MAP MEMBER FUNCTION porownaj RETURN NUMBER IS
wiek NUMBER;
BEGIN
wiek := TRUNC(MONTHS_BETWEEN(SYSDATE, SELF.data_produkcji)/12);
RETURN wiek + SELF.kilometry/10000;
END porownaj;

END;
/

SELECT * FROM samochody s ORDER BY VALUE(s);

--ZADANIE 4
CREATE TABLE wlasciciele(
imie VARCHAR2(100),
nazwisko VARCHAR2(100),
auto samochod
);

INSERT INTO wlasciciele VALUES ('JAN', 'KOWALSKI', samochod('FIAT', 'SEICENTO', 30000, DATE '2010-12-02', 19500));

INSERT INTO wlasciciele VALUES ('ADAM', 'NOWAK', samochod('OPEL', 'ASTRA', 34000, DATE '2009-06-01', 33700));

COMMIT;

DESC wlasciciele;

SELECT * FROM wlasciciele;

--ZADANIE 5
DROP TABLE wlasciciele;

--ZADANIE 6
CREATE TYPE wlasciciel AS OBJECT(
imie VARCHAR2(100),
nazwisko VARCHAR2(100)
);
/

CREATE TABLE wlasciciele OF wlasciciel;

INSERT INTO wlasciciele VALUES (wlasciciel('JAN', 'KOWALSKI'));

INSERT INTO wlasciciele VALUES (wlasciciel('ADAM', 'NOWAK'));

COMMIT;

DESC wlasciciele;

SELECT * FROM wlasciciele;

--ZADANIE 7
ALTER TYPE samochod
ADD ATTRIBUTE (ref_wlasciciel REF wlasciciel)
CASCADE;

DESC samochod;

--ZADANIE 8
DELETE FROM samochody;

COMMIT;

SELECT * FROM samochody;

--ZADANIE 9
ALTER TABLE samochody
ADD (SCOPE FOR(ref_wlasciciel) IS wlasciciele);

--ZADANIE 10
INSERT INTO samochody VALUES(
samochod('FIAT', 'BRAVA', 60000, DATE '1999-11-30', 25000,
(SELECT REF(w) FROM wlasciciele w WHERE w.imie='JAN' AND w.nazwisko='KOWALSKI'))
);

INSERT INTO samochody VALUES(
samochod('FORD', 'MONDEO', 80000, DATE '1997-05-10', 45000,
(SELECT REF(w) FROM wlasciciele w WHERE w.imie='ADAM' AND w.nazwisko='NOWAK'))
);

INSERT INTO samochody VALUES(
samochod('MAZDA', '323', 12000, DATE '2000-09-22', 52000,
(SELECT REF(w) FROM wlasciciele w WHERE w.imie='JAN' AND w.nazwisko='KOWALSKI'))
);

SELECT s.marka, s.model, s.kilometry, s.ref_wlasciciel.imie AS imie_wlasciciela, s.ref_wlasciciel.nazwisko AS nazwisko_wlasciciela
FROM samochody s;

--ZADANIE 11
SET SERVEROUTPUT ON;

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;

 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 
 moje_przedmioty.TRIM(2);
 
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 
 moje_przedmioty.EXTEND();
 
 moje_przedmioty(9) := 9;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 
 moje_przedmioty.DELETE();
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--ZADANIE 12
SET SERVEROUTPUT ON;

DECLARE
 TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
 moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
 moje_ksiazki(1) := 'LALKA';
 moje_ksiazki.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_ksiazki(i) := 'KSIAZKA_' || i;
 END LOOP;

 FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
 END LOOP;
 
 moje_ksiazki.TRIM(5);
 
 FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
 
 moje_ksiazki.EXTEND();
 
 moje_ksiazki(6) := 'ZBRODNIA I KARA';
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
 
 moje_ksiazki.DELETE();
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

--ZADANIE 13
SET SERVEROUTPUT ON;

DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
 
BEGIN
 moi_wykladowcy.EXTEND(2);
 
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 
 moi_wykladowcy.EXTEND(8);
 
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--ZADANIE 14
SET SERVEROUTPUT ON;

DECLARE
 TYPE t_miesiace IS TABLE OF VARCHAR2(20);
 moje_miesiace t_miesiace := t_miesiace();
 
BEGIN
 moje_miesiace.EXTEND(12);
 
 moje_miesiace(1) := 'STYCZEN';
 moje_miesiace(2) := 'LUTY';
 moje_miesiace(3) := 'MARZEC';
 moje_miesiace(4) := 'KWIECIEN';
 moje_miesiace(5) := 'MAJ';
 moje_miesiace(6) := 'CZERWIEC';
 moje_miesiace(7) := 'LIPIEC';
 moje_miesiace(8) := 'SIERPIEN';
 moje_miesiace(9) := 'WRZESIEN';
 moje_miesiace(10) := 'PAZDZIERNIK';
 moje_miesiace(11) := 'LISTOPAD';
 moje_miesiace(12) := 'GRUDZIEN';

 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END LOOP;
 
 moje_miesiace.TRIM(4);
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END LOOP;
 
 moje_miesiace.DELETE(3,5);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
 
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 IF moje_miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END IF;
 END LOOP;
 
 moje_miesiace(3) := 'MARCH';
 moje_miesiace(4) := 'APRIL';
 moje_miesiace(5) := 'MAY';
 
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 IF moje_miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END IF;
 END LOOP;
 
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
END;

--ZADANIE 15
SET SERVEROUTPUT ON;

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));

SELECT * FROM stypendia;

SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/

CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));


SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;


SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--ZADANIE 16
CREATE TYPE koszyk_produktow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE zakup AS OBJECT (
 numer NUMBER,
 produkty koszyk_produktow );
/

CREATE TABLE zakupy OF zakup
NESTED TABLE produkty STORE AS tab_produkty;

INSERT INTO zakupy VALUES
(zakup(1,koszyk_produktow('MASLO','MLEKO','CHLEB')));
INSERT INTO zakupy VALUES
(zakup(2,koszyk_produktow('MLEKO','SER')));
INSERT INTO zakupy VALUES
(zakup(3,koszyk_produktow('SER','CHLEB','BANAN')));
INSERT INTO zakupy VALUES
(zakup(4,koszyk_produktow('BANAN','MLEKO','MASLO')));

SELECT * FROM zakupy;

SELECT p.*
FROM zakupy z, TABLE ( z.produkty ) p;

DELETE FROM zakupy z WHERE EXISTS ( SELECT 1 FROM TABLE (z.produkty) p WHERE p.COLUMN_VALUE = 'CHLEB' );

SELECT * FROM zakupy;

--ZADANIE 17
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
/
 
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/

CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
/
 
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/

CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
/

CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/

DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

--ZADANIE 18
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
/

CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
/

CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;


DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

--ZADANIE 19
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

--ZADANIE 20
CREATE TABLE instrumenty OF instrument;
/

INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa') );
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );

SELECT i.nazwa, i.graj() FROM instrumenty i;
