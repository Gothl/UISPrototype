from flask import render_template, url_for, flash, redirect, request, Blueprint
from bank import app, conn, bcrypt
from bank.forms import DepositForm, InvestForm
from flask_login import current_user
from bank.models import CheckingAccount, InvestmentAccount, update_CheckingAccount
from bank.models import select_investments_with_certificates, select_investments, select_investments_certificates_sum, select_diagnoser, select_indsigelser
import sys, datetime
from bank.models import Indsigelser, update_indsigelse

Profil = Blueprint('Profil', __name__)

@Profil.route("/diagnoser", methods=['GET', 'POST'])
def diagnoser():
    if not current_user.is_authenticated:
        flash('Please Login.','danger')
        return redirect(url_for('Login.login'))
    #form = InvestForm()
    #investments = select_investments(current_user.CPR_number)
    investment_certificates = select_investments_with_certificates(current_user.get_id())
    investment_sums = select_investments_certificates_sum(current_user.get_id())
    diagnoser_allergier = select_diagnoser(current_user.get_id())
    indsigelser = select_indsigelser(current_user.get_id())
    #indsigelser = opret_indsigelse(current_user.get_id())
    return render_template('diagnoser.html', title='Diagnoser', inv_cd_list=investment_certificates
    , inv_sums=investment_sums, diagnoser=diagnoser_allergier, inds=indsigelser)


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

@Profil.route("/Håndtér indsigelse", methods=['GET', 'POST'])
def handterIndsigelse():
    if not current_user.is_authenticated:
        flash('Please Login.','danger')
        return redirect(url_for('Login.login'))
    form = TransferForm()
    if form.validate_on_submit():
        indsigelse=form.indsigelse.data
        cur = conn.cursor()
        sql = """
        UPDATE Indsigelse
        SET Indsigelse = %s
        WHERE CPR_number = %s
        """ 
        cur.execute(sql, (diagnose_id, CPR_number))
        conn.commit()
        cur.close()
        flash('Transfer succeed!', 'success')
        return redirect(url_for('Login.home'))
    return render_template('transfer.html', title='Transfer', form=form)
