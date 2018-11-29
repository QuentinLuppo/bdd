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
Id_licence VARCHAR(10) NOT NULL,
Nom VARCHAR(10) NOT NULL,
Prenom VARCHAR(1000),
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
INSERT INTO ATH VALUES ('12740', 'Jean', 'Dupont');
INSERT INTO ATH VALUES ('12820', 'Kevin', 'Durant');


-----------------------------------------------------------------------------
-- Views & Functions.
-------------------------------------------------------
CREATE VIEW ATH_Atribute AS
	SELECT ATH.Id_licence AS ATH_id, ATH.Nom as ATH_Nom, ATH.Prenom AS ATH_prenom
	FROM ATH

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
