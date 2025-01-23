DROP TABLE IF EXISTS utilisateur;
DROP TABLE IF EXISTS meuble;
DROP TABLE IF EXISTS materiau;
DROP TABLE IF EXISTS type_meuble;

CREATE TABLE utilisateur(
    id_utilisateur INT NOT NULL AUTO_INCREMENT,
    login VARCHAR(255),
    password VARCHAR(255),
    email VARCHAR(255),
    nom VARCHAR(255),
    role VARCHAR(255),
    est_actif TINYINT(1),
    PRIMARY KEY (id_utilisateur)
)DEFAULT CHARSET utf8mb4;

INSERT INTO utilisateur(id_utilisateur,login,email,password,role,nom,est_actif) VALUES
(1,'admin','admin@admin.fr',
    'pbkdf2:sha256:1000000$eQDrpqICHZ9eaRTn$446552ca50b5b3c248db2dde6deac950711c03c5d4863fe2bd9cef31d5f11988',
    'ROLE_admin','admin','1'),
(2,'client','client@client.fr',
    'pbkdf2:sha256:1000000$jTcSUnFLWqDqGBJz$bf570532ed29dc8e3836245f37553be6bfea24d19dfb13145d33ab667c09b349',
    'ROLE_client','client','1'),
(3,'client2','client2@client2.fr',
    'pbkdf2:sha256:1000000$qDAkJlUehmaARP1S$39044e949f63765b785007523adcde3d2ad9c2283d71e3ce5ffe58cbf8d86080',
    'ROLE_client','client2','1');

SELECT * FROM utilisateur;

SHOW TABLES;

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
    PRIMARY KEY (id_meuble),
    CONSTRAINT fk_meuble_materiau FOREIGN KEY (materiau_id) REFERENCES materiau (id_materiau),
    CONSTRAINT fk_meuble_type_meuble FOREIGN KEY (type_meuble_id) REFERENCES type_meuble (id_type)
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
VALUES (NULL,'ÖSTANÖ',39,75,20.99,3,1,'Maison du meuble','Miliboo'),
       (NULL,'LISABO',46,79,59.99,2,1,'Mobilier Éco','Kave Home'),
       (NULL,'BERGMUND',52,95,89.99,1,1,'IKEA','Tikamoon'),
       (NULL,'BRIMNES',146,47,289,1,2,'IKEA','Kave Home'),
       (NULL,'MALM',156,38,279,2,2,'Maison du meuble', 'Miliboo'),
       (NULL,'MANDAL',160,27,379,1,2,'Mobilier Éco','Kave Home'),
       (NULL,'EKEDALEN',80,75,249.99, 1,3,'NV Gallery','Bobochic'),
       (NULL,'LANEBERG',70,75,199,3,3,'IKEA','Kave Home'),
       (NULL,'STRANDTORP', 95,77,499,3,3,'Maison du meuble','Miliboo'),
       (NULL,'PINNTORP',75,75,129,2,3,'Mobilier Éco','Kave Home'),
       (NULL, 'LAGKAPTEN / ALEX', 140, 73, 277.99, 1, 4, 'IKEA','Tikamoon'),
       (NULL,'UTESPELARE', 160, 66.78, 199, 3, 4, 'NV Gallery', 'Miliboo'),
       (NULL,'KALLAX', 111, 77, 49.99, 2, 4, 'Mobilier Éco', 'Tikamoon'),
       (NULL,'MITTZON ', 120, 65, 219, 1, 4, 'IKEA', 'Kave Home'), #HAUTEUR => 65-85cm
                                                                                  (NULL,'MALM', 120.3, 77.4, 129, 2, 4, 'NV Gallery', 'Tikamoon'),
       (NULL,'UTVISNING', 120, 78, 159, 3, 4, 'Maison du meuble', 'Kave Home'), #plataeu hauteur+12cm
       (NULL,'KLEPPSTAD', 79, 176, 99.99, 1, 5, 'IKEA', 'Miliboo'),
       (NULL,'BRIMNES', 117.1, 190.5, 179, 1, 5, 'Mobilier Éco', 'Bobochic'),
       (NULL,'PLATSA', 160, 181, 262, 2, 5, 'Maison du meuble', 'Tikamoon'),
       (NULL,'RAKKESTAD', 117.3, 175.7, 179, 2, 5, 'NV Gallery', 'Kave Home');
