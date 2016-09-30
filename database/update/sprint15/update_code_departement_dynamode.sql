UPDATE metadata.dynamode SET sql = 'SELECT code as code, nom || '' ('' || code || '')'' as label FROM referentiels.departements ORDER BY code' WHERE unit = 'CodeDepartementValue';
UPDATE metadata_work.dynamode SET sql = 'SELECT code as code, nom || '' ('' || code || '')'' as label FROM referentiels.departements ORDER BY code' WHERE unit = 'CodeDepartementValue';
