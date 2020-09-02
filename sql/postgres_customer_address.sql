CREATE TABLE customer_address (
    ca_address_sk bigint,
    ca_address_id text,
    ca_street_number integer,
    ca_street_name text,
    ca_street_type text,
    ca_suite_number text,
    ca_city text,
    ca_county text,
    ca_state char(2),
    ca_zip text,
    ca_country text,
    ca_gmt_offset double precision,
    ca_location_type text
);

\COPY customer_address FROM '/home/ec2-user/customer_address.csv' DELIMITER ',' CSV HEADER;