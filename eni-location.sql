CREATE TABLE clients (
    nocli NUMERIC(6) NOT NULL PRIMARY KEY,
    nom VARCHAR(30),
    prenom VARCHAR(30),
    adresse VARCHAR(120),
    cpo CHAR(5),
    ville VARCHAR(80)
);

CREATE TABLE gammes (
    codeGam CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30)
);

CREATE TABLE categories (
    codeCate CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30)
);

CREATE TABLE tarifs (
    codeTarif CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30),
    prixJour NUMERIC(5,2) 
);

CREATE TABLE grilletarifs (
    codeGam CHAR(5) NOT NULL FOREIGN KEY REFERENCES gammes(codeGam),
    codeCate CHAR(5) NOT NULL FOREIGN KEY REFERENCES categories(codeCate),
    codeTarif CHAR(5) NOT NULL FOREIGN KEY REFERENCES tarifs(codeTarif)
    PRIMARY KEY(codeGam, codeCate)
);

CREATE TABLE fiches (
    noFic NUMERIC(6) NOT NULL PRIMARY KEY,
    nocli NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES clients(noCli),
    dateCrea DATE,
    datePaye DATE,
    etat CHAR(2) 
);

CREATE TABLE articles (
    refart CHAR(8) NOT NULL PRIMARY KEY,
    designation VARCHAR(80),
     codeGam CHAR(5) NOT NULL,
    codeCate CHAR(5) NOT NULL
    CONSTRAINT fk_articles_grilleTarifs FOREIGN KEY (codeGam, codeCate)
								REFERENCES grilleTarifs(codeGam, codeCate)
);

CREATE TABLE lignesfic (
    noLig NUMERIC(3) NOT NULL,
    noFic NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES fiches(noFic),
    refart CHAR(8) NOT NULL FOREIGN KEY REFERENCES articles(refart),
    depart DATE,
    retour DATE
    CONSTRAINT pk_lignesfic_fiches PRIMARY KEY(noLig, noFic)
);