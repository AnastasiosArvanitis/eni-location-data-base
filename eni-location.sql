CREATE TABLE clients (
    nocli NUMERIC(6) NOT NULL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    adresse VARCHAR(120),
    cpo CHAR(5) NOT NULL 
    CONSTRAINT check_cpo CHECK (cpo > 01000 AND cpo < 95999),
    ville VARCHAR(80) NOT NULL DEFAULT 'Nantes'
);

CREATE TABLE gammes (
    codeGam CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE categories (
    codeCate CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE tarifs (
    codeTarif CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE,
    prixJour NUMERIC(5,2) NOT NULL
    CONSTRAINT check_prixJour CHECK (prixJour >= 0)
);

CREATE TABLE grilletarifs (
    codeGam CHAR(5) NOT NULL FOREIGN KEY REFERENCES gammes(codeGam),
    codeCate CHAR(5) NOT NULL FOREIGN KEY REFERENCES categories(codeCate),
    codeTarif CHAR(5) NOT NULL FOREIGN KEY REFERENCES tarifs(codeTarif)
    PRIMARY KEY(codeGam, codeCate)
);

CREATE TABLE fiches (
    noFic NUMERIC(6) NOT NULL PRIMARY KEY,
    nocli NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES clients(noCli)
        ON DELETE CASCADE,
    dateCrea DATE NOT NULL,
    datePaye DATE CONSTRAINT check_datePaye CHECK (datePaye > dateCrea),
    etat CHAR(2) NOT NULL CONSTRAINT check_etat 
    CHECK (etat LIKE 'EC' OR etat LIKE 'RE' OR etat LIKE 'SO') 
    DEFAULT 'EC'
);

CREATE TABLE articles (
    refart CHAR(8) NOT NULL PRIMARY KEY,
    designation VARCHAR(80) NOT NULL,
     codeGam CHAR(5) NOT NULL,
    codeCate CHAR(5) NOT NULL
    CONSTRAINT fk_articles_grilleTarifs FOREIGN KEY (codeGam, codeCate)
								REFERENCES grilleTarifs(codeGam, codeCate)
);

CREATE TABLE lignesfic (
    noLig NUMERIC(3) NOT NULL,
    noFic NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES fiches(noFic)
        ON DELETE CASCADE,
    refart CHAR(8) NOT NULL FOREIGN KEY REFERENCES articles(refart),
    depart DATE NOT NULL DEFAULT GETDATE(),
    retour DATE  CONSTRAINT retour CHECK (retour > depart)
    CONSTRAINT pk_lignesfic_fiches PRIMARY KEY(noLig, noFic)
);