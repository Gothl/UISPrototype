\i schema_drop.sql

CREATE TABLE IF NOT EXISTS Profiler(
    cpr_nr INTEGER PRIMARY KEY,
    password varchar(120),
    fornavn varchar,
	efternavn varchar,
	e_mail varchar
);

CREATE TABLE IF NOT EXISTS Proevesvar(
    cpr_nr INTEGER REFERENCES Profiler(cpr_nr),
    proevesvar_id SERIAL PRIMARY KEY,
    dato date,
    afdelings_id INTEGER,
    resultat text
);

CREATE TABLE IF NOT EXISTS Aftaler(
    aftale_id SERIAL PRIMARY KEY,
    cpr_nummer INTEGER REFERENCES Profiler(cpr_nr),
    dato date,
    afdelings_id INTEGER
);

CREATE TABLE IF NOT EXISTS Meddelelser(
    dato date,
    medd_id SERIAL PRIMARY KEY,
    afsender INTEGER,
    modtager INTEGER,
    medd_tekst text
);

CREATE TABLE IF NOT EXISTS Journalnotater(
    cpr_nr INTEGER REFERENCES profiler(cpr_nr),
    notat_id SERIAL PRIMARY KEY,
    notat text
);

CREATE TABLE IF NOT EXISTS Diagnoser_allergier(
    diagnose_id SERIAL PRIMARY KEY,
    cpr_nr INTEGER REFERENCES profiler(cpr_nr),
    dato date,
    indsigelse boolean default false,
    diagnose_allergi_navn text
);

CREATE TABLE IF NOT EXISTS Indsigelser(
    --indsigelses_id SERIAL,
    diagnose_id INTEGER PRIMARY KEY REFERENCES diagnoser_allergier(diagnose_id),
    dato date,
    indsigelses_tekst text
);
