from flask import render_template, url_for, flash, redirect, request, Blueprint
from bank import app, conn, bcrypt
from bank.forms import TransferForm, DepositForm, AddCustomerForm
from flask_login import current_user
from bank.models import Transfers, CheckingAccount, InvestmentAccount, select_emp_cus_accounts, transfer_account, insert_Customers
import sys, datetime

Employee = Blueprint('Employee', __name__)

@Employee.route("/addcustomer", methods=['GET', 'POST'])
def addcustomer():
    #if current_user.is_authenticated:
    #    return redirect(url_for('Login.home'))
    form = AddCustomerForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        name=form.username.data
        CPR_number=form.CPR_number.data
        password=hashed_password
        insert_Customers(name, CPR_number, password)
        flash('Account has been created! The customer is now able to log in', 'success')
        return redirect(url_for('Login.home'))
    return render_template('addcustomer.html', title='Add Customer', form=form)


@Employee.route("/manageCustomer", methods=['GET', 'POST'])
def manageCustomer():
    if not current_user.is_authenticated:
        flash('Please Login.','danger')
        return redirect(url_for('Login.login'))
    form = TransferForm()
    if form.validate_on_submit():
        amount=form.amount.data
        cur = conn.cursor()
        sql = """
        UPDATE CheckingAccount
        SET amount = %s
        WHERE CPR_number = %s
        """ 
        cur.execute(sql, (amount, CPR_number))
        conn.commit()
        cur.close()
        flash('Transfer succeed!', 'success')
        return redirect(url_for('Login.home'))
    return render_template('transfer.html', title='Transfer', form=form)


@Employee.route("/transfer", methods=['GET', 'POST'])
def transfer():
    if not current_user.is_authenticated:
        flash('Please Login.','danger')
        return redirect(url_for('Login.login'))
    CPR_number = current_user.get_id()
    print(CPR_number)
    dropdown_accounts = select_emp_cus_accounts(current_user.get_id()) #select_diagnoser
    drp_accounts = []
    for drp in dropdown_accounts:
        drp_accounts.append((drp[3], drp[1]+' '+str(drp[3])))
    print(drp_accounts)
    form = TransferForm()
    form.sourceAccount.choices = drp_accounts    
    form.targetAccount.choices = drp_accounts    
    if form.validate_on_submit():
        date = datetime.date.today()
        amount = form.amount.data
        from_account = form.sourceAccount.data
        to_account = form.targetAccount.data
        transfer_account(date, amount, from_account, to_account) #update_indsigelser og set_indsigelse_true
        flash('Transfer succeed!', 'success')
        return redirect(url_for('Login.home'))
    return render_template('transfer.html', title='Transfer', drop_cus_acc=dropdown_accounts, form=form)

#select_diagnoser, update_indsigelser, set_indsigelse_true
@Employee.route("/insigelse", methods=['GET', 'POST'])
def opret_indsigelse():
    if not current_user.is_authenticated:
        flash('Log venligst ind.','danger')
        return redirect(url_for('Login.login'))
    CPR_number = current_user.get_id()
    print(CPR_number)
    dropdown_diagnoser = select_diagnoser(current_user.get_id()) #select_diagnoser(cpr_nr)= {diagnose_id,  dato, diagnosenavn, indsigelsesbool}
    drp_diagnoser = []
    for drp in dropdown_diagnoser:
        drp_diagnoser.append((drp[0], drp[2]+' '+str(drp[0])))
    print(drp_diagnoser)
    form = IndsigelsesForm()
    form.diagnose.choices = drp_diagnoser
    if form.validate_on_submit():
        diagnoseid = form.diagnose.data
        date = datetime.date.today()
        tekst = form.indsigelsestekst.data
        update_indsigelser(diagnoseid, date, tekst) #transfer_account(date, amount, from_account, to_account) #update_indsigelser(diagnose_id, dato, tekst) og set_indsigelse_true(cpr_nr, diagnose-id)
        flash('Indsigelse oprettet!', 'success')
        return redirect(url_for('Login.home'))
    return render_template('indsigelse.html', title='Indsigelse', drop_cus_acc=dropdown_diagnoser, form=form)
