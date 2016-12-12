INSERT INTO website.application_parameters(name, value, description)
VALUES ('sendEmail','1','Send emails for real ? 1/true, 0/false');

UPDATE website.users SET email='sinp-dev@ign.fr' WHERE user_login='developpeur';