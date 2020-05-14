# write all your SQL queries in this file.
from datetime import datetime
from bank import conn, login_manager    # import conn and login_manager from _init_.py | conn is db connection | login_manager is an instance which holds settings for logging in.
#from __init__ import conn, login_manager   # <-- Only for in-editor debugging. For our own understanding. run.py will not
                                            # run with this line, but uncommenting it and outcommenting the one above
                                            # may reduce som errors in the editor and produce pop-up/hover tips for
                                            # otherwise unknown bits of code.
from flask_login import UserMixin           # UserMixin holds methods/functions that can be used with/on user objects like Customers and Employeees.
from psycopg2 import sql                    # A module that contains objects and functions useful to generate SQL dynamically, in a convenient and safe way.

@login_manager.user_loader
def load_user(user_id):
    cur = conn.cursor()

    schema = 'customers'                # assuming that the user_id belongs to a customer, to start with
    id = 'cpr_number'                   # id of the customer will be the 'cpr_number' key attribute
    if str(user_id).startswith('60'):   # if user_id starts with '60' then it's an employees, logging in.
        schema = 'employees'            # change to patients schema
        id = 'id'                       # can still be id, but cpr would be more descriptive/accurate.

    # user_sql = SELECT * FROM 'customers/employees' WHERE 'cpr_number' = %s
    # the triple-quotes are a way to allow the query to be written using multiple lines. With single-quotes the query needs to be on one line.
    user_sql = sql.SQL("""
    SELECT * FROM {}
    WHERE {} = %s
    """).format(sql.Identifier(schema),  sql.Identifier(id))

    # execute the sql query stored in 'user_sql' above with user_id in int form as argument (%s)
    cur.execute(user_sql, (int(user_id),))
    if cur.rowcount > 0:                        # if the query returns at least one row.
        # return an Employee (se class below) if schema=='employees' else return a customer.
        # fetchone returns the next row of the result
        return Employees(cur.fetchone()) if schema == 'employees' else Customers(cur.fetchone())
    else:
        return None                             # if the command returns 0 rows.


class Customers(tuple, UserMixin):              # class Customer takes a tuple (a row from a query result), and the UserMixin funcs.
    def __init__(self, user_data):              #  __init__ func in start of a class in python works as the constructor, as we know it from OOP.
                                                # So, whatever is given by 'tuple' will be put intp user_data (here it is the aforementioned row from the result).
        self.CPR_number = user_data[0]          # Costumer.CPR_number = user_data[0] //= value of the 1st attribute
        self.risktype = False
        self.password = user_data[2]            # Same deal as with CPR_number...    //= value of the 2nd attribute
        self.name = user_data[3]                # etc....
        self.address = user_data[4]

    def get_id(self):                           # defines/overrides a get func that returns the customer's cpr_number
       return (self.CPR_number)

class Employees(tuple, UserMixin):              # same process - instantiating an Employee
    def __init__(self, employee_data):
        self.id = employee_data[0]
        self.name = employee_data[1]
        self.password = employee_data[2]

    def get_id(self):
       return (self.id)

class CheckingAccount(tuple):                   # same process - instantiating a CheckingAccount
    def __init__(self, user_data):
        self.id = user_data[0]
        self.create_date = user_data[1]
        self.CPR_number = user_data[2]
        self.amount = 0

class InvestmentAccount(tuple):                 # same proces - instantiating an InvestmentAccount
    def __init__(self, user_data):
        self.id = user_data[0]
        self.start_date = user_data[1]
        self.maturity_date = user_data[2]
        self.amount = 0

class Transfers(tuple):                         # same proces - instantiating a Transfer
    def __init__(self, user_data):
        self.id = user_data[0]
        self.amount = user_data[1]
        self.transfer_date = user_data[2]

def insert_Customers(name, CPR_number, password):   # inserts a Customer with values of name, CPR_number, password into the Customers table
    cur = conn.cursor()                             # creates a cursor for the execution of the following sql query
    sql = """
    INSERT INTO Customers(name, CPR_number, password)
    VALUES (%s, %s, %s)
    """
    cur.execute(sql, (name, CPR_number, password))  # executing the query 'sql'
    conn.commit()                                   # commit() commits any pending transactions to the db. Without it changes would be lost.
    cur.close()                                     # closes the cursor, making it unusable from this point on.

def select_Customers(CPR_number):                   # selects a specific Customer, based on their cpr-number
    cur = conn.cursor()                             # same process, except...
    sql = """
    SELECT * FROM Customers
    WHERE CPR_number = %s
    """
    cur.execute(sql, (CPR_number,))                 # ... after execution the changes are not committed, but instead used in the statement below
    user = Customers(cur.fetchone()) if cur.rowcount > 0 else None;     # sets 'user' to the customer matching the cpr-number (if any), else user = None.
    cur.close()
    return user                                     # this is self-explanatory

def select_Employees(id):                           # selects an Employee in the exact same way as with Customer above.
    cur = conn.cursor()
    sql = """
    SELECT * FROM Employees
    WHERE id = %s
    """
    cur.execute(sql, (id,))
    user = Employees(cur.fetchone()) if cur.rowcount > 0 else None;
    cur.close()
    return user

def update_CheckingAccount(amount, CPR_number):     # updates the amount in a CheckingAccount - same process as with insert_customers()
    cur = conn.cursor()
    sql = """
    UPDATE CheckingAccount
    SET amount = %s
    WHERE CPR_number = %s
    """ 
    cur.execute(sql, (amount, CPR_number))
    conn.commit()
    cur.close()
    
def transfer_account(date, amount, from_account, to_account):   # inserts transfer into Transfers - same process as with insert_customers()
    cur = conn.cursor()
    sql = """
    INSERT INTO Transfers(transfer_date, amount, from_account, to_account)
    VALUES (%s, %s, %s, %s)
    """
    cur.execute(sql, (date, amount, from_account, to_account))
    conn.commit()
    cur.close()

                                                                # These last ones produce relations
def select_emp_cus_accounts(emp_cpr_number):
    cur = conn.cursor()
    sql = """
    SELECT
      e.name employee
    , c.name customer 
    , cpr_number
    , account_number 
    FROM manages m
      NATURAL JOIN accounts  
      NATURAL JOIN customers c
      JOIN employees e ON m.emp_cpr_number = e.id
	WHERE emp_cpr_number = %s 
    ;
    """
    cur.execute(sql, (emp_cpr_number,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset

def select_investments(CPR_number):
    cur = conn.cursor()
    sql = """
    SELECT i.account_number, a.cpr_number, a.created_date 
    FROM investmentaccounts i
    JOIN accounts a ON i.account_number = a.account_number    
    WHERE a.cpr_number = %s
    """
    cur.execute(sql, (CPR_number,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset

def select_investments_with_certificates(CPR_number):
    cur = conn.cursor()
    sql = """
    SELECT i.account_number, a.cpr_number, a.created_date
    , cd.cd_number, start_date, maturity_date, rate, amount 
    FROM investmentaccounts i
    JOIN accounts a ON i.account_number = a.account_number
    JOIN certificates_of_deposit cd ON i.account_number = cd.account_number    
    WHERE a.cpr_number = %s
    """
    cur.execute(sql, (CPR_number,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset

def select_investments_certificates_sum(CPR_number):
    print(CPR_number)
    cur = conn.cursor()
    sql = """
    SELECT account_number, cpr_number, created_date, sum
    FROM vw_cd_sum
    WHERE cpr_number = %s
    """
    cur.execute(sql, (CPR_number,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset
