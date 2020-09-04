CREATE TABLE IF NOT EXISTS customer_address (
    ca_address_sk bigint,
    ca_address_id char(16),
    ca_street_number char(10),
    ca_street_name char(60),
    ca_street_type char(15),
    ca_suite_number char(10),
    ca_city varchar(60),
    ca_county varchar(30),
    ca_state char(2),
    ca_zip char(10),
    ca_country char(20),
    ca_gmt_offset double precision,
    ca_location_type char(20)
);