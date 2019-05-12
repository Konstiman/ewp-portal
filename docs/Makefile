SHELL=/bin/bash

.PHONY: html clean
pdf: ${NAME}.pdf

clean:
	@echo -e "\nMazu predchozi vygenerovane soubory\n"
	-rm *.html

html:
	@echo -e "\nGeneruji html dokumentaci\n"
	pod2html --outfile ./downloader.html --infile ../src/Downloader/lib/Downloader.pm
	pod2html --outfile ./entityManager.html --infile ../src/Downloader/lib/Manager/EntityManager.pm
	pod2html --outfile ./address.html --infile ../src/Downloader/lib/Entity/Address.pm
	pod2html --outfile ./contact.html --infile ../src/Downloader/lib/Entity/Contact.pm
	pod2html --outfile ./institution.html --infile ../src/Downloader/lib/Entity/Institution.pm
	pod2html --outfile ./learningOpportunity.html --infile ../src/Downloader/lib/Entity/LearningOpportunity.pm
	pod2html --outfile ./learningOpportunityInstance.html --infile ../src/Downloader/lib/Entity/LearningOpportunityInstance.pm
	pod2html --outfile ./resultDistribution.html --infile ../src/Downloader/lib/Entity/ResultDistribution.pm
	pod2html --outfile ./unit.html --infile ../src/Downloader/lib/Entity/Unit.pm
