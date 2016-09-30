UPDATE raw_data.submission SET step = 'CHECK' WHERE step = 'CHECKED';
UPDATE raw_data.submission SET step = 'VALIDATE' WHERE step = 'VALIDATED';
UPDATE raw_data.submission SET step = 'CANCEL' WHERE step = 'CANCELLED';
UPDATE raw_data.submission SET step = 'INSERT' WHERE step = 'INSERTED';