from flask import render_template, url_for, flash, redirect, request, Blueprint
from bank import app, conn, bcrypt
from bank.forms import DepositForm, InvestForm, IndsigelsesForm
from flask_login import current_user
from bank.models import CheckingAccount, InvestmentAccount, update_CheckingAccount
from bank.models import select_investments_with_certificates, select_investments, select_investments_certificates_sum, select_diagnoser, select_indsigelser
import sys, datetime
from bank.models import Indsigelser, update_indsigelser, set_indsigelse_true

Profil = Blueprint('Profil', __name__)

@Profil.route("/diagnoser", methods=['GET', 'POST'])
def diagnoser():
    if not current_user.is_authenticated:
        flash('Please Login.','danger')
        return redirect(url_for('Login.login'))
    #form = InvestForm()
    #investments = select_investments(current_user.CPR_number)
    #investment_certificates = select_investments_with_certificates(current_user.get_id())
    #investment_sums = select_investments_certificates_sum(current_user.get_id())
    diagnoser_allergier = select_diagnoser(current_user.get_id())
    indsigelser = select_indsigelser(current_user.get_id())
    indsigelsesform = IndsigelsesForm()
    if indsigelsesform.validate_on_submit():
        indsigelsestekst = indsigelsesform.indsigelsestekst.data
        ny_indsigelse = update_indsigelser(diagnoseid, now(), indsigelsestekst)

    return render_template('diagnoser.html', title='Diagnoser', diagnoser=diagnoser_allergier, inds=indsigelser, nyins=ny_indsigelse) #inv_cd_list=investment_certificates  , inv_sums=investment_sums,


# @Profil.route("/deposit", methods=['GET', 'POST'])
# def deposit():
#     if not current_user.is_authenticated:
#         flash('Please Login.','danger')
#         return redirect(url_for('Login.login'))
#     form = DepositForm()
#     if form.validate_on_submit():
#         amount=form.amount.data
#         CPR_number = form.CPR_number.data
#         update_CheckingAccount(amount, CPR_number)
#         flash('Succeed!', 'success')
#         return redirect(url_for('Login.home'))
#     return render_template('deposit.html', title='Deposit', form=form)

@Profil.route("/summary", methods=['GET', 'POST'])
def summary():
    if not current_user.is_authenticated:
        flash('Please Login.','danger')
        return redirect(url_for('Login.login'))
    if form.validate_on_submit():
        pass
        flash('Succeed!', 'success')
        return redirect(url_for('Login.home'))
    return render_template('deposit.html', title='Deposit', form=form)

@Profil.route("/insigelse", methods=['GET', 'POST'])
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
        update_indsigelser(diagnoseid, date, tekst) #update_indsigelser(diagnose_id, dato, tekst) og set_indsigelse_true(cpr_nr, diagnose-id)
        set_indsigelse_true(current_user.get_id(), diagnoseid)
        flash('Indsigelse oprettet!', 'success')
        return redirect(url_for('Login.home'))
    return render_template('indsigelse.html', title='Indsigelse', drop_cus_acc=dropdown_diagnoser, form=form)
