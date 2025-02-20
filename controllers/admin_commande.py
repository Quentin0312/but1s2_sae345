#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, flash, session

from connexion_db import get_db

admin_commande = Blueprint('admin_commande', __name__,
                        template_folder='templates')

@admin_commande.route('/admin')
@admin_commande.route('/admin/commande/index')
def admin_index():
    return render_template('admin/layout_admin.html')


@admin_commande.route('/admin/commande/show', methods=['get','post'])
def admin_commande_show():
    mycursor = get_db().cursor()
    commande_id = request.args.get('id_commande', None)

    # admin_id = session['id_user']
    # sql = '''SELECT login FROM utilisateur WHERE id_utilisateur = %s ;'''
    # mycursor.execute(sql, (admin_id,))
    # commandes=mycursor.fetchone()
    # print(commandes)
    if commande_id is None:
        articles_commande=[]
    else:
        sql_articles = ''' SELECT m.nom, l.quantite, l.prix, l.prix * l.quantite AS prix_ligne
        FROM ligne_commande l
        JOIN meuble m ON m.id_article= l.article_id
        WHERE l.commande_id=%s
        ORDER BY m.nom;'''
        mycursor.execute(sql_articles,commande_id)
        articles_commande = mycursor.fetchall()
    commande_adresses = None


    sql = ''' SELECT c.id_commande, u.login,c.date_achat,l.quantite AS nbr_articles,c.prix_total_commande,e.libelle_etat
         FROM commande c 
         JOIN utilisateur u ON u.id_utilisateur = c.utilisateur_id 
         JOIN ligne_commande l ON l.commande_id = c.id_commande 
         JOIN etat e ON e.id_etat = c.etat_id
         ORDER BY c.date_achat DESC;
         '''
    mycursor.execute(sql)
    commandes = mycursor.fetchall()
    print(commandes)

    return render_template('admin/commandes/show.html'
                           , commandes=commandes,articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )


@admin_commande.route('/admin/commande/valider', methods=['get','post'])
def admin_commande_valider():
    mycursor = get_db().cursor()
    commande_id = request.form.get('id_commande', None)
    if commande_id != None:
        print(commande_id)
        sql = '''UPDATE commande SET etat_id = 2 WHERE id_commande = %s;'''
        mycursor.execute(sql, (commande_id,))
        get_db().commit()
    return redirect('/admin/commande/show')
