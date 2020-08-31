-- Modified version of
-- Figure 9: Iterative Query (Query 24)
-- http://www.tpc.org/tpcds/presentations/tpcds_workload_analysis.pdf

USE tpcds.sf1

WITH cross_sales AS (
    SELECT
        i_product_name product_name,
        i_item_sk item_sk,
        w_state warehouse_state,
        w_warehouse_name warehouse_name,
        ad1.ca_street_number b_street_number,
        ad1.ca_street_name b_streen_name,
        ad1.ca_city b_city,
        ad1.ca_zip b_zip,
        ad2.ca_street_number c_street_number,
        ad2.ca_street_name c_street_name,
        ad2.ca_city c_city,
        ad2.ca_zip c_zip,
        d1.d_year AS syear,
        d2.d_year AS fsyear,
        d3.d_year s2year,
        count(*) cnt,
        sum(ss_wholesale_cost) s1,
        sum(ss_sales_price) s2,
        sum(ss_net_profit) s3,
        sum(cs_wholesale_cost) s4,
        sum(cs_sales_price) s5,
        sum(cs_net_profit) s6,
        sum(ws_wholesale_cost) s7,
        sum(ws_sales_price) s8,
        sum(ws_net_profit) s9
    FROM
        store_sales,
        store_returns,
        web_sales,
        web_returns,
        catalog_sales,
        catalog_returns,
        date_dim d1,
        date_dim d2,
        date_dim d3,
        warehouse,
        item,
        customer,
        customer_demographics cd1,
        customer_demographics cd2,
        promotion,
        household_demographics hd1,
        household_demographics hd2,
        customer_address ad1,
        customer_address ad2,
        income_band ib1,
        income_band ib2
    WHERE
        ws_warehouse_sk = w_warehouse_sk
        AND ss_sold_date_sk = d1.d_date_sk
        AND ws_bill_customer_sk = c_customer_sk
        AND ws_bill_cdemo_sk = cd1.cd_demo_sk
        AND ws_bill_hdemo_sk = hd1.hd_demo_sk
        AND ws_bill_addr_sk = ad1.ca_address_sk
        AND ss_item_sk = i_item_sk
        AND ss_item_sk = sr_item_sk
        AND ss_ticket_number = sr_ticket_number
        AND ss_item_sk = ws_item_sk
        AND ws_item_sk = wr_item_sk
        AND ws_order_number = wr_order_number
        AND ss_item_sk = cs_item_sk
        AND ws_item_sk = cr_item_sk
        AND cs_order_number = cr_order_number
        AND c_current_cdemo_sk = cd2.cd_demo_sk
        AND c_current_hdemo_sk = hd2.hd_demo_sk
        AND c_current_addr_sk = ad2.ca_address_sk
        AND c_first_sales_date_sk = d2.d_date_sk
        AND c_first_shipto_date_sk = d3.d_date_sk
        AND ws_promo_sk = p_promo_sk
        AND i_size = 'large'
        AND hd1.hd_income_band_sk = ib1.ib_income_band_sk
        AND hd2.hd_income_band_sk = ib2.ib_income_band_sk
        AND cd1.cd_marital_status <> cd2.cd_marital_status
        AND ib1.ib_upper_bound BETWEEN 10000 AND 10000 + 20000
        AND ib2.ib_upper_bound BETWEEN 100000 AND 100000 + 20000
        AND hd1.hd_buy_potential = '1001-5000'
        AND hd2.hd_buy_potential = '501-1000'
        AND (i_current_price BETWEEN 2.06
            AND 2.06 + 10
            OR i_current_price BETWEEN 4.65
            AND 4.65 + 10)
    GROUP BY
        i_product_name,
        i_item_sk,
        w_warehouse_name,
        w_state,
        ad1.ca_street_number,
        ad1.ca_street_name,
        ad1.ca_city,
        ad1.ca_zip,
        ad2.ca_street_number,
        ad2.ca_street_name,
        ad2.ca_city,
        ad2.ca_zip,
        d1.d_year,
        d2.d_year,
        d3.d_year
)
SELECT
    *
FROM
    cross_sales cs1,
    cross_sales cs2
WHERE
    cs1.item_sk = cs2.item_sk
    AND cs1.syear = 1998
    AND cs2.syear = 1998 + 1
ORDER BY
    cs1.product_name,
    cs1.warehouse_name,
    cs2.cnt;