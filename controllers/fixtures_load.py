#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import *
import datetime
from decimal import *
from connexion_db import get_db

fixtures_load = Blueprint('fixtures_load', __name__,
                          template_folder='templates')


@fixtures_load.route('/base/init')
def fct_fixtures_load():
    mycursor = get_db().cursor()

    with open("sae_sql.sql","r") as full_sql :
        full_sql = full_sql.read()
        print(full_sql)
    for sql in full_sql.split(';'):
        if sql.strip() != '':
            mycursor.execute(sql)
    get_db().commit()
    return redirect('/')
