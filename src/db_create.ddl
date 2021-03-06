CREATE TABLE academic_term (id int(10) NOT NULL AUTO_INCREMENT, yearIdentifier varchar(100) NOT NULL, termIdentifier varchar(100), name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, `start` date NOT NULL, `end` date NOT NULL, PRIMARY KEY (id));
CREATE TABLE academic_term_name (academic_term int(10) NOT NULL, name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, language int(10) NOT NULL);
CREATE TABLE address (id int(10) NOT NULL AUTO_INCREMENT, recipient varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, addressLines varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, buildingNumber varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci, buildingName varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, streetName varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, unit varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci, floor varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci, pobox varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, deliveryPoint varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, postalCode varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci, locality varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, region varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, country int(10), PRIMARY KEY (id));
CREATE TABLE contact (id int(10) NOT NULL AUTO_INCREMENT, gender int(2), location_address int(10), mailing_address int(10), PRIMARY KEY (id));
CREATE TABLE contact_description (contact int(10) NOT NULL, text text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10));
CREATE TABLE contact_email (contact int(10) NOT NULL, email varchar(500));
CREATE TABLE contact_fax (contact int(10) NOT NULL, faxNumber varchar(100));
CREATE TABLE contact_name (contact int(10) NOT NULL, name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10), type varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL);
CREATE TABLE contact_phone (contact int(10) NOT NULL, phoneNumber varchar(100));
CREATE TABLE country (id int(10) NOT NULL AUTO_INCREMENT, code varchar(100) NOT NULL, name_en varchar(1000), name_cz varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, PRIMARY KEY (id));
CREATE TABLE credit (opportunity_instance int(10) NOT NULL, scheme varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, level varchar(64), value decimal(10, 2) NOT NULL);
CREATE TABLE grading_scheme (opportunity_instance int(10) NOT NULL, label varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, description varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci, language int(10));
CREATE TABLE institution (id int(10) NOT NULL AUTO_INCREMENT, identifier varchar(64) NOT NULL UNIQUE, abbreviation varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci, logo_url varchar(1000), location_address int(10), mailing_address int(10), `fulltext` text CHARACTER SET utf8 COLLATE utf8_general_ci, PRIMARY KEY (id));
CREATE TABLE institution_contact (institution int(10) NOT NULL, contact int(10) NOT NULL, PRIMARY KEY (institution, contact));
CREATE TABLE institution_factsheet (institution int(10) NOT NULL, name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, url varchar(1000) NOT NULL, language int(10));
CREATE TABLE institution_name (institution int(10) NOT NULL, name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10));
CREATE TABLE institution_other_id (institution int(10) NOT NULL, identifier varchar(100) NOT NULL, type varchar(100) NOT NULL);
CREATE TABLE institution_website (institution int(10) NOT NULL, url varchar(1000) NOT NULL, language int(10));
CREATE TABLE language (id int(10) NOT NULL AUTO_INCREMENT, abbreviation varchar(10) NOT NULL, name varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci, flag_url varchar(1000), PRIMARY KEY (id), UNIQUE INDEX (abbreviation));
CREATE TABLE learning_opportunity (id int(10) NOT NULL AUTO_INCREMENT, unit int(10) NOT NULL, identifier varchar(100) NOT NULL, code varchar(1000), type int(10), subject_area varchar(1000), isced_code varchar(1000), eqf_level int(2), parent int(10), PRIMARY KEY (id));
CREATE TABLE opportunity_description (learning_opportunity int(10) NOT NULL, text text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10));
CREATE TABLE opportunity_instance (id int(10) NOT NULL AUTO_INCREMENT, identifier varchar(100) NOT NULL, learning_opportunity int(10) NOT NULL, `start` date NOT NULL, `end` date NOT NULL, academic_term int(10), language int(10), engagement_hours decimal(10, 2), PRIMARY KEY (id));
CREATE TABLE opportunity_title (learning_opportunity int(10) NOT NULL, title varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10));
CREATE TABLE opportunity_type (id int(10) NOT NULL AUTO_INCREMENT, name_en varchar(500) NOT NULL, name_cz varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci, PRIMARY KEY (id));
CREATE TABLE opportunity_website (learning_opportunity int(10) NOT NULL, url varchar(1000) NOT NULL, language int(10));
CREATE TABLE result_distribution_category (opportunity_instance int(10) NOT NULL, label varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, count int(10) NOT NULL, `order` int(10) NOT NULL);
CREATE TABLE result_distribution_description (opportunity_instance int(10) NOT NULL, description text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10));
CREATE TABLE unit (id int(10) NOT NULL AUTO_INCREMENT, identifier varchar(64) NOT NULL, institution int(10) NOT NULL, root int(1), code varchar(1000), abbreviation varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci, logo_url varchar(1000), parent int(10), location_address int(10), mailing_address int(10), PRIMARY KEY (id));
CREATE TABLE unit_contact (unit int(10) NOT NULL, contact int(10) NOT NULL, PRIMARY KEY (unit, contact));
CREATE TABLE unit_factsheet (unit int(10) NOT NULL, name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci, url varchar(1000) NOT NULL, language int(10));
CREATE TABLE unit_name (unit int(10) NOT NULL, name varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, language int(10));
CREATE TABLE unit_website (unit int(10) NOT NULL, url varchar(1000) NOT NULL, language int(10));
ALTER TABLE institution_name ADD CONSTRAINT FKinstitutio611014 FOREIGN KEY (institution) REFERENCES institution (id);
ALTER TABLE institution_other_id ADD CONSTRAINT FKinstitutio268247 FOREIGN KEY (institution) REFERENCES institution (id);
ALTER TABLE institution_website ADD CONSTRAINT FKinstitutio985254 FOREIGN KEY (institution) REFERENCES institution (id);
ALTER TABLE institution_name ADD CONSTRAINT FKinstitutio667474 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE institution_website ADD CONSTRAINT FKinstitutio41715 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE institution_factsheet ADD CONSTRAINT FKinstitutio824820 FOREIGN KEY (institution) REFERENCES institution (id);
ALTER TABLE institution_factsheet ADD CONSTRAINT FKinstitutio881280 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE unit ADD CONSTRAINT FKunit443466 FOREIGN KEY (institution) REFERENCES institution (id);
ALTER TABLE unit_name ADD CONSTRAINT FKunit_name278280 FOREIGN KEY (unit) REFERENCES unit (id);
ALTER TABLE unit_name ADD CONSTRAINT FKunit_name321476 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE unit ADD CONSTRAINT FKunit232463 FOREIGN KEY (parent) REFERENCES unit (id);
ALTER TABLE institution ADD CONSTRAINT FKinstitutio896491 FOREIGN KEY (location_address) REFERENCES address (id);
ALTER TABLE institution ADD CONSTRAINT FKinstitutio101084 FOREIGN KEY (mailing_address) REFERENCES address (id);
ALTER TABLE unit ADD CONSTRAINT FKunit568383 FOREIGN KEY (location_address) REFERENCES address (id);
ALTER TABLE unit ADD CONSTRAINT FKunit429192 FOREIGN KEY (mailing_address) REFERENCES address (id);
ALTER TABLE unit_website ADD CONSTRAINT FKunit_websi962525 FOREIGN KEY (unit) REFERENCES unit (id);
ALTER TABLE unit_website ADD CONSTRAINT FKunit_websi362769 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE unit_contact ADD CONSTRAINT FKunit_conta771881 FOREIGN KEY (unit) REFERENCES unit (id);
ALTER TABLE unit_contact ADD CONSTRAINT FKunit_conta93622 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE institution_contact ADD CONSTRAINT FKinstitutio794610 FOREIGN KEY (institution) REFERENCES institution (id);
ALTER TABLE institution_contact ADD CONSTRAINT FKinstitutio585323 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE unit_factsheet ADD CONSTRAINT FKunit_facts190389 FOREIGN KEY (unit) REFERENCES unit (id);
ALTER TABLE unit_factsheet ADD CONSTRAINT FKunit_facts590632 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE learning_opportunity ADD CONSTRAINT FKlearning_o623584 FOREIGN KEY (unit) REFERENCES unit (id);
ALTER TABLE opportunity_title ADD CONSTRAINT FKopportunit500172 FOREIGN KEY (learning_opportunity) REFERENCES learning_opportunity (id);
ALTER TABLE opportunity_title ADD CONSTRAINT FKopportunit950006 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE learning_opportunity ADD CONSTRAINT FKlearning_o862068 FOREIGN KEY (type) REFERENCES opportunity_type (id);
ALTER TABLE opportunity_website ADD CONSTRAINT FKopportunit952613 FOREIGN KEY (learning_opportunity) REFERENCES learning_opportunity (id);
ALTER TABLE opportunity_website ADD CONSTRAINT FKopportunit502779 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE opportunity_description ADD CONSTRAINT FKopportunit572756 FOREIGN KEY (learning_opportunity) REFERENCES learning_opportunity (id);
ALTER TABLE opportunity_description ADD CONSTRAINT FKopportunit22591 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE opportunity_instance ADD CONSTRAINT FKopportunit50993 FOREIGN KEY (academic_term) REFERENCES academic_term (id);
ALTER TABLE opportunity_instance ADD CONSTRAINT FKopportunit685830 FOREIGN KEY (learning_opportunity) REFERENCES learning_opportunity (id);
ALTER TABLE grading_scheme ADD CONSTRAINT FKgrading_sc141295 FOREIGN KEY (opportunity_instance) REFERENCES opportunity_instance (id);
ALTER TABLE grading_scheme ADD CONSTRAINT FKgrading_sc956124 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE result_distribution_category ADD CONSTRAINT FKresult_dis135665 FOREIGN KEY (opportunity_instance) REFERENCES opportunity_instance (id);
ALTER TABLE result_distribution_description ADD CONSTRAINT FKresult_dis350877 FOREIGN KEY (opportunity_instance) REFERENCES opportunity_instance (id);
ALTER TABLE result_distribution_description ADD CONSTRAINT FKresult_dis523293 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE credit ADD CONSTRAINT FKcredit374739 FOREIGN KEY (opportunity_instance) REFERENCES opportunity_instance (id);
ALTER TABLE opportunity_instance ADD CONSTRAINT FKopportunit235996 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE learning_opportunity ADD CONSTRAINT FKlearning_o82541 FOREIGN KEY (parent) REFERENCES learning_opportunity (id);
ALTER TABLE academic_term_name ADD CONSTRAINT FKacademic_t261238 FOREIGN KEY (academic_term) REFERENCES academic_term (id);
ALTER TABLE academic_term_name ADD CONSTRAINT FKacademic_t974248 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE contact ADD CONSTRAINT FKcontact501135 FOREIGN KEY (location_address) REFERENCES address (id);
ALTER TABLE contact ADD CONSTRAINT FKcontact496440 FOREIGN KEY (mailing_address) REFERENCES address (id);
ALTER TABLE contact_name ADD CONSTRAINT FKcontact_na180533 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE contact_name ADD CONSTRAINT FKcontact_na446280 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE contact_description ADD CONSTRAINT FKcontact_de968073 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE contact_description ADD CONSTRAINT FKcontact_de297673 FOREIGN KEY (language) REFERENCES language (id);
ALTER TABLE contact_email ADD CONSTRAINT FKcontact_em902284 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE contact_phone ADD CONSTRAINT FKcontact_ph878896 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE contact_fax ADD CONSTRAINT FKcontact_fa267633 FOREIGN KEY (contact) REFERENCES contact (id);
ALTER TABLE address ADD CONSTRAINT FKaddress974202 FOREIGN KEY (country) REFERENCES country (id);
INSERT INTO country (code, name_en, name_cz) VALUES ('PL', 'Poland', 'Polsko');
INSERT INTO country (code, name_en, name_cz) VALUES ('CZ', 'Czechia', '??esk?? republika');
INSERT INTO country (code, name_en, name_cz) VALUES ('IT', 'Italy', 'It??lie');
INSERT INTO country (code, name_en, name_cz) VALUES ('SE', 'Sweden', '??v??dsko');
INSERT INTO language (abbreviation, flag_url) VALUES ('en', '/static/images/flags/en.png');
INSERT INTO language (abbreviation, flag_url) VALUES ('pl', '/static/images/flags/pl.png');
INSERT INTO language (abbreviation, flag_url) VALUES ('sv', '/static/images/flags/sv.png');
INSERT INTO language (abbreviation, flag_url) VALUES ('cz', '/static/images/flags/cz.png');
INSERT INTO language (abbreviation, flag_url) VALUES ('sk', '/static/images/flags/sk.png');
INSERT INTO language (abbreviation, flag_url) VALUES ('it', '/static/images/flags/it.png');
INSERT INTO opportunity_type(name_en, name_cz) VALUES ('Degree Programme', 'Program');
INSERT INTO opportunity_type(name_en, name_cz) VALUES ('Module', 'Modul');
INSERT INTO opportunity_type(name_en, name_cz) VALUES ('Course', 'Kurz');
INSERT INTO opportunity_type(name_en, name_cz) VALUES ('Class', 'P??edn????ka');

