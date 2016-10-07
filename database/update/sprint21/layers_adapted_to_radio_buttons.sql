SET search_path = mapping;

--
-- Define the radio groups in layer_tree
--
UPDATE layer_tree SET checked_group='results', is_checked=0 WHERE name IN ('result_geometrie','result_commune','result_maille','result_departement');
UPDATE layer_tree SET is_checked=1 WHERE name = 'result_departement';

--
-- Change min and max resolutions for result layers
--
UPDATE layer SET maxscale=null, minscale=null WHERE layer_name='result_departement';
UPDATE layer SET maxscale=null, minscale=null WHERE layer_name='result_maille';
UPDATE layer SET maxscale=null, minscale=null WHERE layer_name='result_commune';
UPDATE layer SET maxscale=272989, minscale=null WHERE layer_name='result_geometrie';
