from flask import render_template, url_for, flash, redirect, request, Blueprint
from MinSP import app, conn, bcrypt
from MinSP.forms import ProfilLoginForm
from flask_login import login_user, current_user, logout_user, login_required
from MinSP.models import Profiler, select_Profiler

Login = Blueprint('Login', __name__)

posts = [{}]


@Login.route("/")
@Login.route("/home")
def home():
    return render_template('home.html', posts=posts)


@Login.route("/about")
def about():
    return render_template('about.html', title='About')


@Login.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('Login.home'))
    form = ProfilLoginForm()
    if form.validate_on_submit():
        user = select_Profiler(form.id.data)
        if user != None and bcrypt.check_password_hash(user[1], form.password.data):
            login_user(user, remember=form.remember.data)
            flash('Log ind var successfuldt.','success')
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('Login.home'))
        else:
            flash('Kunne ikke logge ind. Tjek venligst cpr-nummer og kodeord.', 'danger')
    return render_template('login.html', title='Login', form=form)


@Login.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('Login.home'))
