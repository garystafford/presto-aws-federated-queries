SELECT
    *
FROM
    customer
    LEFT JOIN customer_address ON (c_current_addr_sk = ca_address_sk);
