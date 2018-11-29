-----------------	BDD - Illustrative examples	 	-----------------
----------- version 31 mars 2013, mise à jour le 09 février 2015 ----------------

-----------------------------------------------------------------------------
-- Clear previous information.
-----------------------------------------------------------------------------




-----------------------------------------------------------------------------
-- Initialize the structure.
-----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;
CREATE TABLE ATH (
id_licence VARCHAR(10) NOT NULL,
nom VARCHAR(10) NOT NULL,
prenom VARCHAR(1000),
date_naissance DATE,
adhesion DATE,
mail VARCHAR(100),
num_tel VARCHAR(100),
fin_validite DATE,
PRIMARY KEY (id_licence)
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
INSERT INTO ATH VALUES ('12740', 'Jean', 'Dupont','1996/05/25','2000/02/05','toto@gmail.com','0669696969','2019/06/01');
INSERT INTO ATH VALUES ('12820', 'Kevin', 'Durant','1996/05/25','2000/03/05','titi@gmail.com','0669696969','2019/06/01');


-----------------------------------------------------------------------------
-- Views & Functions.
-------------------------------------------------------
CREATE VIEW ATH_Atribute AS
	SELECT ATH.Id_licence AS ATH_id, ATH.Nom as ATH_Nom, ATH.Prenom AS ATH_prenom, ATH.date_naissance AS ATH_naissance, ATH.adhesion AS ATH_adhesion, ATH.mail AS ATH_mail, ATH.num_tel AS ATH_num, ATH.fin_validite AS ATH_validite
	FROM ATH
END;

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
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ATH TO reponsable;

/*CREATE OR REPLACE FUNCTION ATH_Update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $function$
   BEGIN
      INSERT INTO ATH VALUES(NEW.COURSE_code,NEW.COURSE_name);
      RETURN NEW;
    END;
$function$;
*/

-- Exercices : connectez-vous avec les trois utilisateurs et constater par vous-même les droits de chacun.
