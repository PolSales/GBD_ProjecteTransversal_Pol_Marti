CREATE DATABASE practiques;
\c practiques;

CREATE TABLE cicle (
    id int,
    nom varchar(10) UNIQUE NOT NULL,

    CONSTRAINT cicle_id_pk PRIMARY KEY (id)
);

CREATE TABLE alumne (
    idalu int,
    nom varchar(12) NOT NULL,
    cognom varchar (20) NOT NULL,
    contacte varchar(25),
    promocio varchar(10),
    curs varchar(5),
    estat varchar(5) NOT NULL CHECK(estat IN ('actiu', 'baixa')),
    nass varchar(12) UNIQUE NOT NULL,
    ipo boolean,
    troncals boolean,
    observacions varchar(50),
    cicle int,

    CONSTRAINT alumne_idalu_pk PRIMARY KEY (idalu),
    CONSTRAINT alumne_id_cicle_fkey FOREIGN KEY (cicle) REFERENCES cicle(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE avaluacio (
    id int,
    data date,
    p_global int,
    observacions varchar(50),
    idalu int,

    CONSTRAINT avaluacio_id_pk PRIMARY KEY (id),
    CONSTRAINT avaluacio_idalu_fkey FOREIGN KEY (idalu) REFERENCES alumne(idalu)
);

CREATE TABLE criteri (
    id int, 
    descrip varchar(20),

    CONSTRAINT criteri_id_pk PRIMARY KEY (id)
);

CREATE TABLE segueix (
    avaluacio int,
    criteri int,
    nota int,

    CONSTRAINT segueix_pk PRIMARY KEY (avaluacio, criteri),
    CONSTRAINT segueix_avaluacio_fkey FOREIGN KEY (avaluacio) REFERENCES avaluacio(id),
    CONSTRAINT segueix_criteri_fkey FOREIGN KEY (criteri) REFERENCES criteri(id)
);

CREATE TABLE empresa (
    cif int,
    nom varchar(10),
    sector varchar(20),
    ubicacio varchar(30),
    contacte varchar(25),

    CONSTRAINT empresa_cif_pk PRIMARY KEY (cif)
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

CREATE TABLE tecnologia (
    id int,
    descrip varchar(20),

    CONSTRAINT tecnologia_id_pk PRIMARY KEY (id)
);

CREATE TABLE domina (
    alumne int,
    tecnologia int,

    CONSTRAINT domina_pk PRIMARY KEY (alumne, tecnologia),
    CONSTRAINT domina_alumne_fkey FOREIGN KEY (alumne) REFERENCES alumne(idalu),
    CONSTRAINT domina_tecnologia_fkey FOREIGN KEY (tecnologia) REFERENCES tecnologia(id)
);

CREATE TABLE preferencia (
    empresa int, 
    tecnologia int,

    CONSTRAINT preferencia_pk PRIMARY KEY (empresa, tecnologia),
    CONSTRAINT preferencia_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif),
    CONSTRAINT preferencia_tecnologia_fkey FOREIGN KEY (tecnologia) REFERENCES tecnologia(id)
);

CREATE TABLE dual (
    id int,
    tipus varchar(10),

    CONSTRAINT dual_id_pk PRIMARY KEY (id)
);

CREATE TABLE interes (
    empresa int,
    dual int,

    CONSTRAINT interes_pk PRIMARY KEY (empresa, dual),
    CONSTRAINT interes_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif),
    CONSTRAINT interes_dual_fkey FOREIGN KEY (dual) REFERENCES dual(id)
);

CREATE TABLE cv (
    id int,
    creacio date,
    actualitzacio date,
    resum varchar(30),
    enllaç varchar(30),
    estat varchar(7),
    propietari int,

    CONSTRAINT cv_id_pk PRIMARY KEY (id),
    CONSTRAINT cv_propietari_fkey FOREIGN KEY (propietari) REFERENCES alumne(idalu)
);

CREATE TABLE enviament (
    cv int,
    empresa int,
    estat varchar(10),
    notes varchar(25),
    enviament date,
    resposta date,
    entrevista date,

    CONSTRAINT enviament_pk PRIMARY KEY (cv, empresa),
    CONSTRAINT enviament_cv_fkey FOREIGN KEY (cv) REFERENCES cv(id),
    CONSTRAINT enviament_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif)
);