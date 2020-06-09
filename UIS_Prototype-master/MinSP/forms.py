from flask_wtf import FlaskForm
from wtforms import PasswordField, SubmitField, BooleanField, IntegerField, SelectField, TextAreaField
from wtforms.validators import DataRequired, Length
class ProfilLoginForm(FlaskForm):
    id = IntegerField('cpr_nr', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Husk mig')
    submit = SubmitField('Log in')

class IndsigelsesForm(FlaskForm):
    diagnose = SelectField('Diagnose:', choices=[], coerce = int, validators=[DataRequired()])
    indsigelsestekst = TextAreaField('Beskriv hvorfor diagnosen er fejlagtig:', validators=[DataRequired(), Length(min=2, max=500)])
    submit = SubmitField('Indsend')
