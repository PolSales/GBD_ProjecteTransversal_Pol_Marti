DROP DATABASE IF EXISTS practiques;
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
    nass varchar(12) UNIQUE,
    ipo boolean,
    troncals boolean,
    observacions varchar(50),
    cicle int,

    CONSTRAINT alumne_idalu_pk PRIMARY KEY (idalu),
    CONSTRAINT alumne_id_cicle_fkey FOREIGN KEY (cicle) REFERENCES cicle(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE avaluacio (
    id int,
    data date NOT NULL,
    p_global int NOT NULL CHECK (p_global BETWEEN 0 AND 10),
    observacions varchar(50),
    idalu int,

    CONSTRAINT avaluacio_id_pk PRIMARY KEY (id),
    CONSTRAINT avaluacio_idalu_fkey FOREIGN KEY (idalu) REFERENCES alumne(idalu) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE criteri (
    id int, 
    descrip varchar(20) NOT NULL UNIQUE,

    CONSTRAINT criteri_id_pk PRIMARY KEY (id)
);

CREATE TABLE segueix (
    avaluacio int,
    criteri int,
    nota int NOT NULL CHECK (nota BETWEEN 0 AND 10),

    CONSTRAINT segueix_pk PRIMARY KEY (avaluacio, criteri),
    CONSTRAINT segueix_avaluacio_fkey FOREIGN KEY (avaluacio) REFERENCES avaluacio(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT segueix_criteri_fkey FOREIGN KEY (criteri) REFERENCES criteri(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE empresa (
    cif varchar(9),
    nom varchar(15) NOT NULL,
    sector varchar(20) NOT NULL,
    ubicacio varchar(30) NOT NULL,
    contacte varchar(25),

    CONSTRAINT empresa_cif_pk PRIMARY KEY (cif)
);

CREATE TABLE tutor (
    id int,
    nom varchar(20) NOT NULL,
    contacte varchar(30),
    empresa varchar(9) NOT NULL,

    CONSTRAINT tutor_pk PRIMARY KEY (id, empresa),
    CONSTRAINT tutor_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE assignacio (
    alumne int,
    empresa varchar(9),
    inici date NOT NULL,
    fi date,
    estat varchar(11) NOT NULL CHECK (estat IN ('proposada', 'confirmada', 'finalitzada', 'cancelada')),
    tutor int,

    CONSTRAINT assignacio_pk PRIMARY KEY (alumne, empresa),
    CONSTRAINT assignacio_alumne_fkey FOREIGN KEY (alumne) REFERENCES alumne(idalu) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT assignacio_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT assignacio_tutor_fkey FOREIGN KEY (tutor, empresa) REFERENCES tutor(id, empresa) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT assignacio_dates_chk CHECK (fi IS NULL OR fi >= inici)
);

CREATE TABLE tecnologia (
    id int,
    descrip varchar(20) NOT NULL UNIQUE,

    CONSTRAINT tecnologia_id_pk PRIMARY KEY (id)
);

CREATE TABLE domina (
    alumne int,
    tecnologia int,

    CONSTRAINT domina_pk PRIMARY KEY (alumne, tecnologia),
    CONSTRAINT domina_alumne_fkey FOREIGN KEY (alumne) REFERENCES alumne(idalu) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT domina_tecnologia_fkey FOREIGN KEY (tecnologia) REFERENCES tecnologia(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE preferencia (
    empresa varchar(9), 
    tecnologia int,

    CONSTRAINT preferencia_pk PRIMARY KEY (empresa, tecnologia),
    CONSTRAINT preferencia_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT preferencia_tecnologia_fkey FOREIGN KEY (tecnologia) REFERENCES tecnologia(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE dual (
    id int,
    tipus varchar(10) NOT NULL UNIQUE,

    CONSTRAINT dual_id_pk PRIMARY KEY (id)
);

CREATE TABLE interes (
    empresa varchar(9),
    dual int,

    CONSTRAINT interes_pk PRIMARY KEY (empresa, dual),
    CONSTRAINT interes_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT interes_dual_fkey FOREIGN KEY (dual) REFERENCES dual(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE cv (
    id int,
    creacio date NOT NULL,
    actualitzacio date,
    resum varchar(30) NOT NULL,
    enllaç varchar(30) NOT NULL UNIQUE,
    estat varchar(7) NOT NULL CHECK (estat IN ('actiu', 'obsolet')),
    propietari int,

    CONSTRAINT cv_id_pk PRIMARY KEY (id),
    CONSTRAINT cv_propietari_fkey FOREIGN KEY (propietari) REFERENCES alumne(idalu) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT cv_dates_chk CHECK (actualitzacio IS NULL OR actualitzacio >= creacio)
);

CREATE TABLE enviament (
    cv int,
    empresa varchar(9),
    estat varchar(10) NOT NULL CHECK (estat IN ('enviat', 'vist', 'entrevista', 'rebutjat', 'acceptat')),
    notes varchar(25),
    enviament date NOT NULL,
    resposta date,
    entrevista date,

    CONSTRAINT enviament_pk PRIMARY KEY (cv, empresa),
    CONSTRAINT enviament_cv_fkey FOREIGN KEY (cv) REFERENCES cv(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT enviament_empresa_fkey FOREIGN KEY (empresa) REFERENCES empresa(cif) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT enviament_resposta_chk CHECK (resposta IS NULL OR resposta >= enviament),
    CONSTRAINT enviament_entrevista_chk CHECK (entrevista IS NULL OR entrevista >= enviament)
);
