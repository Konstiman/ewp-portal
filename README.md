# Studentský portál pro Erasmus Without Paper
*repozitář praktické části bakalářské diplomové práce*

Repozitář obsahuje softwarový návrh a implementaci jednoduchého webového portálu, 
který zobrazuje data veřejně dostupná v projektu Erasmus Without Paper (EWP).

## Instalace a spuštění 

### Požadavky
Doporučeným systémem pro provoz Studentského portálu je linuxový operační systém. 
Portál byl vyvíjen a nasazen na linuxové distribuci Ubuntu ve verzi 18.04.2 LTS, 
tato distribuce je tedy doporučená i pro jeho provoz. Některé kroky instalace vyžadují 
root přístup k systému. Dále jsou vyžadovány tyto technologie (v závorce je vždy 
uvedena doporučená verze):

*  Perl 5 (5.26)
*  cpan (2.26)
*  MySQL (5.7.26)

V MySQL databázi je vyžadováno mít založenou prázdnou databázi a uživatele s neomezeným 
přístupem do této databáze. Název databáze a její DSN a přihlašovací jméno a heslo 
uživatele je třeba před zahájením instalace znát. Je doporučeno pro účely instalace
portálu založit novou databázi a nového uživatele. V prostředí Ubuntu je rovněž nutné 
mít nainstalované tyto balíčky (packages):

* build-essential
* libssl-dev∙mysql-server
* libmysqlclient-dev1

### Postup instalace
Nejdříve je potřeba přejít do adresáře projektu, kde se nachází instalační skript 
install.pl (složka src). Dále je třeba instalační skript spustit.

```
$ sudo ./install.pl
```

Instalační skript poté nabídne instalaci potřebných Perl 5 modulů a vyžádá si 
přihlašovací údaje pro přístup k databázi.

### Spuštění
Nacházíme se ve složce s instalačním skriptem install.pl. Pro spuštění komponenty, 
která stáhne data ze sítě EWP a uloží je do databáze, přejdeme do složky Downloader 
a spustíme zde skript downloader.pl.

```
$ cd  Downloader/
$ ./downloader.pl
```


Výstupem skriptu je log s informacemi o stahování dat z jednotlivých endpointů. 
Po ukončení stahování by měla být databáze naplněna daty z EWP. Nyní se vrátíme 
do složky src a přejdeme do složky StudentPortal. Zde spustíme testovací server, 
který zpřístupní Studentský portál na adrese http://localhost:3000/.

```
$ cd ../StudentPortal/
$ script/studentportal_server.pl
```
