
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

CREATE TABLE ENTRAINEUR (
id_entraineur INTEGER NOT NULL,
nom VARCHAR(20),
prenom VARCHAR(20),
date_naissance DATE,
adhesion DATE,
mail VARCHAR(20),
num_tel VARCHAR(20),
PRIMARY KEY (id_entraineur)
);

CREATE TABLE BUDGET (
cout INTEGER NOT NULL,
budget_ath INTEGER NOT NULL,
budget_rest INTEGER, 
annee INTEGER,
PRIMARY KEY (annee)
);

CREATE TABLE ENTRAINEMENT ( 
id_entrainement INTEGER NOT NULL,
type_entrainement VARCHAR(20),
jour VARCHAR(10),
h_debut TIME,
h_fin TIME,
PRIMARY KEY (id_entrainement),
id_entraineur INTEGER REFERENCES ENTRAINEUR(id_entraineur)
);

CREATE TABLE SALLE (
id_salle INTEGER NOT NULL,
adresse  VARCHAR(30),
PRIMARY KEY (id_salle),
id_entraineur INTEGER REFERENCES ENTRAINEUR(id_entraineur)
);

CREATE TABLE MATERIEL (
id_materiel INTEGER NOT NULL,
etat VARCHAR(10),
PRIMARY KEY(id_materiel),
id_salle INTEGER REFERENCES SALLE(id_salle)
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

CREATE OR REPLACE FUNCTION calcul_budget_rest() 
    RETURNS VOID
    LANGUAGE plpgsql AS $$
DECLARE 
    sum_rest INTEGER := '0';
    this_annee INTEGER := (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)));
BEGIN
    sum_rest = (SELECT DISTINCT BUDGET.budget_ath FROM BUDGET WHERE annee = this_annee) - (SELECT DISTINCT BUDGET.cout FROM BUDGET WHERE annee = this_annee);
    UPDATE BUDGET SET budget_rest = sum_rest WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)));
END;
$$;

CREATE OR REPLACE FUNCTION calcul_budget_ath() 
    RETURNS TRIGGER
    LANGUAGE plpgsql AS $$
DECLARE 
    sum_licence INTEGER := '0';
    calcul INTEGER; 
    ath_id_cat INTEGER;
BEGIN
    FOR calcul,ath_id_cat IN SELECT DISTINCT count(ath.id_cat),ath.id_cat FROM ath GROUP BY ath.id_cat 
    LOOP
        sum_licence = sum_licence + calcul * (SELECT cout FROM categorie where categorie.id_cat = ath_id_cat);
    END LOOP;
    IF EXISTS (SELECT * FROM BUDGET WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)))) THEN
        UPDATE BUDGET SET budget_ath = sum_licence WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)));
    ELSE 
        INSERT INTO BUDGET VALUES('0',(sum_licence),'0',(SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP))));
    END IF;
    PERFORM(SELECT calcul_budget_rest());
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION calcul_cout_entraineur() 
    RETURNS TRIGGER
    LANGUAGE plpgsql AS $$
DECLARE 
    sum_cout INTEGER;
BEGIN
    /* total cout = count(entraineur) * 10euros/h * 6h /semaine * 10 nb mois */
    sum_cout = (SELECT count(ENTRAINEUR.id_entraineur) FROM ENTRAINEUR) * 10 * 6 *10;
    IF EXISTS (SELECT * FROM BUDGET WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)))) THEN
        UPDATE BUDGET SET cout = sum_cout WHERE annee = (SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP)));
    ELSE 
        INSERT INTO BUDGET VALUES((sum_cout),'0','0',(SELECT EXTRACT (YEAR FROM (SELECT CURRENT_TIMESTAMP))));
    END IF;
    PERFORM(SELECT calcul_budget_rest());
    RETURN NULL;
END;
$$;


CREATE TRIGGER new_calcul_rest
AFTER INSERT OR UPDATE
ON ATH 
FOR EACH row
EXECUTE PROCEDURE calcul_budget_ath();

CREATE TRIGGER new_cout
AFTER INSERT OR UPDATE
ON ENTRAINEUR 
FOR EACH row
EXECUTE PROCEDURE calcul_cout_entraineur();

--------------------------------------------- INSERT ATH ENTRAINEUR ------------------------------------------------------

INSERT INTO ATH VALUES('12740', 'Jean', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969','2019/06/01','1');
INSERT INTO ATH VALUES('12821', 'Kevin', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969','2019/06/01','3');
INSERT INTO ATH VALUES('12745', 'Jean', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969','2019/06/01','1');
INSERT INTO ATH VALUES('12826', 'Kevin', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969','2019/06/01','3');
INSERT INTO ATH VALUES('12748', 'Jean', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969','2019/06/01','2');
INSERT INTO ATH VALUES('12829', 'Kevin', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969','2019/06/01','1');
INSERT INTO ATH VALUES('12743', 'Jean', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969','2019/06/01','2');
INSERT INTO ATH VALUES('12824', 'Kevin', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969','2019/06/01','3');

INSERT INTO ENTRAINEUR VALUES('19751', 'LEMONS', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969');
INSERT INTO ENTRAINEUR VALUES('15792', 'TOTO', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969');
INSERT INTO ENTRAINEUR VALUES('15712', 'TATA', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969');

-----------------------------------------------------------------------------------------------------------------------------

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