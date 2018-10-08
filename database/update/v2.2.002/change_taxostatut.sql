UPDATE referentiels.taxostatutvalue
SET label = 'Retrait', definition = 'Retrait'
WHERE code = '1';

DELETE FROM referentiels.taxostatutvalue WHERE code = '2';