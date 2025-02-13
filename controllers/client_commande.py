#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                            template_folder='templates')


# validation de la commande : partie 2 -- vue pour choisir les adresses (livraision et facturation)
@client_commande.route('/client/commande/valide', methods=['POST'])
def client_commande_valide():
    # mycursor = get_db().cursor()
    # id_client = session['id_user']
    # sql = '''SELECT * FROM ligne_panier WHERE utilisateur_id=%s;'''
    # mycursor.execute(sql, id_client)
    # articles_panier = mycursor.fetchall()
    # if len(articles_panier) >= 1:
        # sql = ''' calcul du prix total du panier '''
    #     sql = '''
    #     SELECT ligne_panier.quantite * meuble.prix AS prix
    #     FROM ligne_panier
    #              JOIN meuble ON meuble.id_article = ligne_panier.article_id
    #     WHERE utilisateur_id = %s;
    #     '''
    #     mycursor.execute(sql, id_client)
    #     prix_total = mycursor.fetchone()
    # else:
    #     prix_total = None
    # etape 2 : selection des adresses
    return render_template('client/boutique/panier_validation_adresses.html'
                           # , adresses=adresses
                           # , articles_panier=articles_panier
                           # , prix_total= prix_total
                           # , validation=1
                           # , id_adresse_fav=id_adresse_fav
                           )


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    # choix de(s) (l')adresse(s)

    id_client = session['id_user']

    sql = ''' SELECT * FROM ligne_panier WHERE utilisateur_id=%s '''
    mycursor.execute(sql, id_client)
    items_ligne_panier = mycursor.fetchall()
    if items_ligne_panier is None or len(items_ligne_panier) < 1:
        flash(u'Pas d\'articles dans le ligne_panier', 'alert-warning')
        return redirect('/client/article/show')
        # https://pynative.com/python-mysql-transaction-management-using-commit-rollback/
    # a = datetime.strptime('my date', "%b %d %Y %H:%M")

    # prix total commande =>
    sql = '''
    SELECT SUM(ligne_panier.quantite * meuble.prix) AS prix_total_commande
    FROM ligne_panier
             JOIN meuble ON meuble.id_article = ligne_panier.article_id
    WHERE utilisateur_id = %s;
    '''
    mycursor.execute(sql, id_client)
    prix_total_commande = mycursor.fetchone()
    date_commande = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    tuple_insert = (date_commande, id_client, '1', prix_total_commande['prix_total_commande'])  # 1 : etat de commande : "en cours" ou "validé"
    sql = ''' INSERT INTO commande(date_achat, utilisateur_id, etat_id, prix_total_commande) VALUES (%s,%s,%s,%s) '''
    mycursor.execute(sql, tuple_insert)

    sql = '''SELECT last_insert_id() as last_insert_id'''
    mycursor.execute(sql)
    commande_id = mycursor.fetchone()
    print(commande_id, tuple_insert)
    # numéro de la dernière commande
    for item in items_ligne_panier:
        sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s AND article_id = %s '''
        mycursor.execute(sql, (item['utilisateur_id'], item['article_id']))
        sql = ''' SELECT prix FROM meuble WHERE id_article = %s '''
        mycursor.execute(sql, (item['article_id']))
        prix = mycursor.fetchone()
        print(prix)

        sql = ''' INSERT INTO ligne_commande(commande_id, article_id, prix, quantite) VALUES (%s,%s,%s,%s) '''
        tuple_insert = (commande_id['last_insert_id'], item['article_id'], prix['prix'], item['quantite'])
        print(tuple_insert)
        mycursor.execute(sql, tuple_insert)
    get_db().commit()
    flash(u'Commande ajoutée', 'alert-success')
    return redirect('/client/article/show')


@client_commande.route('/client/commande/show', methods=['get', 'post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''SELECT id_commande,
       date_achat,
       etat_id,
       prix_total_commande                            AS prix_total,
       (SELECT SUM(quantite)
        FROM ligne_commande
                 JOIN commande cSR ON ligne_commande.commande_id = commande.id_commande
        WHERE cSR.id_commande = commande.id_commande) AS nbr_articles
FROM commande
         JOIN ligne_commande ON commande.id_commande = ligne_commande.commande_id
WHERE utilisateur_id = %s
GROUP BY id_commande, date_achat, etat_id, prix_total
ORDER BY etat_id, date_achat;'''
    mycursor.execute(sql, id_client)
    commandes = mycursor.fetchall()

    articles_commande = None
    commande_adresses = None
    id_commande = request.args.get('id_commande', None)
    if id_commande != None:
        print(id_commande)
        sql = ''' selection du détails d'une commande '''

        # partie 2 : selection de l'adresse de livraison et de facturation de la commande selectionnée
        sql = ''' selection des adressses '''

    return render_template('client/commandes/show.html'
                           , commandes=commandes
                           , articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )
