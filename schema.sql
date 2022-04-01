/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
  id INT GENERATED BY DEFAULT AS IDENTITY,
  name varchar(40),
  date_of_birth date,
  escape_attemps INT NOT NULL,
  neutered boolean,
  weight_kg decimal(5, 2)
);

ALTER TABLE animals ADD species varchar(255);

/*------- CREATE THE 'owners' TABLE  -------*/
CREATE TABLE owners(
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name varchar(255),
  age INT NOT NULL,
  PRIMARY KEY(id)
);

/*------- CREATE THE 'species' TABLE  -------*/
CREATE TABLE species(
  id INT GENERATED ALWAYS AS IDENTITY,
  name varchar(255),
  PRIMARY KEY(id)
);

/* Set the id as autoincremented and as PRIMARY KEY */
ALTER TABLE animals ALTER COLUMN id  DROP IDENTITY IF EXISTS; /* Remove the default identity generator */
ALTER TABLE animals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY; /* Add always identity generator */
ALTER TABLE animals ADD PRIMARY KEY (id); /* Set id as PRIMARY KEY */

/* Remove the 'species' column */
ALTER TABLE animals DROP species;

/*--- Add new columns ----*/
BEGIN;

ALTER TABLE 
  animals
ADD
  species_id INTEGER;

ALTER TABLE 
  animals
ADD
  owner_id INTEGER;

/*--- Add FOREIGN KEYS ----*/
ALTER TABLE
  animals
ADD CONSTRAINT
  fk_owner
FOREIGN KEY(owner_id)
REFERENCES
  owners(id);

ALTER TABLE
  animals
ADD CONSTRAINT
  fk_species
FOREIGN KEY(species_id)
REFERENCES
  owners(id);

COMMIT;

/*------- CREATE THE 'vets' TABLE  -------*/
CREATE TABLE vets(
  id INT GENERATED BY DEFAULT AS IDENTITY,
  name varchar(100),
  age INTEGER,
  date_of_graduation date,
  PRIMARY KEY(id)
);

/*------- CREATE THE 'specializations' TABLE  -------*/
CREATE TABLE specializations (
  vets_id INT NOT NULL,
  species_id INT NOT NULL,
  FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  PRIMARY KEY (vets_id, species_id)
);

/*------- CREATE THE 'visits' TABLE  -------*/
CREATE TABLE visits(
  animals_id INT NOT NULL,
  vets_id INT NOT NULL,
  date_of_visit DATE NOT NULL,
  FOREIGN KEY (animals_id) REFERENCES animals (id) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE RESTRICT ON UPDATE CASCADE,
	PRIMARY KEY (animals_id, vets_id)
);
