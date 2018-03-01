-- Replace the instance name in the path of submitted files
update raw_data.submission_file
set file_name = regexp_replace(file_name, '/var/data/ginco/[\w-]*/(.*)', '/var/data/ginco/@instance.name@/\1', 'i');