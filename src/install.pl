#!/usr/bin/perl

print <<EOF;
Vitejte v instalatoru Studentskeho portalu pro EWP. Prosim overte, ze vas system splnuje nasledujici pozadavky:

 - unixovy operacni system (doporucene je Ubuntu ve verzi 18.04.2)
 - zakladni nastroje (sudo apt-get install build-essential)
 - libssl-dev (sudo apt-get install libssl-dev)
 - Perl 5 (doporucena verze: 5.26)
 - cpan (doporucena verze: 2.26)
 - mysql server (sudo apt-get install mysql-server)
 - MySQL (doporucena verze: 5.7.26) se zalozenou databazi (je treba znat DSN, prihlasovaci jmeno a heslo)
 - konfiguracni soubory k mysql (sudo apt-get install libmysqlclient-dev)

Chcete pokracovat? ([ANO]/ne)
EOF

my $start = <>;

if ( $start && $start !~ /^[ya]/i ) {
	print "Instalace prerusena.\n";
	exit;
}

print <<EOF;
Pripravuji instalaci. Budou instalovany nasledujici moduly:
- DBD::mysql
- LWP::UserAgent
- HTTP::Request
- XML::LibXML
- Moose
- File::Slurp
- Catalyst::Runtime
- Catalyst::Devel

Instalaci modulu lze preskocit. Je ale mozne, ze pak software nebude mozne spustit kvuli chybejicim zavislostem.

Instalovat moduly? ([ANO]/ne)
EOF

my $install = <>;

if ( $install && $install !~ /^[ya]/i ) {
	print <<EOF;
Byla preskocena instalace modulu.
EOF
}
else {
	system 'cpan DBD::mysql LWP::UserAgent HTTP::Request XML::LibXML'
		. ' Moose File::Slurp Catalyst::Runtime Catalyst::Devel';

	if ($? == -1) {
		print "\nInstalace se nezdarila: $!\n";
	}
	elsif ($? & 127) {
		printf "\nInstalace se nezdarila, skoncila se signalem %d (%s coredump).\n",
			($? & 127),  ($? & 128) ? 'with' : 'without';
	}
	elsif ($? == 0) {
		printf "\nModuly byly uspesne nainstalovany.\n";
	}
	else {
		printf "\nInstalace skoncila s hodnotou %d\n.", $? >> 8;
	}
}

print <<EOF;

Nyni je nutne zadat prihlasovaci udaje k databazi, do ktere bude program ukladat data.
Zadejte prosim DSN, nazev databaze, prihlasovaci jmeno a heslo.
EOF

print "DSN: ";
my $dsn = <>;
chomp( $dsn );

print "nazev databaze: ";
my $db = <>;
chomp( $db );

print "prihlasovaci jmeno: ";
my $user = <>;
chomp( $user );

print "heslo: ";
my $passw = <>;
chomp( $passw );

my $filename = 'config';
open(my $fh, '>', $filename) || die "Nepodarilo se vytvorit soubor '$filename': $!";
print $fh "$dsn\n$user\n$passw\n";
close $fh;

print <<EOF;
Udaje byly ulozeny do konfiguracniho souboru. Nyni dojde k vytvoreni tabulek v databazi a naplneni ciselniku.
EOF

system "mysql -u $user -p$passw $db < db_create.ddl";
