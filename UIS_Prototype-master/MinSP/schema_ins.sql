DELETE FROM public.profiler;
DELETE FROM public.diagnoser_allergier;
DELETE FROM public.indsigelser;

-- Oprettelse af profil (skal ikke kunne oprettes på hjemmesiden - skal være oprettet på forhånd grundet cpr.)
INSERT INTO public.profiler(cpr_nr, password, fornavn, efternavn, e_mail) VALUES (1234567890, '$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO','Bonnie', 'Byggemand', 'BonnieByg@gmail.com');
INSERT INTO public.profiler(cpr_nr, password, fornavn, efternavn, e_mail) VALUES (1234567891, '$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO', 'Bob', 'Byggemand', 'Bob@byggebob.com');
INSERT INTO public.profiler(cpr_nr, password, fornavn, efternavn, e_mail) VALUES (1234567892, '$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO', 'Britta', 'Bobbelop', 'Britta50@gmail.com');
INSERT INTO public.profiler(cpr_nr, password, fornavn, efternavn, e_mail) VALUES (1234567893, '$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO', 'Ken', 'Plastik', 'kenPlast@gmail.com');
INSERT INTO public.profiler(cpr_nr, password, fornavn, efternavn, e_mail) VALUES (1234567894, '$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO', 'Barbie', 'Plastik', 'BarbieQueeeen@gmail.com');

--Diagnoser
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78903, 1234567890, '2020-05-15', FALSE, 'COVID-19'); --Diagnose_id + cpr =primary key
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78901, 1234567890, '2020-04-01', TRUE, 'Forhøjet blodtryk');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78902, 1234567890, '2020-05-01', FALSE, 'Slidgigt');

INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78911, 1234567891, '2019-03-01', FALSE, 'Grå Stær');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78912, 1234567891, '2020-04-01', TRUE, 'Alkoholisme');

INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78923, 1234567892, '2020-05-02', FALSE, 'Diskusprolaps');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78921, 1234567892, '2018-04-02', FALSE, 'Ledgigt');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78922, 1234567892, '2019-03-01', FALSE, 'Grå stær');

INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78932, 1234567893, '2020-04-01', FALSE, 'Diabetes 2');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78931, 1234567893, '2020-03-01', FALSE, 'Slidgigt');

INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78942, 1234567894, '2020-04-15', FALSE, 'Slidgigt');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78943, 1234567894, '2020-05-15', FALSE, 'COVID-19');
INSERT INTO public.diagnoser_allergier(diagnose_id, cpr_nr, dato, indsigelse, diagnose_allergi_navn) VALUES (78941, 1234567894, '2020-03-15', FALSE, 'Ledgigt');

--Indsigelser
INSERT INTO public.indsigelser(diagnose_id, dato, indsigelses_tekst) VALUES (78901, now(), 'Jeg er uforstående overfor min diagnose - ret venligst dette.');
INSERT INTO public.indsigelser(diagnose_id, dato, indsigelses_tekst) VALUES (78912, now(), 'Jeg er uforstående overfor min diagnose - ret venligst dette.');
