# UIS Prototype
This is the shared repo for the UIS group project prototype.

Nedenfor har jeg lavet en lille guide til at få os i gang. 

Jeg ændringer muligvis løbende i denne i takt med at vores repo ændrer sig.


##  How-to: Pulling og kørsel af vores database:
Oprettelse eller ændring af tabeller (schemas) (f.eks. tabellen patienter) foregår 
i filen schema.sql. Filen schema.sql opretter tomme tabeller, så det er nødvendigt 
at køre schema_ins.sql herefter, da det er denne, der indsætter data i tabellerne.

---

For at ændringerne, som du har pullet fra github, kan træde i kraft, 
skal filerne schema.sql og derefter schema_ins.sql derfor køres igen.

---
####Sådan gør du (på linux i hvert fald):

Klon git-repo'et til en lokal mappe på din computer (hvis du ikke allerede har gjort det).

Gå til din klonede UIS_prototype-master/bank mappe i terminalen. 

Fetch og pull de seneste ændringer fra github.

Kør herefter følgende (hvor <username> self. erstattes af dit brugernavn):

>psql -d bank -U \<username> -f schema.sql 

for at oprette tabellerne/skemaerne, efterfulgt af 

>psql -d bank -U \<username> -f schema_ins.sql 

for at udfylde dem med data.

---
######Tjek ændringerne i pgAdmin, ELLER i terminalen ved først at logge ind på bank databasen med kommandoen:

>psql -d bank -U \<username> 

For at tjekke ændringerne fra github nu også er implementeret i din kopi af databasen, 
kan du f.eks. herefter indtaste et PostgreSQL statement i stil med 

>SELECT * FROM accounts;  
>//(i tilfælde af at ændringen var i accounts)

i bank ( dvs.: bank=# SELECT * FROM accounts;).

######Tjek ændringer i hjemmesiden
Kør 
>python\<versionsnr.> run.py

i UIS_prototype-master mappen i terminalen for at starte flask og serveren med hjemmesiden op.
Når denne kører bør hjemmeseiden kunne indlæses fra din browser.

Det kan være nødvendigt at gennemtvinge refresh af din browsers cache for siden (f.esk. hvis farver o.lign. ikke opdateres).
I google chrome gøres dette med CTRL + F5.

---
Desuden er følgende psql commandoer handy:
>\c \<dbname> //Skifter forbindelse til databasen <dbname>.
>
>\l //Liste over tilgængelige databaser
>
>\dt //Liste over alle databasens tabeller.
>
>\dv //Liste over alle databasens views.
>
>\g //Udfør den sidst udførte kommando igen.
>
>\s //Vis kommando-historikken.
>
>\s \<filename> //Gem kommando-historikken i en fil specificeret ved \<filename>. F.eks.:\s historik.txt
>
>\? //Vis alle tilgængelige psql kommandoer.
>
>\e //Åbner en editor, som du kan skrive psql kommandoer i. 
> Når du er færdig med at skrive kommandoerne, gemmer du 
> filen, og så kører psql sessionen kommandoerne i terminalen.
>
>\q //exit psql. (brug muligvis CTRL + d i stedet).

Der findes desuden en god guide på https://www.postgresqltutorial.com/psql-commands/.



