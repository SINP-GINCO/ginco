ALTER TABLE website.job_queue ALTER COLUMN command TYPE character varying(1000);
ALTER TABLE raw_data.export_file ALTER COLUMN file_name TYPE character varying(500);