UPDATE metadata.dynamode SET sql='SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label FROM referentiels.geofla_departement ORDER BY code' WHERE unit IN ('CodeDepartementValue','CodeDepartementCalculeValue');
UPDATE metadata.dynamode SET sql='SELECT code_reg as code, nom_reg || '' ('' || code_reg || '')'' as label FROM referentiels.geofla_region ORDER BY code' WHERE unit='region';
UPDATE metadata.dynamode SET sql='SELECT insee_com as code, insee_com as label FROM referentiels.geofla_commune ORDER BY code'  WHERE unit IN ('CodeCommuneValue','CodeCommuneCalculeValue');
UPDATE metadata.dynamode SET sql='SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label FROM referentiels.geofla_commune ORDER BY code'  WHERE unit IN ('NomCommuneValue','NomCommuneCalculeValue');

UPDATE metadata_work.dynamode SET sql='SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label FROM referentiels.geofla_departement ORDER BY code' WHERE unit IN ('CodeDepartementValue','CodeDepartementCalculeValue');
UPDATE metadata_work.dynamode SET sql='SELECT code_reg as code, nom_reg || '' ('' || code_reg || '')'' as label FROM referentiels.geofla_region ORDER BY code' WHERE unit='region';
UPDATE metadata_work.dynamode SET sql='SELECT insee_com as code, insee_com as label FROM referentiels.geofla_commune ORDER BY code'  WHERE unit IN ('CodeCommuneValue','CodeCommuneCalculeValue');
UPDATE metadata_work.dynamode SET sql='SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label FROM referentiels.geofla_commune ORDER BY code'  WHERE unit IN ('NomCommuneValue','NomCommuneCalculeValue');
