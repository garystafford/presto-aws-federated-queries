CREATE TABLE customer_address (
    ca_address_sk bigint,
    ca_address_id text,
    ca_street_number bigint,
    ca_street_name text,
    ca_street_type text,
    ca_suite_number text,
    ca_city text,
    ca_county text,
    ca_state text,
    ca_zip bigint,
    ca_country text,
    ca_gmt_offset double precision,
    ca_location_type text,
    PRIMARY KEY (ca_address_sk)
);

\dt

\COPY customer_address FROM '/home/ec2-user/customer_address.csv' DELIMITER ',' CSV HEADER;

SELECT
    COUNT(*)
FROM
    customer_address;

SELECT
    *
FROM
    customer_address
LIMIT 10;

\q
