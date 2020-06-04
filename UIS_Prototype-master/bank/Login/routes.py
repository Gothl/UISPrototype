from flask import render_template, url_for, flash, redirect, request, Blueprint
from bank import app, conn, bcrypt
from bank.forms import ProfilLoginForm, EmployeeLoginForm, CustomerLoginForm
from flask_login import login_user, current_user, logout_user, login_required
from bank.models import Profiler, Customers, select_Profiler, select_Employees, select_Customers

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
    #is_employee = True if request.args.get('is_employee') == 'true' else False
    #form = EmployeeLoginForm() if is_employee else CustomerLoginForm() #ProfilLoginForm()
    #form = CustomerLoginForm() #ProfilLoginForm()
    form = ProfilLoginForm()
    if form.validate_on_submit():
       # user = select_Profiler(form.id.data)
        #user = select_Employees(form.id.data) if is_employee else select_Customers(form.id.data) #Profiler(form.id.data)
        #user = select_Customers(form.id.data) #Profiler(form.id.data)
        user = select_Profiler(form.id.data)
        if user != None and bcrypt.check_password_hash(user[1], form.password.data):
            login_user(user, remember=form.remember.data)
            flash('Log ind var successfuldt.','success')
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('Login.home'))
        else:
            flash('Kunne ikke logge ind. Tjek venligst cpr-nummer og kodeord.', 'danger')
    #return render_template('login.html', title='Login', is_employee=is_employee, form=form)
    return render_template('login.html', title='Login', form=form)


@Login.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('Login.home'))


@Login.route("/account")
@login_required
def account():
    return render_template('account.html', title='Account')
