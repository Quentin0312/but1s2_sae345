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
    condition_and = ""
    # utilisation du filtre
    sql3=''' prise en compte des commentaires et des notes dans le SQL    '''
    sql = '''SELECT id_article,
            nom,
            prix,
            stock AS stock,
            image AS image
            FROM meuble'''

    list_param = []

    # Filtre mot
    filter_word = session.get('filter_word')
    if filter_word is not None and filter_word != "":
        if filter_word and filter_word != "":
            if sql.find("WHERE") == -1:
                sql += ' WHERE ('
            else:
                sql += ' AND ('
            filter_word_sql = "meuble.nom LIKE %s"
            sql += filter_word_sql
            list_param.append("%" + filter_word + "%")
            sql += ' ) '
    # Filtre prix
    filter_price_min = session.get('filter_price_min')
    filter_price_max = session.get('filter_price_max')
    min = str(filter_price_min).replace(' ', '').replace(',', '.')
    max = str(filter_price_max).replace(' ', '').replace(',', '.')

    if filter_price_min or filter_price_max:
        if min.replace('.', '', 1).isdigit() and max.replace('.', '', 1).isdigit():
            if float(min) < float(max):
                if sql.find("WHERE") == -1:
                    sql += ' WHERE ('
                else:
                    sql += ' AND ('

                sql += "meuble.prix BETWEEN %s AND %s ) "

                list_param.append(min)
                list_param.append(max)
            else:
                message = u'filtre sur le prix : prix min doit être inférieur au prix max'
                flash(message, 'alert-danger')
        else:
            message = u'filtre sur le prix : min et max doivent être des numériques'
            flash(message, 'alert-danger')

    # Filtre type
    filter_types = session.get('filter_types')
    if filter_types and filter_types != []:

        if sql.find("WHERE") == -1:
            sql += ' WHERE ('
        else:
            sql += ' AND ('

        first_done = False
        for type in filter_types:

            if first_done:
                sql += ' OR '
            filter_type_sql = "meuble.type_meuble_id = %s"
            sql += filter_type_sql
            first_done = True
            list_param.append(type)
        sql += ' ) '

    # Requete SQL
    sql += " ORDER BY nom;"
    if len(list_param) == 0:
        mycursor.execute(sql)
    else:
        mycursor.execute(sql, tuple(list_param))
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
