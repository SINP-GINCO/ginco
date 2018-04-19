DELETE FROM website.application_parameters WHERE name='results_bbox_compute_threshold';
DELETE FROM website.application_parameters WHERE name='max_results';
INSERT INTO website.application_parameters(name, value, description) VALUES ('max_results', '50000', 'Number of results above which a search is aborted.');
