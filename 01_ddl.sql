CREATE DATABASE practiques;
\c practiques;

CREATE TABLE alumne (
    idalu int,
    nom varchar(12),
    cognom varchar (20),
    contacte varchar(25),
    promocio varchar(10),
    curs varchar(5),
    estat varchar(5),
    cicle varchar(5),
    nass varchar(12),
    ipo boolean,
    troncals boolean,
    observacions varchar(50),

    CONSTRAINT alumne_idalu_pk PRIMARY KEY (idalu)
);

CREATE TABLE cv (
    id_cv int,
    creacio date,
    actualitzacio date,
    resum varchar(30),
    enllaç varchar(30),
    estat varchar(7),
    propietari int,

    CONSTRAINT cv_id_pk PRIMARY KEY (id_cv),
    CONSTRAINT cv_propietari_fkey FOREIGN KEY (propietari) REFERENCES alumne(idalu)
);

CREATE TABLE avaluacio (
    id_avaluacio int,
    data date,
    p_global int,
    observacions varchar(50),
    idalu int,

    CONSTRAINT avaluacio_id_pk PRIMARY KEY (id_avaluacio),
    CONSTRAINT avaluacio_idalu_fkey FOREIGN KEY (idalu) REFERENCES alumne(idalu)
);

CREATE TABLE empresa (
    cif int,
    nom varchar(10),
    sector varchar(20),
    ubicacio varchar(30),
    contacte varchar(25),

    CONSTRAINT empresa_cif_pk PRIMARY KEY (cif)
);

CREATE TABLE enviament (
    cv int, 
    empresa int,
    data date,
    estat varchar(10),
    notes varchar(25),

    CONSTRAINT enviament_pk PRIMARY KEY (cv, empresa),
    CONSTRAINT enviament_cv_fkey FOREIGN KEY (cv) REFERENCES cv(id_cv),
    CONSTRAINT enviament_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif)
);

CREATE TABLE assignacio (
    alumne int,
    empresa int, 
    inici date,
    fi date,
    estat varchar(10),

    CONSTRAINT assignacio_pk PRIMARY KEY (alumne, empresa),
    CONSTRAINT assignacio_alumne_fkey FOREIGN KEY (alumne) REFERENCES alumne(idalu),
    CONSTRAINT assignacio_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif)
);
