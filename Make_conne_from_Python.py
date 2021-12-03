# Making a connection from Python
# get the following code run:

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

sql = 'DROP TABLE IF EXISTS pythonfun CASCADE;'
print(sql)
cur.execute(sql)

sql = 'CREATE TABLE pythonfun (id SERIAL, line TEXT);'
print(sql)
cur.execute(sql)

conn.commit()    # Flush it all to the DB server

for i in range(10) :
    txt = "Have a nice day "+str(i)
    sql = 'INSERT INTO pythonfun (line) VALUES (%s);'
    cur.execute(sql, (txt, ))

conn.commit()

sql = "SELECT id, line FROM pythonfun WHERE id=5;"
print(sql)
cur.execute(sql)

row = cur.fetchone()
if row is None :
    print('Row not found')
else:
    print('Found', row)

sql = 'INSERT INTO pythonfun (line) VALUES (%s) RETURNING id;'
cur.execute(sql, (txt, ))
id = cur.fetchone()[0]
print('New id', id)

# Lets make a mistake
# sql = "SELECT line FROM pythonfun WHERE mistake=5;"
# print(sql)
# cur.execute(sql)

conn.commit()
cur.close()

########################################################################################
# load hidden.py seperately (to connect to the postgres)

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
