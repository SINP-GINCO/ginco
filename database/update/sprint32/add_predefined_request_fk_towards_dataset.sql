--#1057: Add foreign key between dataset and predefined_request in order to delete them when unpublishing model

ALTER TABLE website.predefined_request
ADD CONSTRAINT predefined_request_dataset_id FOREIGN KEY (dataset_id)
      REFERENCES metadata.dataset (dataset_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;