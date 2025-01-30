#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')              # remplace /client
def client_article_show():                                 # remplace client_index
    mycursor = get_db().cursor()
    id_client = session['id_user']

    sql = '''   selection des articles   '''
    list_param = []
    condition_and = ""
    # utilisation du filtre
    sql3=''' prise en compte des commentaires et des notes dans le SQL    '''
    sql = '''SELECT id_article,
            nom,
            prix,
            stock,
            image
            FROM meuble
            ORDER BY nom;'''
    mycursor.execute(sql)
    articles = mycursor.fetchall()


    # pour le filtre
    sql = '''
            SELECT id_type AS id_type_article,
                libelle_type AS libelle
                FROM type_meuble
                ORDER BY libelle;'''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = ''' SELECT * FROM ligne_panier WHERE utilisateur_id=%s; '''
    mycursor.execute(sql, (id_client))
    articles_panier = mycursor.fetchall()

    print("==============", articles_panier)

    if len(articles_panier) >= 1:
        sql = '''SELECT * , meuble.prix , meuble.nom 
        FROM ligne_panier JOIN meuble ON article_id = meuble.id_article WHERE utilisateur_id=%s;'''
        mycursor.execute(sql, (id_client))
        articles_panier = mycursor.fetchall()
        sql = ''' SELECT SUM(meuble.prix * ligne_panier.quantite) as prixTotal FROM ligne_panier 
        JOIN meuble ON article_id = meuble.id_article WHERE utilisateur_id=%s; '''
        mycursor.execute(sql, (id_client))
        prix_total = mycursor.fetchone()
        prix_total = prix_total['prixTotal']# requete à faire
    else:
        prix_total = 0
    return render_template('client/boutique/panier_article.html'
                           , articles=articles
                           , articles_panier=articles_panier
                           , prix_total=prix_total
                           , items_filtre=types_article
                           )
