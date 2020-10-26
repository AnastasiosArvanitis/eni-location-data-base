USE locations;
GO

CREATE TABLE clients (
    nocli NUMERIC(6) NOT NULL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    adresse VARCHAR(120),
    cpo CHAR(5) NOT NULL 
    CONSTRAINT check_cpo CHECK(convert(numeric(5),cpo) BETWEEN 1000 AND 95999),
    ville VARCHAR(80) NOT NULL DEFAULT 'Nantes'
);
GO

CREATE TABLE gammes (
    codeGam CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE categories (
    codeCate CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE
);
GO

CREATE TABLE tarifs (
    codeTarif CHAR(5) NOT NULL PRIMARY KEY,
    libelle VARCHAR(30) NOT NULL UNIQUE,
    prixJour NUMERIC(5,2) NOT NULL
    CONSTRAINT check_prixJour CHECK (prixJour >= 0)
);
GO

CREATE TABLE grilletarifs (
    codeGam CHAR(5) NOT NULL FOREIGN KEY REFERENCES gammes(codeGam),
    codeCate CHAR(5) NOT NULL FOREIGN KEY REFERENCES categories(codeCate),
    codeTarif CHAR(5) NOT NULL FOREIGN KEY REFERENCES tarifs(codeTarif)
    PRIMARY KEY(codeGam, codeCate)
);
GO

CREATE TABLE fiches (
    noFic NUMERIC(6) NOT NULL PRIMARY KEY,
    nocli NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES clients(noCli)
        ON DELETE CASCADE,
    dateCrea DATETIME NOT NULL DEFAULT GETDATE(),
    datePaye DATETIME,
    etat CHAR(2) NOT NULL DEFAULT 'EC'
        CONSTRAINT check_etat CHECK (etat IN ('EC', 'RE', 'SO')) 
);
GO

ALTER TABLE fiches
ADD CONSTRAINT check_datePaye CHECK (datePaye > dateCrea);
GO

CREATE TABLE articles (
    refart CHAR(8) NOT NULL PRIMARY KEY,
    designation VARCHAR(80) NOT NULL,
     codeGam CHAR(5) NOT NULL,
    codeCate CHAR(5) NOT NULL
    
);
GO

ALTER TABLE articles
ADD CONSTRAINT fk_articles_grilleTarifs FOREIGN KEY (codeGam, codeCate)
		REFERENCES grilleTarifs(codeGam, codeCate);
GO

CREATE TABLE lignesfic (
    noLig NUMERIC(3) NOT NULL,
    noFic NUMERIC(6) NOT NULL FOREIGN KEY REFERENCES fiches(noFic)
        ON DELETE CASCADE,
    refart CHAR(8) NOT NULL FOREIGN KEY REFERENCES articles(refart),
    depart DATE NOT NULL DEFAULT GETDATE(),
    retour DATE  
    CONSTRAINT pk_lignesfic_fiches PRIMARY KEY(noLig, noFic)
);
GO

ALTER TABLE lignesfic
ADD CONSTRAINT check_retour CHECK (retour > depart);
GO

ALTER TABLE fiches
ADD CONSTRAINT ck_fiches_datePaye_etat 
CHECK((datePaye IS NULL AND etat <> 'SO')OR 
    (datePaye IS NOT NULL AND etat = 'SO'));
GO