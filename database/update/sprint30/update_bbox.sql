-- Max map extend
UPDATE website.application_parameters SET value = '20037508.342789244' WHERE name = 'bbox_x_max';
UPDATE website.application_parameters SET value = '-20037508.342789244' WHERE name = 'bbox_x_min';
UPDATE website.application_parameters SET value = '20037508.342789244' WHERE name = 'bbox_y_max';
UPDATE website.application_parameters SET value = '-20037508.342789244' WHERE name = 'bbox_y_min';
UPDATE website.application_parameters SET value = '1' WHERE name = 'zoom_level';

-- Default provider bbox
insert into application_parameters (name, value, description) values ( 'default_provider_bbox_x_min' , '@bb.xmin@' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'default_provider_bbox_y_min' , '@bb.ymin@' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'default_provider_bbox_x_max' , '@bb.xmax@' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'default_provider_bbox_y_max' , '@bb.ymax@' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'default_provider_zoom_level' , '@bb.zoom@' , 'WEB MAPPING ');