-- Modified version of
-- Figure 7: Reporting Query (Query 40)
-- http://www.tpc.org/tpcds/presentations/tpcds_workload_analysis.pdf

WITH customer_total_return AS (
    SELECT
        cr_returning_customer_sk AS ctr_cust_sk,
        ca_state AS ctr_state,
        sum(cr_return_amt_inc_tax) AS ctr_return
    FROM
        tpcds.sf1.catalog_returns,
        tpcds.sf1.date_dim,
        hive.default.customer_address
    WHERE
        cr_returned_date_sk = d_date_sk
        AND d_year = 1998
        AND cr_returning_addr_sk = ca_address_sk
    GROUP BY
        cr_returning_customer_sk,
        ca_state
)
SELECT
    c_customer_id,
    c_salutation,
    c_first_name,
    c_last_name,
    ca_street_number,
    ca_street_name,
    ca_street_type,
    ca_suite_number,
    ca_city,
    ca_county,
    ca_state,
    ca_zip,
    ca_country,
    ca_gmt_offset,
    ca_location_type,
    ctr_return
FROM
    customer_total_return ctr1,
    hive.default.customer_address,
    hive.default.customer
WHERE
    ctr1.ctr_return > (
        SELECT
            avg(ctr_return) * 1.2
        FROM
            customer_total_return ctr2
        WHERE
            ctr1.ctr_state = ctr2.ctr_state)
    AND ca_address_sk = c_current_addr_sk
    AND ca_state = 'TN'
    AND ctr1.ctr_cust_sk = c_customer_sk
ORDER BY
    c_customer_id,
    c_salutation,
    c_first_name,
    c_last_name,
    ca_street_number,
    ca_street_name,
    ca_street_type,
    ca_suite_number,
    ca_city,
    ca_county,
    ca_state,
    ca_zip,
    ca_country,
    ca_gmt_offset,
    ca_location_type,
    ctr_return;