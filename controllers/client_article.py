#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                           template_folder='templates')


@client_article.route('/client/index')
@client_article.route('/client/article/show')  # remplace /client
def client_article_show():  # remplace client_index
    mycursor = get_db().cursor()
    id_client = session['id_user']

    sql = '''   selection des articles   '''
    list_param = []
    condition_and = ""
    # utilisation du filtre
    # sql3=''' prise en compte des commentaires et des notes dans le SQL    '''
    sql = '''
            SELECT id_meuble AS id_article
                   , nom_meuble AS nom
                   , prix_meuble AS prix
                   # , stock AS stock
                   , image
            FROM meuble
            ORDER BY nom_meuble;
            '''
    mycursor.execute(sql)
    articles = mycursor.fetchall()

    # pour le filtre
    sql = '''
    SELECT id_type AS id_type_article, libelle_type AS libelle FROM type_meuble ORDER BY libelle_type; 
    '''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = "SELECT * , 10 as prix , concat('nomarticle',meuble_id) as nom FROM ligne_panier"
    mycursor.execute(sql)
    articles_panier = mycursor.fetchall()
    # articles_panier = []

    if len(articles_panier) >= 1:
        sql = ''' calcul du prix total du panier '''
        prix_total = None
    else:
        prix_total = None
    return render_template('client/boutique/panier_article.html'
                           , articles=articles
                           , articles_panier=articles_panier
                           # , prix_total=prix_total
                           , items_filtre=types_article
                           )
