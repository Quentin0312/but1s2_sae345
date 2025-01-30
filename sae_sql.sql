DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS meuble;
DROP TABLE IF EXISTS type_meuble;
DROP TABLE IF EXISTS materiau;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS utilisateur;

CREATE TABLE utilisateur
(
    id_utilisateur INT NOT NULL AUTO_INCREMENT,
    login          VARCHAR(255),
    password       VARCHAR(255),
    email          VARCHAR(255),
    nom            VARCHAR(255),
    role           VARCHAR(255),
    est_actif      TINYINT(1),
    PRIMARY KEY (id_utilisateur)
) DEFAULT CHARSET utf8mb4;

INSERT INTO utilisateur(id_utilisateur, login, email, password, role, nom, est_actif)
VALUES (1, 'admin', 'admin@admin.fr',
        'pbkdf2:sha256:1000000$eQDrpqICHZ9eaRTn$446552ca50b5b3c248db2dde6deac950711c03c5d4863fe2bd9cef31d5f11988',
        'ROLE_admin', 'admin', '1'),
       (2, 'client', 'client@client.fr',
        'pbkdf2:sha256:1000000$jTcSUnFLWqDqGBJz$bf570532ed29dc8e3836245f37553be6bfea24d19dfb13145d33ab667c09b349',
        'ROLE_client', 'client', '1'),
       (3, 'client2', 'client2@client2.fr',
        'pbkdf2:sha256:1000000$qDAkJlUehmaARP1S$39044e949f63765b785007523adcde3d2ad9c2283d71e3ce5ffe58cbf8d86080',
        'ROLE_client', 'client2', '1');


CREATE TABLE etat
(
    id_etat      INT AUTO_INCREMENT,
    libelle_etat VARCHAR(255),
    PRIMARY KEY (id_etat)
);

CREATE TABLE commande
(
    id_commande         INT AUTO_INCREMENT,
    date_achat          DATE,
    prix_total_commande NUMERIC(7, 2),
    utilisateur_id      INT,
    etat_id             INT,
    PRIMARY KEY (id_commande),
    CONSTRAINT fk_commande_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur),
    CONSTRAINT fk_commande_etat FOREIGN KEY (etat_id) REFERENCES etat (id_etat)
);

CREATE TABLE materiau
(
    id_materiau      INT AUTO_INCREMENT,
    libelle_materiau VARCHAR(255),
    PRIMARY KEY (id_materiau)
);


CREATE TABLE type_meuble
(
    id_type      INT AUTO_INCREMENT,
    libelle_type VARCHAR(255),
    PRIMARY KEY (id_type)
);

CREATE TABLE meuble
(
    id_meuble      INT AUTO_INCREMENT,
    nom_meuble     VARCHAR(255),
    largeur        NUMERIC(7, 2),
    hauteur        NUMERIC(7, 2),
    prix_meuble    NUMERIC(7, 2),
    materiau_id    INT,
    type_meuble_id INT,
    fournisseur    VARCHAR(255),
    marque         VARCHAR(255),
    stock          INT,
    image          VARCHAR(255),
    PRIMARY KEY (id_meuble),
    CONSTRAINT fk_meuble_materiau FOREIGN KEY (materiau_id) REFERENCES materiau (id_materiau),
    CONSTRAINT fk_meuble_type_meuble FOREIGN KEY (type_meuble_id) REFERENCES type_meuble (id_type)
);

CREATE TABLE ligne_commande
(
    commande_id INT,
    meuble_id   INT,
    prix        NUMERIC(7, 2),
    quantite    INT,
    CONSTRAINT fk_lignecommande_commande FOREIGN KEY (commande_id) REFERENCES commande (id_commande),
    CONSTRAINT fk_lignecommande_meuble FOREIGN KEY (meuble_id) REFERENCES meuble (id_meuble)
);

CREATE TABLE ligne_panier
(
    utilisateur_id    INT,
    meuble_id         INT,
    quantite   INT,
    date_ajout DATE,
    CONSTRAINT fk_lignepanier_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur),
    CONSTRAINT fk_lignepanier_meuble FOREIGN KEY (meuble_id) REFERENCES meuble (id_meuble)
);


INSERT INTO materiau
VALUES (1, 'chene'),
       (2, 'pin'),
       (3, 'modele unique');

INSERT INTO type_meuble
VALUES (1, 'chaise'),
       (2, 'lit'),
       (3, 'table'),
       (4, 'bureau'),
       (5, 'armoire');

INSERT INTO meuble
VALUES (NULL, 'ÖSTANÖ', 39, 75, 20.99, 3, 1, 'Maison du meuble', 'Miliboo', 45, 'oestanoe-chaise.png'),
       (NULL, 'LISABO', 46, 79, 59.99, 2, 1, 'Mobilier Éco', 'Kave Home', 67, 'lisabo-chaise.png'),
       (NULL, 'BERGMUND', 52, 95, 89.99, 1, 1, 'IKEA', 'Tikamoon', 82, 'bergmund-chaise.png'),
       (NULL, 'BRIMNES', 146, 47, 289, 1, 2, 'IKEA', 'Kave Home', 34, 'brimnes-lit.png'),
       (NULL, 'MALM', 156, 38, 279, 2, 2, 'Maison du meuble', 'Miliboo', 56, 'malm-lit.png'),
       (NULL, 'MANDAL', 160, 27, 379, 1, 2, 'Mobilier Éco', 'Kave Home', 78, 'mandal-lit.png'),
       (NULL, 'EKEDALEN', 80, 75, 249.99, 1, 3, 'NV Gallery', 'Bobochic', 90, 'ekedalen-table.png'),
       (NULL, 'LANEBERG', 70, 75, 199, 3, 3, 'IKEA', 'Kave Home', 29, 'laneberg-table.png'),
       (NULL, 'STRANDTORP', 95, 77, 499, 3, 3, 'Maison du meuble', 'Miliboo', 50, 'strandtorp-table.png'),
       (NULL, 'PINNTORP', 75, 75, 129, 2, 3, 'Mobilier Éco', 'Kave Home', 63, 'pinntorp-table.png'),
       (NULL, 'LAGKAPTEN / ALEX', 140, 73, 277.99, 1, 4, 'IKEA', 'Tikamoon', 71, 'lagkapten-alex-bureau.png'),
       (NULL, 'UTESPELARE', 160, 66.78, 199, 3, 4, 'NV Gallery', 'Miliboo', 42, 'utespelare-bureau.png'),
       (NULL, 'KALLAX', 111, 77, 49.99, 2, 4, 'Mobilier Éco', 'Tikamoon', 88, 'kallax-bureau.png'),
       (NULL, 'MITTZON ', 120, 65, 219, 1, 4, 'IKEA', 'Kave Home', 39, 'mittzon-bureau.png'),
       (NULL, 'MALM', 120.3, 77.4, 129, 2, 4, 'NV Gallery', 'Tikamoon', 52, 'malm-bureau.png'),
       (NULL, 'UTVISNING', 120, 78, 159, 3, 4, 'Maison du meuble', 'Kave Home', 65, 'utvisning-bureau.png'),
       (NULL, 'KLEPPSTAD', 79, 176, 99.99, 1, 5, 'IKEA', 'Miliboo', 77, 'kleppstad-armoire.png'),
       (NULL, 'BRIMNES', 117.1, 190.5, 179, 1, 5, 'Mobilier Éco', 'Bobochic', 48, 'brimnes-armoire.png'),
       (NULL, 'PLATSA', 160, 181, 262, 2, 5, 'Maison du meuble', 'Tikamoon', 85, 'platsa-armoire.png'),
       (NULL, 'RAKKESTAD', 117.3, 175.7, 179, 2, 5, 'NV Gallery', 'Kave Home', 60, 'rakkestad-armoire.png');
