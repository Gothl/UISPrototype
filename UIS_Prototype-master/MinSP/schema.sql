\i schema_drop.sql

CREATE TABLE IF NOT EXISTS Profiler(
    cpr_nr INTEGER PRIMARY KEY NOT NULL,
    password varchar(120) NOT NULL,
    fornavn varchar NOT NULL,
	efternavn varchar NOT NULL,
	e_mail varchar
);

CREATE TABLE IF NOT EXISTS Proevesvar(
    cpr_nr INTEGER REFERENCES Profiler ON DELETE CASCADE NOT NULL  ,
    proevesvar_id SERIAL PRIMARY KEY NOT NULL,
    dato date NOT NULL,
    afdelings_id INTEGER NOT NULL,
    resultat text NOT NULL
);

CREATE TABLE IF NOT EXISTS Aftaler(
    aftale_id SERIAL PRIMARY KEY NOT NULL,
    cpr_nr INTEGER REFERENCES Profiler ON DELETE CASCADE NOT NULL  ,
    dato date NOT NULL,
    afdelings_id INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Meddelelser(
    dato date NOT NULL,
    medd_id SERIAL PRIMARY KEY NOT NULL,
    cpr_nr INTEGER REFERENCES Profiler ON DELETE CASCADE NOT NULL,
    other_id INTEGER NOT NULL,
    from_profile boolean NOT NULL,
    medd_tekst text NOT NULL
);

CREATE TABLE IF NOT EXISTS Journalnotater(
    cpr_nr INTEGER REFERENCES profiler ON DELETE CASCADE NOT NULL  ,
    notat_id SERIAL PRIMARY KEY NOT NULL,
    notat text NOT NULL
);

CREATE TABLE IF NOT EXISTS Diagnoser_allergier(
    diagnose_id SERIAL PRIMARY KEY NOT NULL,
    cpr_nr INTEGER REFERENCES profiler ON DELETE CASCADE NOT NULL,
    dato date NOT NULL,
    indsigelse boolean default false NOT NULL,
    diagnose_allergi_navn text NOT NULL
);

CREATE TABLE IF NOT EXISTS Indsigelser(
    --indsigelses_id SERIAL NOT NULL,
    diagnose_id INTEGER PRIMARY KEY REFERENCES diagnoser_allergier ON DELETE CASCADE NOT NULL  ,
    dato date NOT NULL,
    indsigelses_tekst text NOT NULL
);
