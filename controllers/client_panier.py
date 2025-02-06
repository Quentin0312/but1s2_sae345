#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_panier = Blueprint('client_panier', __name__,
                          template_folder='templates')


@client_panier.route('/client/panier/add', methods=['POST'])
def client_panier_add():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article')
    quantite = request.form.get('quantite')
    # ---------
    # id_declinaison_article=request.form.get('id_declinaison_article',None)
    id_declinaison_article = 1

    # ajout dans le panier d'une déclinaison d'un article (si 1 declinaison : immédiat sinon => vu pour faire un choix
    # sql = '''    '''
    # mycursor.execute(sql, (id_article))
    # declinaisons = mycursor.fetchall()
    # if len(declinaisons) == 1:
    #     id_declinaison_article = declinaisons[0]['id_declinaison_article']
    # elif len(declinaisons) == 0:
    #     abort("pb nb de declinaison")
    # else:
    #     sql = '''   '''
    #     mycursor.execute(sql, (id_article))
    #     article = mycursor.fetchone()
    #     return render_template('client/boutique/declinaison_article.html'
    #                                , declinaisons=declinaisons
    #                                , quantite=quantite
    #                                , article=article)

    # ajout dans le panier d'un article
    sql = "SELECT * FROM ligne_panier WHERE article_id = %s AND utilisateur_id=%s"
    mycursor.execute(sql, (id_article, id_client))
    article_panier = mycursor.fetchone()

    mycursor.execute("SELECT * FROM meuble WHERE id_article = %s", (id_article))
    article = mycursor.fetchone()

    mycursor.execute("SELECT stock FROM meuble WHERE id_article = %s", (id_article))
    article_stock = mycursor.fetchone()

    # recherche du stock de l'article
    if article_stock['stock'] >= int(quantite):
        # code ci dessus

        tuple_update = (quantite, id_article)
        sql = "UPDATE meuble SET stock = stock-%s WHERE  id_article=%s"
        mycursor.execute(sql, tuple_update)

        if not (article_panier is None) and article_panier['quantite'] >= 1:
            tuple_update = (quantite, id_client, id_article)
            sql = "UPDATE ligne_panier SET quantite = quantite+%s WHERE utilisateur_id = %s AND article_id=%s"
            mycursor.execute(sql, tuple_update)
        else:
            tuple_insert = (id_client, id_article, quantite)
            sql = "INSERT INTO ligne_panier(utilisateur_id,article_id,quantite, date_ajout) VALUES (%s,%s,%s, current_timestamp )"
            mycursor.execute(sql, tuple_insert)



    else:
        flash(u'Stock insuffisant')

    get_db().commit()

    return redirect('/client/article/show')


@client_panier.route('/client/panier/delete', methods=['POST'])
def client_panier_delete():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article')

    # ---------
    # partie 2 : on supprime une déclinaison de l'article
    # id_declinaison_article = request.form.get('id_declinaison_article', None)

    print('supprime client ', id_client, 'article', id_article)

    sql = ''' SELECT * FROM ligne_panier WHERE utilisateur_id = %s AND article_id = %s '''
    mycursor.execute(sql, (id_client, id_article))
    article_panier = mycursor.fetchone()

    if not (article_panier is None) and article_panier['quantite'] > 1:
        sql = ''' UPDATE ligne_panier SET quantite = quantite-1 WHERE utilisateur_id = %s AND article_id=%s '''
        mycursor.execute(sql, (id_client, id_article))
        print('if not done')
    else:
        sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s AND article_id=%s '''
        mycursor.execute(sql, (id_client, id_article))
        print('else done')

    # mise à jour du stock de l'article disponible
    sql = "UPDATE meuble SET stock = stock+1 WHERE id_article=%s"
    mycursor.execute(sql, (id_article))
    get_db().commit()
    return redirect('/client/article/show')


@client_panier.route('/client/panier/vider', methods=['POST'])
def client_panier_vider():
    mycursor = get_db().cursor()
    client_id = session['id_user']
    sql = ''' SELECT * FROM ligne_panier WHERE utilisateur_id = %s '''
    retour = mycursor.execute(sql, (client_id))
    items_panier = mycursor.fetchall()
    for item in items_panier:
        sql = ''' DELETE FROM ligne_panier WHERE article_id = %s AND utilisateur_id = %s '''
        mycursor.execute(sql, (item['article_id'], client_id))

        sql = '''UPDATE meuble SET stock = stock+%s WHERE  id_article=%s'''
        mycursor.execute(sql, (item['quantite'], item['article_id']))

        get_db().commit()
    return redirect('/client/article/show')


@client_panier.route('/client/panier/delete/line', methods=['POST'])
def client_panier_delete_line():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    id_article = request.form.get('id_article')
    # id_declinaison_article = request.form.get('id_declinaison_article')

    sql = ''' SELECT * FROM ligne_panier WHERE utilisateur_id = %s AND article_id = %s'''
    mycursor.execute(sql, (id_client, id_article))
    article_panier = mycursor.fetchone()
    print('   re' ,article_panier)
    if not (article_panier is None) :
        sql = ''' DELETE FROM ligne_panier WHERE utilisateur_id = %s AND article_id = %s '''
        mycursor.execute(sql, (id_client, id_article))

    quantite = article_panier['quantite']
    sql2 = ''' UPDATE meuble SET stock = stock + %s WHERE id_article = %s'''
    mycursor.execute(sql2, (quantite, id_article))
    get_db().commit()
    return redirect('/client/article/show')


@client_panier.route('/client/panier/filtre', methods=['POST'])
def client_panier_filtre():
    filter_word = request.form.get('filter_word', None)
    if filter_word is not None:
        session['filter_word'] = filter_word
    elif session.get('filter_word') is not None:
        filter_word = session.get('filter_word')
    else:
        session['filter_word'] = ""

    filter_price_min = request.form.get('filter_price_min', None)
    if filter_price_min is not None:
        session['filter_price_min'] = filter_price_min
    elif session.get('filter_price_min') is not None:
        filter_price_min = session.get('filter_price_min')
    else:
        session['filter_price_min'] = ""

    filter_price_max = request.form.get('filter_price_max', None)
    if filter_price_max is not None:
        session['filter_price_max'] = filter_price_max
    elif session.get('filter_price_max') is not None:
        filter_price_max = session.get('filter_price_max')
    else:
        session['filter_price_max'] = ""

    filter_types = request.form.getlist('filter_types', str)
    if len(filter_types) > 0:
        session['filter_types'] = filter_types
    elif session.get('filter_types') is not None:
        pass
    else:
        session['filter_types'] = []
    # test des variables puis
    # mise en session des variables
    return redirect('/client/article/show')


@client_panier.route('/client/panier/filtre/suppr', methods=['POST'])
def client_panier_filtre_suppr():
    # suppression  des variables en session
    session.pop('filter_types') if session.get('filter_types') is not None else None
    session.pop('filter_word') if session.get('filter_word') is not None else None
    session.pop('filter_price_min') if session.get('filter_price_min') is not None else None
    session.pop('filter_price_max') if session.get('filter_price_max') is not None else None
    return redirect('/client/article/show')
