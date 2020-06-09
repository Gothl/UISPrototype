from flask import render_template, url_for, flash, redirect, request, Blueprint
from MinSP import app, conn, bcrypt
from MinSP.forms import IndsigelsesForm
from flask_login import current_user
from MinSP.models import select_diagnoser, select_indsigelser, Indsigelser, update_indsigelser, set_indsigelse_true
import sys, datetime

Profil = Blueprint('Profil', __name__)

@Profil.route("/diagnoser", methods=['GET', 'POST'])
def diagnoser():
    if not current_user.is_authenticated:
        flash('Log venligst ind.','danger')
        return redirect(url_for('Login.login'))
    diagnoser_allergier = select_diagnoser(current_user.get_id())
    indsigelser = select_indsigelser(current_user.get_id())
    return render_template('diagnoser.html', title='Diagnoser', diagnoser=diagnoser_allergier, inds=indsigelser)

@Profil.route("/insigelse", methods=['GET', 'POST'])
def indsigelse():
    if not current_user.is_authenticated:
        flash('Log venligst ind.','danger')
        return redirect(url_for('Login.login'))
    CPR_number = current_user.get_id()
    print(CPR_number)
    dropdown_diagnoser = select_diagnoser(current_user.get_id())
    drp_diagnoser = []
    for drp in dropdown_diagnoser:
        drp_diagnoser.append((drp[0], drp[2]))
    print(drp_diagnoser)
    form = IndsigelsesForm()
    form.diagnose.choices = drp_diagnoser
    if form.validate_on_submit():
        diagnoseid = form.diagnose.data
        date = datetime.date.today()
        tekst = form.indsigelsestekst.data
        update_indsigelser(diagnoseid, date, tekst)
        set_indsigelse_true(current_user.get_id(), diagnoseid)
        flash('Indsigelse oprettet!', 'success')
        return redirect(url_for('Profil.diagnoser'))
    return render_template('indsigelse.html', title='Indsigelse', drop_diagnoser=dropdown_diagnoser, form=form)
