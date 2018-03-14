DROP TABLE IF EXISTS referentiels.diffusionfloutagevalue;

-- Fix #1458
DELETE FROM metadata.dynamode where unit='DEEFloutageValue';
INSERT INTO metadata.dynamode (unit, sql) VALUES
  ('DEEFloutageValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.DEEFloutageValue ORDER BY code');
