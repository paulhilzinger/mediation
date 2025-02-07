-- MZITA-213 - Remove all the individual "116xxx" entries and replace with a single "116" entry
--
delete from prefix_to_kenan_mapping
where prefix like '116%';

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('116','Freephone - Public Utility Service','2005','018#');


-- MZITA-213 - Remove all the individual "196xx" entries and replace with a single "196" entry
--
delete from prefix_to_kenan_mapping
where prefix like '196%';

INSERT INTO PREFIX_TO_KENAN_MAPPING VALUES ('196','Freephone - Social Communication Service','2005','018#');