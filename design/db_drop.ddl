ALTER TABLE institution_name DROP FOREIGN KEY FKinstitutio611014;
ALTER TABLE institution_other_id DROP FOREIGN KEY FKinstitutio268247;
ALTER TABLE institution_website DROP FOREIGN KEY FKinstitutio985254;
ALTER TABLE institution_name DROP FOREIGN KEY FKinstitutio667474;
ALTER TABLE institution_website DROP FOREIGN KEY FKinstitutio41715;
ALTER TABLE institution_factsheet DROP FOREIGN KEY FKinstitutio824820;
ALTER TABLE institution_factsheet DROP FOREIGN KEY FKinstitutio881280;
ALTER TABLE unit DROP FOREIGN KEY FKunit443466;
ALTER TABLE unit_name DROP FOREIGN KEY FKunit_name278280;
ALTER TABLE unit_name DROP FOREIGN KEY FKunit_name321476;
ALTER TABLE unit DROP FOREIGN KEY FKunit232463;
ALTER TABLE institution DROP FOREIGN KEY FKinstitutio896491;
ALTER TABLE institution DROP FOREIGN KEY FKinstitutio101084;
ALTER TABLE unit DROP FOREIGN KEY FKunit568383;
ALTER TABLE unit DROP FOREIGN KEY FKunit429192;
ALTER TABLE unit_website DROP FOREIGN KEY FKunit_websi962525;
ALTER TABLE unit_website DROP FOREIGN KEY FKunit_websi362769;
ALTER TABLE unit_contact DROP FOREIGN KEY FKunit_conta771881;
ALTER TABLE unit_contact DROP FOREIGN KEY FKunit_conta93622;
ALTER TABLE institution_contact DROP FOREIGN KEY FKinstitutio794610;
ALTER TABLE institution_contact DROP FOREIGN KEY FKinstitutio585323;
ALTER TABLE unit_factsheet DROP FOREIGN KEY FKunit_facts190389;
ALTER TABLE unit_factsheet DROP FOREIGN KEY FKunit_facts590632;
ALTER TABLE learning_opportunity DROP FOREIGN KEY FKlearning_o623584;
ALTER TABLE opportunity_title DROP FOREIGN KEY FKopportunit500172;
ALTER TABLE opportunity_title DROP FOREIGN KEY FKopportunit950006;
ALTER TABLE learning_opportunity DROP FOREIGN KEY FKlearning_o862068;
ALTER TABLE opportunity_website DROP FOREIGN KEY FKopportunit952613;
ALTER TABLE opportunity_website DROP FOREIGN KEY FKopportunit502779;
ALTER TABLE opportunity_description DROP FOREIGN KEY FKopportunit572756;
ALTER TABLE opportunity_description DROP FOREIGN KEY FKopportunit22591;
ALTER TABLE opportunity_instance DROP FOREIGN KEY FKopportunit50993;
ALTER TABLE opportunity_instance DROP FOREIGN KEY FKopportunit685830;
ALTER TABLE grading_scheme DROP FOREIGN KEY FKgrading_sc141295;
ALTER TABLE grading_scheme DROP FOREIGN KEY FKgrading_sc956124;
ALTER TABLE result_distribution_category DROP FOREIGN KEY FKresult_dis135665;
ALTER TABLE result_distribution_description DROP FOREIGN KEY FKresult_dis350877;
ALTER TABLE result_distribution_description DROP FOREIGN KEY FKresult_dis523293;
ALTER TABLE credit DROP FOREIGN KEY FKcredit374739;
ALTER TABLE opportunity_instance DROP FOREIGN KEY FKopportunit235996;
ALTER TABLE learning_opportunity DROP FOREIGN KEY FKlearning_o82541;
ALTER TABLE academic_term_name DROP FOREIGN KEY FKacademic_t261238;
ALTER TABLE academic_term_name DROP FOREIGN KEY FKacademic_t974248;
ALTER TABLE contact DROP FOREIGN KEY FKcontact501135;
ALTER TABLE contact DROP FOREIGN KEY FKcontact496440;
ALTER TABLE contact_name DROP FOREIGN KEY FKcontact_na180533;
ALTER TABLE contact_name DROP FOREIGN KEY FKcontact_na446280;
ALTER TABLE contact_description DROP FOREIGN KEY FKcontact_de968073;
ALTER TABLE contact_description DROP FOREIGN KEY FKcontact_de297673;
ALTER TABLE contact_email DROP FOREIGN KEY FKcontact_em902284;
ALTER TABLE contact_phone DROP FOREIGN KEY FKcontact_ph878896;
ALTER TABLE contact_fax DROP FOREIGN KEY FKcontact_fa267633;
ALTER TABLE address DROP FOREIGN KEY FKaddress974202;
DROP TABLE IF EXISTS academic_term;
DROP TABLE IF EXISTS academic_term_name;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS contact;
DROP TABLE IF EXISTS contact_description;
DROP TABLE IF EXISTS contact_email;
DROP TABLE IF EXISTS contact_fax;
DROP TABLE IF EXISTS contact_name;
DROP TABLE IF EXISTS contact_phone;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS credit;
DROP TABLE IF EXISTS grading_scheme;
DROP TABLE IF EXISTS institution;
DROP TABLE IF EXISTS institution_contact;
DROP TABLE IF EXISTS institution_factsheet;
DROP TABLE IF EXISTS institution_name;
DROP TABLE IF EXISTS institution_other_id;
DROP TABLE IF EXISTS institution_website;
DROP TABLE IF EXISTS language;
DROP TABLE IF EXISTS learning_opportunity;
DROP TABLE IF EXISTS opportunity_description;
DROP TABLE IF EXISTS opportunity_instance;
DROP TABLE IF EXISTS opportunity_title;
DROP TABLE IF EXISTS opportunity_type;
DROP TABLE IF EXISTS opportunity_website;
DROP TABLE IF EXISTS result_distribution_category;
DROP TABLE IF EXISTS result_distribution_description;
DROP TABLE IF EXISTS unit;
DROP TABLE IF EXISTS unit_contact;
DROP TABLE IF EXISTS unit_factsheet;
DROP TABLE IF EXISTS unit_name;
DROP TABLE IF EXISTS unit_website;

