INSERT INTO metadata.checks(
	check_id,
	step,
	name,
	label,
	description,
	importance
) VALUES (
	'1211',
	'CONFORMITY',
	'IDENTIFIANT_PERMANENT_NOT_UUID',
	'L''identifiant permanent n''est pas un UUID.',
	'L''identifiant permanent doit être un UUID valide, ou sa valeur doit être vide.',
	'ERROR'
);