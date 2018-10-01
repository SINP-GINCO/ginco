DELETE FROM website.permission_per_role WHERE permission_code IN ('VALIDATE_SUBMISSION_ALL', 'VALIDATE_SUBMISSION_PROVIDER', 'VALIDATE_SUBMISSION_OWN') ;
DELETE FROM website.permission WHERE permission_code IN ('VALIDATE_SUBMISSION_ALL', 'VALIDATE_SUBMISSION_PROVIDER', 'VALIDATE_SUBMISSION_OWN') ;

-- Update existing jdd status

UPDATE raw_data.jdd j 
SET status = 'validated'
FROM raw_data.submission s
WHERE j.id = s.jdd_id AND s.step = 'VALIDATE' AND j.status = 'active'