#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

admin_dataviz = Blueprint('admin_dataviz', __name__,
                          template_folder='templates')


@admin_dataviz.route('/admin/dataviz/etat1')
def show_type_article_stock():
    mycursor = get_db().cursor()
    # Tableau
    # sql = '''
    # SELECT tm.libelle_type                                   AS type_meuble,
    #        COUNT(DISTINCT n.id_meuble, n.id_utilisateur)     AS nombre_notes,
    #        ROUND(AVG(n.note), 1)                             AS note_moyenne,
    #        COUNT(DISTINCT c.commentaire, c.date_publication) AS nombre_commentaires
    # FROM type_meuble tm
    #          LEFT JOIN meuble m ON m.type_meuble_id = tm.id_type
    #          LEFT JOIN note n ON n.id_meuble = m.id_article
    #          LEFT JOIN commentaire c ON c.id_article = m.id_article
    # GROUP BY tm.libelle_type
    # ORDER BY tm.libelle_type;
    # '''
    # mycursor.execute(sql)
    # types_articles_nb = mycursor.fetchall()

    sql = '''
    SELECT SUM(stock) as total_article
    FROM meuble;
    '''
    mycursor.execute(sql)
    total_articles = mycursor.fetchone()

    # GRAPHIQUE 1
    sql = '''
    SELECT tm.libelle_type, COALESCE(ROUND(AVG(note), 1),0) AS note_moyenne
    FROM type_meuble tm
             LEFT JOIN meuble m ON tm.id_type = m.type_meuble_id
             LEFT JOIN note n ON n.id_meuble = m.id_article
    GROUP BY tm.libelle_type
    ORDER BY tm.libelle_type;
           '''
    mycursor.execute(sql)
    datas = mycursor.fetchall()
    labels = [str(row['libelle_type']) for row in datas]
    values = [float(row['note_moyenne']) for row in datas]

    # GRAPHIQUE 2
    sql = '''
    SELECT tm.libelle_type, COUNT(c.commentaire) AS nb_commentaire
    FROM type_meuble tm
             LEFT JOIN meuble m ON tm.id_type = m.type_meuble_id
             LEFT JOIN commentaire c ON c.id_article = m.id_article
    GROUP BY tm.libelle_type
    ORDER BY tm.libelle_type;
    '''
    mycursor.execute(sql)
    datas = mycursor.fetchall()
    labels2 = [str(row['libelle_type']) for row in datas]
    values2 = [int(row['nb_commentaire']) for row in datas]

    # GRAPHIQUE 3
    sql = '''
    SELECT tm.libelle_type, COUNT(note) AS nombre_notes
    FROM type_meuble tm
             LEFT JOIN meuble m ON tm.id_type = m.type_meuble_id
             LEFT JOIN note n ON n.id_meuble = m.id_article
    GROUP BY tm.libelle_type
    ORDER BY tm.libelle_type;
    '''
    mycursor.execute(sql)
    datas = mycursor.fetchall()
    labels3 = [str(row['libelle_type']) for row in datas]
    values3 = [int(row['nombre_notes']) for row in datas]

    return render_template('admin/dataviz/dataviz_etat_1.html'
                           # , datas_show=datas_show
                           , labels=labels, labels2=labels2, labels3=labels3
                           , values=values, values2=values2, values3=values3
                           # , types_articles_nb=types_articles_nb
                           , total_articles=total_articles)


# sujet 3 : adresses


@admin_dataviz.route('/admin/dataviz/etat2')
def show_dataviz_map():
    # mycursor = get_db().cursor()
    # sql = '''    '''
    # mycursor.execute(sql)
    # adresses = mycursor.fetchall()

    # exemples de tableau "résultat" de la requête
    adresses = [{'dep': '25', 'nombre': 1}, {'dep': '83', 'nombre': 1}, {'dep': '90', 'nombre': 3}]

    # recherche de la valeur maxi "nombre" dans les départements
    # maxAddress = 0
    # for element in adresses:
    #     if element['nbr_dept'] > maxAddress:
    #         maxAddress = element['nbr_dept']
    # calcul d'un coefficient de 0 à 1 pour chaque département
    # if maxAddress != 0:
    #     for element in adresses:
    #         indice = element['nbr_dept'] / maxAddress
    #         element['indice'] = round(indice,2)

    print(adresses)

    return render_template('admin/dataviz/dataviz_etat_map.html'
                           , adresses=adresses
                           )
