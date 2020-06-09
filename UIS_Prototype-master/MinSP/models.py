# write all your SQL queries in this file.
from datetime import datetime
from MinSP import conn, login_manager    # import conn and login_manager from _init_.py | conn is db connection | login_manager is an instance which holds settings for logging in.
#from __init__ import conn, login_manager   # <-- Only for in-editor debugging. For our own understanding. run.py will not
                                            # run with this line, but uncommenting it and outcommenting the one above
                                            # may reduce som errors in the editor and produce pop-up/hover tips for
                                            # otherwise unknown bits of code.
from flask_login import UserMixin           # UserMixin holds methods/functions that can be used with/on user objects like Customers and Employeees.
from psycopg2 import sql                    # A module that contains objects and functions useful to generate SQL dynamically, in a convenient and safe way.

@login_manager.user_loader
def load_user(user_id):
    cur = conn.cursor()

    schema = 'profiler'                # assuming that the user_id belongs to a customer, to start with
    id = 'cpr_nr'                   # id of the customer will be the 'cpr_number' key attribute

    # the triple-quotes are a way to allow the query to be written using multiple lines. With single-quotes the query needs to be on one line.
    user_sql = sql.SQL("""
    SELECT * FROM {}
    WHERE {} = %s
    """).format(sql.Identifier(schema),  sql.Identifier(id))

    # execute the sql query stored in 'user_sql' above with user_id in int form as argument (%s)
    cur.execute(user_sql, (int(user_id),))
    if cur.rowcount > 0:                        # if the query returns at least one row.
        # fetchone returns the next row of the result
        return Profiler(cur.fetchone())
    else:
        return None                             # if the command returns 0 rows.

class Profiler(tuple, UserMixin):
    def __init__(self, user_data):
        self.cpr_nr = user_data[0]
        self.password = user_data[1]
        self.fornavn = user_data[2]
        self.efternavn = user_data[3]
        self.mail = user_data[4]

    def get_id(self):                           # defines/overrides a get func that returns the customer's cpr_number
       return (self.cpr_nr)

class Diagnoser_allergier(tuple):
    def __init__(self, user_data):
        self.diagnose_id = user_data[0]
        self.cpr_nr = user_data[1]
        self.dato = user_data[2]
        self.indsigelse = user_data[3]
        self.diagnose_allergi_navn = user_data[4]

class Indsigelser(tuple):
    def __init__(self, user_data):
        self.indsigelses_id = user_data[0]
        self.diagnose_id = user_data[1]
        self.dato = user_data[2]
        self.indsigelses_tekst = user_data[3]

def opret_indsigelse(indsigelses_id, diagnose_id, dato, indsigelses_tekst):
    cur = conn.cursor()
    sql = """
    INSERT INTO Indsigelser(indsigelses_id, diagnose_id, dato, indsigelses_tekst)
    VALUES (%s, %s, %s, %s)
    """
    cur.execute(sql, (indsigelses_id, diagnose_id, dato, indsigelses_tekst))  # executing the query 'sql'
    conn.commit()                                   # commit() commits any pending transactions to the db. Without it changes would be lost.
    cur.close()

def select_Profiler(cpr_nr):                        # selects a specific Profile, based on their cpr-number
    cur = conn.cursor()                             # same process, except...
    sql = """
    SELECT * FROM Profiler
    WHERE cpr_nr = %s
    """
    cur.execute(sql, (cpr_nr,))                 # ... after execution the changes are not committed, but instead used in the statement below
    user = Profiler(cur.fetchone()) if cur.rowcount > 0 else None;     # sets 'user' to the customer matching the cpr-number (if any), else user = None.
    cur.close()
    return user                                     # this is self-explanatory

def select_diagnoser(cpr_nr):
    cur = conn.cursor()
    sql = """
    SELECT d.diagnose_id, d.dato, d.diagnose_allergi_navn, d.indsigelse
    FROM diagnoser_allergier d
    JOIN profiler p ON d.cpr_nr = p.cpr_nr
    WHERE d.cpr_nr = %s
    ORDER BY d.dato
    """
    cur.execute(sql, (cpr_nr,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset

def select_indsigelser(cpr_nr):
    cur = conn.cursor()
    sql = """
    SELECT i.dato, d.diagnose_allergi_navn, i.indsigelses_tekst
    FROM diagnoser_allergier d
    JOIN profiler p ON d.cpr_nr = p.cpr_nr
    JOIN indsigelser i ON d.diagnose_id = i.diagnose_id
    WHERE d.cpr_nr = %s
    ORDER BY i.dato
    """
    cur.execute(sql, (cpr_nr,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset

#indsigelses_id er ikke nok, da disse bliver dynamisk oprettet ved hver insert (vi vil derfor aldrig komme til at opdatere en indsigelse)
#Hvis vi sætter p_key til diagnose_id vil der altid kun være en indsigelse pr. diagnose ad gangen) <- did this, which fixed it.
#Hvis versionering ønskes kan p_key ændres til den udkommenterede attribut "indsigelses_id" og "ON CONFLICT"-delen kan udelades.
def update_indsigelser(diagnoseid, indsigelsesdato, text):
    cur = conn.cursor()
    sql ="""
    INSERT INTO indsigelser (diagnose_id, dato, indsigelses_tekst) 
    VALUES (%s, %s, %s)
    ON CONFLICT (diagnose_id) DO 
    UPDATE SET dato = excluded.dato, indsigelses_tekst = excluded.indsigelses_tekst; 
    """
    cur.execute(sql, (diagnoseid, indsigelsesdato, text))  #excluded refers to rows that created a conflict (here with indsigelses_id) when we tried to insert them.
    conn.commit()
    cur.close()

def set_indsigelse_true(cpr_nr, diagnoseid):
    cur = conn.cursor()
    sql = """
    UPDATE diagnoser_allergier 
    SET indsigelse = TRUE
    WHERE cpr_nr = %s AND diagnose_id = %s;
    """
    cur.execute(sql, (cpr_nr, diagnoseid))
    conn.commit()
    cur.close()

def set_indsigelse_false(cpr_nr, diagnoseid):
    cur = conn.cursor()
    sql = """
    UPDATE diagnoser_allergier 
    SET indsigelse = FALSE
    WHERE cpr_nr = %s AND diagnose_id = %s;
    """
    cur.execute(sql, (cpr_nr, diagnoseid))
    conn.commit()
    cur.close()
