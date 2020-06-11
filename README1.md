# MinSP Prototype

Nedenfor ses en guide til hvordan vores program køres.

## Oprettelse af database:

Opret database der hedder MinSP, dette kan let gøres manuelt i pgadmin. 

## Oprettelse af brugeren uisg:

For at kunne køre prototypen, skal man oprette en bruger 'uisg'. Dette kan gøres i pgadmin, ved at oprette en ny rolle. Dette gøres blot ved at vælge create group/role i højrekliksmenuen i groups/roles i pgadmin. Giv navnet 'uisg' og slå alle privilegier til. Herefter skulle du gerne kunne køre prototypen.

##  Kørsel af vores database:

Oprettelse eller ændring af tabeller (schemas) (f.eks. tabellen patienter) foregår 
i filen schema.sql. Filen schema.sql opretter tomme tabeller, så det er nødvendigt 
at køre schema_ins.sql herefter, da det er denne, der indsætter data i tabellerne.

---
#### Sådan gør du:

Gem opgaven i en lokal mappe på din computer.

Gå til din gemte UIS_prototype-master/MinSP mappe i terminalen. 

Kør herefter følgende:

>psql -d MinSP -U uisg -f schema.sql 

for at oprette tabellerne/skemaerne, efterfulgt af 

>psql -d MinSP -U uisg -f schema_ins.sql 

for at udfylde dem med data.


###### Kør prototypen:

Kør 
>python\<versionsnr.> run.py

i UIS_prototype-master mappen i terminalen for at starte flask og serveren med hjemmesiden op.
Når denne kører bør hjemmesiden kunne indlæses fra din browser.

Hjemmesiden: 
http://127.0.0.1:5000/

Inde på hjemmesiden finder du i toppen en bjælkemenu, hvorfra siden "Om MinSP Prototype" kan tilgås. På denne side finder du information omkring prototypen og hvordan du logger ind.




