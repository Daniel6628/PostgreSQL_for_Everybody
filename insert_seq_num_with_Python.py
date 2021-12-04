# Write a Python program to insert a sequence of 300 pseudorandom numbers into a database table named pythonseq with the following schema:
# CREATE TABLE pythonseq (iter INTEGER, val INTEGER);

import psycopg2
import hidden

# Load the secrets
secrets = hidden.secrets()

conn = psycopg2.connect(
        host=secrets['host'],
        port=secrets['port'],
        database=secrets['database'],
        user=secrets['user'],
        password=secrets['pass'],
        connect_timeout=3)

cur = conn.cursor()

sql = 'DROP TABLE IF EXISTS pythonseq CASCADE;'
cur.execute(sql)

sql = 'CREATE TABLE pythonseq (iter INTEGER, val INTEGER);'
cur.execute(sql)

# Flush it all to the DB server
conn.commit()

number = 713356
for i in range(300):
    print(i+1, number)
    sql = 'INSERT INTO pythonseq (val) VALUES (%s);'
    cur.execute(sql, (number,))
    number = int((number * 22) / 7) % 1000000

conn.commit()

cur.close()

############################################################
# hidden:

def secrets():
    return {"host": "pg.pg4e.com",
            "port": 5432,
            "database": "pg4e_b5c73b626d",
            "user": "pg4e_b5c73b626d",
            "pass": "pg4e_p_ec576f674389f18"}

def elastic() :
    return {"host": "www.pg4e.com",
            "prefix" : "elasticsearch",
            "port": 443,
            "scheme": "https",
            "user": "pg4e_86f9be92a2",
            "pass": "2008_9d454b1f"}

def readonly():
    return {"host": "pg.pg4e.com",
            "port": 5432,
            "database": "readonly",
            "user": "readonly",
            "pass": "readonly_password"}

def psycopg2(secrets) :
     return ('dbname='+secrets['database']+' user='+secrets['user']+
        ' password='+secrets['pass']+' host='+secrets['host']+
        ' port='+str(secrets['port']))

def alchemy(secrets) :
    return ('postgresql://'+secrets['user']+':'+secrets['pass']+'@'+secrets['host']+
        ':'+str(secrets['port'])+'/'+secrets['database'])
