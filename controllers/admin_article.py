#! /usr/bin/python
# -*- coding:utf-8 -*-
import math
import os.path
from random import random

from flask import Blueprint
from flask import request, render_template, redirect, flash
# from werkzeug.utils import secure_filename

from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__,
                          template_folder='templates')


@admin_article.route('/admin/article/show')
def show_article():
    mycursor = get_db().cursor()
    sql = '''SELECT id_article,
                nom,
                type_meuble_id AS type_article_id,
                type_meuble.libelle_type AS libelle,
                prix,
                stock AS stock,
                image AS image
                FROM meuble
                JOIN type_meuble ON meuble.type_meuble_id = type_meuble.id_type'''
    mycursor.execute(sql)
    articles = mycursor.fetchall()
    return render_template('admin/article/show_article.html', articles=articles)


@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()

    sql = '''SELECT * FROM type_meuble;'''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = '''SELECT * FROM materiau;'''
    mycursor.execute(sql)
    materiaux = mycursor.fetchall()

    return render_template('admin/article/add_article.html'
                           ,types_article=types_article,
                           materiaux=materiaux
                           # ,tailles=tailles
                           )


@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()

    nom = request.form.get('nom', '')
    largeur = request.form.get('largeur', '')
    hauteur = request.form.get('hauteur', '')
    prix = request.form.get('prix', '')
    materiau_id = request.form.get('materiau_id', '')
    type_article_id = request.form.get('type_article_id', '')
    fournisseur = request.form.get('fournisseur', '')
    marque = request.form.get('marque', '')
    stock = request.form.get('stock', '')
    image = request.files.get('image', '')

    if image:
        filename = 'img_upload' + str(int(2147483647 * random())) + '.png'
        image.save(os.path.join('static/images/', filename))
    else:
        print("erreur")
        filename = None

    sql = '''INSERT INTO meuble(nom, largeur, hauteur, prix, materiau_id, type_meuble_id, fournisseur, marque, stock, image)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'''

    tuple_add = (nom, largeur, hauteur, prix, materiau_id, type_article_id, fournisseur, marque, stock, filename)
    print(tuple_add)
    mycursor.execute(sql, tuple_add)
    get_db().commit()
    #
    # print(u'article ajouté , nom: ', nom, ' - type_article:', type_article_id, ' - prix:', prix,
    #       ' - description:', description, ' - image:', image)
    # message = u'article ajouté , nom:' + nom + '- type_article:' + type_article_id + ' - prix:' + prix + ' - description:' + description + ' - image:' + str(
    #     image)
    # flash(message, 'alert-success')
    return redirect('/admin/article/show')


@admin_article.route('/admin/article/delete', methods=['GET'])
def delete_article():
    id_article = request.args.get('id_article')
    mycursor = get_db().cursor()
    sql = ''' requête admin_article_3 '''
    mycursor.execute(sql, id_article)
    nb_declinaison = mycursor.fetchone()
    if nb_declinaison['nb_declinaison'] > 0:
        message = u'il y a des declinaisons dans cet article : vous ne pouvez pas le supprimer'
        flash(message, 'alert-warning')
    else:
        sql = ''' requête admin_article_4 '''
        mycursor.execute(sql, id_article)
        article = mycursor.fetchone()
        print(article)
        image = article['image']

        sql = ''' requête admin_article_5  '''
        mycursor.execute(sql, id_article)
        get_db().commit()
        if image != None:
            os.remove('static/images/' + image)

        print("un article supprimé, id :", id_article)
        message = u'un article supprimé, id : ' + id_article
        flash(message, 'alert-success')

    return redirect('/admin/article/show')


@admin_article.route('/admin/article/edit', methods=['GET'])
def edit_article():
    id_article = request.args.get('id_article')
    mycursor = get_db().cursor()
    sql = '''SELECT * FROM meuble WHERE id_article = %s;'''
    mycursor.execute(sql, id_article)
    article = mycursor.fetchone()
    print(article)
    sql = '''SELECT * FROM type_meuble;'''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = '''SELECT * FROM materiau;'''
    mycursor.execute(sql)
    materiaux = mycursor.fetchall()

    # sql = '''
    # requête admin_article_6
    # '''
    # mycursor.execute(sql, id_article)
    # declinaisons_article = mycursor.fetchall()

    return render_template('admin/article/edit_article.html'
                           , article=article
                           , types_article=types_article
                           , materiaux=materiaux
                           #  ,declinaisons_article=declinaisons_article
                           )


@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    mycursor = get_db().cursor()

    id_article = request.form.get('id_article')
    nom = request.form.get('nom', '')
    largeur = request.form.get('largeur', '')
    hauteur = request.form.get('hauteur', '')
    prix = request.form.get('prix', '')
    materiau_id = request.form.get('materiau_id', '')
    type_article_id = request.form.get('type_article_id', '')
    fournisseur = request.form.get('fournisseur', '')
    marque = request.form.get('marque', '')
    stock = request.form.get('stock', '')
    image = request.files.get('image', '')

    sql = '''
       SELECT image FROM meuble WHERE id_article = %s;
       '''
    mycursor.execute(sql, id_article)
    image_nom = mycursor.fetchone()
    image_nom = image_nom['image']
    if image:
        if image_nom != "" and image_nom is not None and os.path.exists(
                os.path.join(os.getcwd() + "/static/images/", image_nom)):
            os.remove(os.path.join(os.getcwd() + "/static/images/", image_nom))
        # filename = secure_filename(image.filename)
        if image:
            filename = 'img_upload_' + str(int(2147483647 * random())) + '.png'
            image.save(os.path.join('static/images/', filename))
            image_nom = filename

    sql = '''  UPDATE meuble SET nom = %s, largeur = %s, hauteur = %s, prix = %s, materiau_id = %s, type_meuble_id = %s, fournisseur = %s,
        marque = %s, stock = %s WHERE id_article = %s; '''
    tuple_edit = (nom, largeur, hauteur, prix, materiau_id, type_article_id, fournisseur, marque, stock, id_article)
    mycursor.execute(sql, tuple_edit)

    get_db().commit()
    if image_nom is None:
        image_nom = ''
    return redirect('/admin/article/show')


@admin_article.route('/admin/article/avis/<int:id>', methods=['GET'])
def admin_avis(id):
    mycursor = get_db().cursor()
    article = []
    commentaires = {}
    return render_template('admin/article/show_avis.html'
                           , article=article
                           , commentaires=commentaires
                           )


@admin_article.route('/admin/comment/delete', methods=['POST'])
def admin_avis_delete():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle', None)
    userId = request.form.get('idUser', None)

    return admin_avis(article_id)
