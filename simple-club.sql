
CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;

CREATE TABLE CATEGORIE (
id_cat SMALLINT NOT NULL,
cat VARCHAR(10) NOT NULL,
cout INTEGER NOT NULL,
PRIMARY KEY (id_cat)
);

CREATE TABLE ATH (
id_licence INTEGER NOT NULL,
nom VARCHAR(10) NOT NULL,
prenom VARCHAR(1000),
date_naissance DATE,
adhesion DATE,
mail VARCHAR(100),
num_tel VARCHAR(100),
fin_validite DATE,
id_cat SMALLINT REFERENCES CATEGORIE(id_cat),
PRIMARY KEY (id_licence)
);

CREATE TABLE BUDGET (
cout INTEGER NOT NULL,
budget INTEGER NOT NULL,
annee INTEGER,
PRIMARY key (annee)
);

-----------------------------------------------------------------------------
-- Defining roles.
-----------------------------------------------------------------------------
CREATE ROLE athle;
CREATE ROLE trainer;
CREATE ROLE responsable;

CREATE ROLE "jean.dupont" LOGIN IN GROUP trainer;
	ALTER ROLE "jean.dupont" ENCRYPTED PASSWORD 'trainer';
CREATE ROLE "kevin.durant" LOGIN IN GROUP athle;
	ALTER ROLE "kevin.durant" ENCRYPTED PASSWORD 'athle';
CREATE ROLE "justine.clavier" LOGIN IN GROUP responsable;
	ALTER ROLE "justine.clavier" ENCRYPTED PASSWORD 'reponsable';



-----------------------------------------------------------------------------
-- Insert some data.
-----------------------------------------------------------------------------
INSERT INTO CATEGORIE VALUES('1', 'bejamin','50');
INSERT INTO CATEGORIE VALUES('2', 'minime', '60');
INSERT INTO CATEGORIE VALUES('3', 'cadet', '100');



-----------------------------------------------------------------------------
-- Views & Functions.
-------------------------------------------------------

CREATE OR REPLACE FUNCTION calcul_budget_ath() 
    RETURNS TRIGGER
    LANGUAGE plpgsql AS $$
DECLARE 
    sum_licence INTEGER := '0';
    calcul INTEGER; 
    ath_id_cat INTEGER;
BEGIN
    FOR calcul,ath_id_cat IN SELECT DISTINCT count(ath.id_cat),ath.id_cat AS count_id FROM ath GROUP BY ath.id_cat 
    LOOP
        sum_licence = sum_licence + calcul * (SELECT cout FROM categorie where categorie.id_cat = ath_id_cat);
    END LOOP;
    IF EXISTS (SELECT * FROM BUDGET WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)))) THEN
        UPDATE BUDGET SET cout ='0',budget = sum_licence WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)));
    ELSE 
        INSERT INTO BUDGET VALUES('0',(sum_licence),(SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP))));
    END IF;
    RETURN NULL;
END;
$$;

CREATE TRIGGER new_calcul
AFTER INSERT OR UPDATE
ON ath 
FOR EACH row
EXECUTE PROCEDURE calcul_budget_ath();

INSERT INTO ATH VALUES ('12740', 'Jean', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969','2019/06/01','1');
INSERT INTO ATH VALUES ('12820', 'Kevin', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969','2019/06/01','3');

CREATE OR REPLACE FUNCTION curr_roles() RETURNS SETOF TEXT
    LANGUAGE plpgsql AS $$
DECLARE
	role text := '';
BEGIN
	FOR role IN SELECT DISTINCT (CAST(role_name AS VARCHAR)) FROM information_schema.applicable_roles LOOP
		RETURN NEXT role;
	END LOOP;
END;
$$;

-----------------------------------------------------------------------------
-- Permissions.
-----------------------------------------------------------------------------
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ATH TO trainer;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ATH TO athle;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ATH TO responsable;