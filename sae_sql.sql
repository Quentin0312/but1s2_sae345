DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS ligne_panier;
DROP TABLE IF EXISTS commentaire;
DROP TABLE IF EXISTS note;
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
    id_etat      INT NOT NULL AUTO_INCREMENT,
    libelle_etat VARCHAR(255),
    PRIMARY KEY (id_etat)
);
INSERT INTO etat(libelle_etat)
VALUES ('en cours de traitement'),
       ('expédié'),
       ('validé');

CREATE TABLE commande
(
    id_commande         INT NOT NULL AUTO_INCREMENT,
    date_achat          DATETIME,
    utilisateur_id      INT NOT NULL,
    etat_id             INT NOT NULL,
    prix_total_commande NUMERIC(7, 2),
    PRIMARY KEY (id_commande),
    CONSTRAINT fk_commande_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur),
    CONSTRAINT fk_commande_etat FOREIGN KEY (etat_id) REFERENCES etat (id_etat)
);

CREATE TABLE materiau
(
    id_materiau      INT NOT NULL AUTO_INCREMENT,
    libelle_materiau VARCHAR(255),
    PRIMARY KEY (id_materiau)
);


CREATE TABLE type_meuble
(
    id_type      INT NOT NULL AUTO_INCREMENT,
    libelle_type VARCHAR(255),
    PRIMARY KEY (id_type)
);

CREATE TABLE meuble
(
    id_article     INT NOT NULL AUTO_INCREMENT,
    nom            VARCHAR(255),
    largeur        NUMERIC(7, 2),
    hauteur        NUMERIC(7, 2),
    prix           NUMERIC(7, 2),
    materiau_id    INT NOT NULL,
    type_meuble_id INT NOT NULL,
    fournisseur    VARCHAR(255),
    marque         VARCHAR(255),
    stock          INT,
    image          VARCHAR(255),
    description    TEXT,
    PRIMARY KEY (id_article),
    CONSTRAINT fk_meuble_materiau FOREIGN KEY (materiau_id) REFERENCES materiau (id_materiau),
    CONSTRAINT fk_meuble_type_meuble FOREIGN KEY (type_meuble_id) REFERENCES type_meuble (id_type)
);

CREATE TABLE note
(
    id_meuble      INT,
    id_utilisateur INT,
    note           DECIMAL(2, 1),
    PRIMARY KEY (id_meuble, id_utilisateur),
    CONSTRAINT fk_note_meuble FOREIGN KEY (id_meuble) REFERENCES meuble (id_article),
    CONSTRAINT fk_note_utilisateur FOREIGN KEY (id_utilisateur) REFERENCES utilisateur (id_utilisateur)
);

CREATE TABLE commentaire
(
    id_article       INT,
    id_utilisateur   INT,
    utilisateur_id   INT,
    date_publication DATETIME,
    date_ref         DATETIME,
    commentaire      VARCHAR(255),
    valider          BOOLEAN,
    PRIMARY KEY (id_article, id_utilisateur, date_publication),
    CONSTRAINT fk_commentaire_meuble FOREIGN KEY (id_article) REFERENCES meuble (id_article),
    CONSTRAINT fk_commentaire_utilisateur FOREIGN KEY (id_utilisateur) REFERENCES utilisateur (id_utilisateur),
    CONSTRAINT fk_commentaire_admin FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur)
);

CREATE TABLE ligne_commande
(
    commande_id INT,
    article_id  INT,
    prix        NUMERIC(7, 2),
    quantite    INT,
    CONSTRAINT fk_lignecommande_commande FOREIGN KEY (commande_id) REFERENCES commande (id_commande),
    CONSTRAINT fk_lignecommande_meuble FOREIGN KEY (article_id) REFERENCES meuble (id_article)
);

CREATE TABLE ligne_panier
(
    utilisateur_id INT,
    article_id     INT,
    quantite       INT,
    date_ajout     DATE,
    CONSTRAINT fk_lignepanier_utilisateur FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur),
    CONSTRAINT fk_lignepanier_meuble FOREIGN KEY (article_id) REFERENCES meuble (id_article)
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
VALUES (NULL, 'ÖSTANÖ', 39, 75, 20.99, 3, 1, 'Maison du meuble', 'Miliboo', 45, 'oestanoe-chaise.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'LISABO', 46, 79, 59.99, 2, 1, 'Mobilier Éco', 'Kave Home', 67, 'lisabo-chaise.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'BERGMUND', 52, 95, 89.99, 1, 1, 'IKEA', 'Tikamoon', 82, 'bergmund-chaise.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'BRIMNES', 146, 47, 289, 1, 2, 'IKEA', 'Kave Home', 34, 'brimnes-lit.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'MALM', 156, 38, 279, 2, 2, 'Maison du meuble', 'Miliboo', 56, 'malm-lit.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'MANDAL', 160, 27, 379, 1, 2, 'Mobilier Éco', 'Kave Home', 78, 'mandal-lit.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'EKEDALEN', 80, 75, 249.99, 1, 3, 'NV Gallery', 'Bobochic', 90, 'ekedalen-table.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'LANEBERG', 70, 75, 199, 3, 3, 'IKEA', 'Kave Home', 29, 'laneberg-table.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'STRANDTORP', 95, 77, 499, 3, 3, 'Maison du meuble', 'Miliboo', 50, 'strandtorp-table.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'PINNTORP', 75, 75, 129, 2, 3, 'Mobilier Éco', 'Kave Home', 63, 'pinntorp-table.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'LAGKAPTEN / ALEX', 140, 73, 277.99, 1, 4, 'IKEA', 'Tikamoon', 71, 'lagkapten-alex-bureau.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'UTESPELARE', 160, 66.78, 199, 3, 4, 'NV Gallery', 'Miliboo', 42, 'utespelare-bureau.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'KALLAX', 111, 77, 49.99, 2, 4, 'Mobilier Éco', 'Tikamoon', 88, 'kallax-bureau.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'MITTZON ', 120, 65, 219, 1, 4, 'IKEA', 'Kave Home', 39, 'mittzon-bureau.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'MALM', 120.3, 77.4, 129, 2, 4, 'NV Gallery', 'Tikamoon', 52, 'malm-bureau.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'UTVISNING', 120, 78, 159, 3, 4, 'Maison du meuble', 'Kave Home', 65, 'utvisning-bureau.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'KLEPPSTAD', 79, 176, 99.99, 1, 5, 'IKEA', 'Miliboo', 77, 'kleppstad-armoire.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'BRIMNES', 117.1, 190.5, 179, 1, 5, 'Mobilier Éco', 'Bobochic', 48, 'brimnes-armoire.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'PLATSA', 160, 181, 262, 2, 5, 'Maison du meuble', 'Tikamoon', 85, 'platsa-armoire.png',
        'Très bon meuble. Solide et design'),
       (NULL, 'RAKKESTAD', 117.3, 175.7, 179, 2, 5, 'NV Gallery', 'Kave Home', 60, 'rakkestad-armoire.png',
        'Très bon meuble. Solide et design');

DELETE
FROM ligne_commande;
DELETE
FROM commande;

INSERT INTO commande (id_commande, date_achat, utilisateur_id, etat_id, prix_total_commande)
VALUES (1, '2024-11-16 14:45:22', 2, 2, 956.99),
       (2, '2024-11-20 14:45:22', 3, 2, 269.97);

INSERT INTO ligne_commande
VALUES (1, 3, 89.99, 1),
       (1, 4, 289.00, 3),
       (2, 3, 89.99, 3);

INSERT INTO commande (id_commande, date_achat, utilisateur_id, etat_id, prix_total_commande)
VALUES (3, '2025-02-01 09:21:52', 2, 1, 378.99);

INSERT INTO ligne_commande
VALUES (3, 11, 277.99, 1),
       (3, 2, 20.99, 6);

# TODO : Tester avec plusieurs notes (provenant de différents acheteurs)
INSERT INTO note
VALUES (3, 2, 3.5),
       (3, 3, 2.5),
       (4, 2, 4.0);

INSERT INTO commentaire
VALUES (3, 2, null, '2024-12-02', null, 'pas mal', true),
       (3, 2, 1, '2025-01-02', '2024-12-02', 'ma rép', true),
       (3, 2, null, '2024-12-04', null, 'pas trop mal', false);

--

-- Ajout de nouveaux utilisateurs
INSERT INTO utilisateur(id_utilisateur, login, email, password, role, nom, est_actif)
VALUES
(4, 'user1', 'user1@client.com', 'password_hash_1', 'ROLE_client', 'User One', '1'),
(5, 'user2', 'user2@client.com', 'password_hash_2', 'ROLE_client', 'User Two', '1'),
(6, 'user3', 'user3@client.com', 'password_hash_3', 'ROLE_client', 'User Three', '1');

-- Ajout de commandes pour les nouveaux utilisateurs
INSERT INTO commande (id_commande, date_achat, utilisateur_id, etat_id, prix_total_commande)
VALUES
(4, '2025-03-10 10:30:00', 4, 1, 249.99),
(5, '2025-03-12 12:00:00', 5, 2, 599.98),
(6, '2025-03-15 14:30:00', 6, 3, 399.99);

-- Ajout des lignes de commande associées
INSERT INTO ligne_commande (commande_id, article_id, prix, quantite)
VALUES
(4, 3, 89.99, 2),  -- User1 achète 2 meubles de type 'table' (id_article 3)
(5, 5, 289.00, 1),  -- User2 achète 1 meuble 'lit' (id_article 5)
(6, 7, 249.99, 1);  -- User3 achète 1 meuble 'table' (id_article 7)

-- Ajout de notes pour les utilisateurs
INSERT INTO note (id_meuble, id_utilisateur, note)
VALUES
(3, 4, 4.0),  -- User1 note le produit 'LANEBERG' (id_article 3)
(5, 5, 3.5),  -- User2 note le produit 'MALM' (id_article 5)
(7, 6, 4.5);  -- User3 note le produit 'STRANDTORP' (id_article 7)

-- Ajout de commentaires pour les utilisateurs
-- User1 a acheté le meuble 'LANEBERG' (id_article 3)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(3, 4, NULL, '2025-03-11', 'Très satisfait, bonne qualité !', true),
(3, 4, 1, '2025-03-12', 'Bon rapport qualité/prix', true),
(3, 4, NULL, '2025-03-13', 'Recommandé pour les petits espaces', false);

-- User2 a acheté le meuble 'MALM' (id_article 5)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(5, 5, NULL, '2025-03-13', 'Solide et spacieux, parfait pour ma chambre', true),
(5, 5, NULL, '2025-03-14', 'Un peu cher, mais de bonne qualité', true);

-- User3 a acheté le meuble 'STRANDTORP' (id_article 7)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(7, 6, NULL, '2025-03-16', 'Super meuble, très design', true),
(7, 6, NULL, '2025-03-17', 'Très satisfait, montage facile', false),
(7, 6, NULL, '2025-03-18', 'Bon produit mais un peu cher', true);

-- Ajout de nouveaux utilisateurs
INSERT INTO utilisateur(id_utilisateur, login, email, password, role, nom, est_actif)
VALUES
(7, 'user4', 'user4@client.com', 'password_hash_4', 'ROLE_client', 'User Four', '1'),
(8, 'user5', 'user5@client.com', 'password_hash_5', 'ROLE_client', 'User Five', '1'),
(9, 'user6', 'user6@client.com', 'password_hash_6', 'ROLE_client', 'User Six', '1'),
(10, 'user7', 'user7@client.com', 'password_hash_7', 'ROLE_client', 'User Seven', '1'),
(11, 'user8', 'user8@client.com', 'password_hash_8', 'ROLE_client', 'User Eight', '1'),
(12, 'user9', 'user9@client.com', 'password_hash_9', 'ROLE_client', 'User Nine', '1');

-- Ajout de commandes pour les nouveaux utilisateurs
INSERT INTO commande (id_commande, date_achat, utilisateur_id, etat_id, prix_total_commande)
VALUES
(7, '2025-03-20 10:30:00', 7, 1, 179.99),
(8, '2025-03-22 12:00:00', 8, 2, 799.98),
(9, '2025-03-25 14:30:00', 9, 3, 499.99),
(10, '2025-03-30 15:00:00', 10, 1, 249.99),
(11, '2025-04-02 16:00:00', 11, 2, 399.99),
(12, '2025-04-05 17:30:00', 12, 3, 299.99);

-- Ajout des lignes de commande associées
INSERT INTO ligne_commande (commande_id, article_id, prix, quantite)
VALUES
(7, 3, 89.99, 2),  -- User4 achète 2 meubles de type 'table' (id_article 3)
(8, 5, 289.00, 2),  -- User5 achète 2 meubles 'lit' (id_article 5)
(9, 7, 249.99, 2),  -- User6 achète 2 meubles 'table' (id_article 7)
(10, 9, 129.99, 2),  -- User7 achète 2 meubles 'armoire' (id_article 9)
(11, 11, 179.00, 3), -- User8 achète 3 meubles 'armoire' (id_article 11)
(12, 2, 20.99, 8);   -- User9 achète 8 meubles 'chaise' (id_article 2)

-- Ajout de notes pour les utilisateurs
INSERT INTO note (id_meuble, id_utilisateur, note)
VALUES
(3, 7, 4.0),  -- User4 note le produit 'LANEBERG' (id_article 3)
(5, 8, 3.5),  -- User5 note le produit 'MALM' (id_article 5)
(7, 9, 4.5),  -- User6 note le produit 'STRANDTORP' (id_article 7)
(9, 10, 2.5), -- User7 note le produit 'KALLAX' (id_article 9)
(11, 11, 3.0), -- User8 note le produit 'BRIMNES' (id_article 11)
(2, 12, 4.0);  -- User9 note le produit 'LISABO' (id_article 2)

-- Ajout de commentaires pour les utilisateurs
-- User4 a acheté le meuble 'LANEBERG' (id_article 3)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(3, 7, NULL, '2025-03-21', 'Très satisfait du produit !', true),
(3, 7, 1, '2025-03-22', 'Produit de bonne qualité, livraison rapide', true),
(3, 7, NULL, '2025-03-23', 'Je recommande, très confortable', false);

-- User5 a acheté le meuble 'MALM' (id_article 5)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(5, 8, NULL, '2025-03-23', 'Très beau meuble, facile à monter', true),
(5, 8, 1, '2025-03-24', 'Un peu cher mais confortable', true),
(5, 8, NULL, '2025-03-25', 'Solide mais pas assez spacieux pour moi', false);

-- User6 a acheté le meuble 'STRANDTORP' (id_article 7)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(7, 9, NULL, '2025-03-26', 'Produit de qualité, livraison rapide', true),
(7, 9, NULL, '2025-03-27', 'Montage simple, design moderne', false),
(7, 9, NULL, '2025-03-28', 'Un peu cher mais très solide', true);

-- User7 a acheté le meuble 'KALLAX' (id_article 9)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(9, 10, NULL, '2025-03-31', 'Bon produit pour le prix', true),
(9, 10, NULL, '2025-04-01', 'Un peu plus cher que prévu, mais solide', false),
(9, 10, NULL, '2025-04-02', 'J\'aime beaucoup le design', true);

-- User8 a acheté le meuble 'BRIMNES' (id_article 11)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(11, 11, NULL, '2025-04-03', 'Beau produit mais un peu compliqué à monter', true),
(11, 11, 1, '2025-04-04', 'Très content de mon achat', true),
(11, 11, NULL, '2025-04-05', 'Bonne qualité, un peu cher', false);

-- User9 a acheté le meuble 'LISABO' (id_article 2)
INSERT INTO commentaire (id_article, id_utilisateur, utilisateur_id, date_publication, commentaire, valider)
VALUES
(2, 12, NULL, '2025-04-06', 'Très bon rapport qualité/prix', true),
(2, 12, NULL, '2025-04-07', 'Assez confortable, mais manque de couleur', true),
(2, 12, NULL, '2025-04-08', 'Je ne suis pas satisfait du design', false);
