-- Modified version of
-- Figure 6: CPU Intensive Query (Query 70)
-- http://www.tpc.org/tpcds/presentations/tpcds_workload_analysis.pdf

SELECT
    w_state,
    i_item_id,
    SUM(
        CASE WHEN d_date < CAST('2000-03-11' AS date) THEN
            cs_sales_price - cr_refunded_cash
        ELSE
            0
        END) AS sales_before,
    SUM(
        CASE WHEN d_date >= CAST('2000-03-11' AS date) THEN
            cs_sales_price - cr_refunded_cash
        ELSE
            0
        END) AS sales_after
FROM
    tpcds.sf10.catalog_sales
    LEFT OUTER JOIN tpcds.sf10.catalog_returns ON (cs_item_sk = cr_item_sk
        AND cs_order_number = cr_order_number),
    tpcds.sf10.warehouse,
    tpcds.sf10.item,
    tpcds.sf10.date_dim
WHERE
    i_current_price BETWEEN 0.99
    AND 1.49
    AND i_item_sk = cs_item_sk
    AND cs_warehouse_sk = w_warehouse_sk
    AND cs_sold_date_sk = d_date_sk
    AND d_date BETWEEN (CAST('2000-03-11' AS date) - interval '30' day)
    AND (CAST('2000-03-11' AS date) + interval '30' day)
GROUP BY
    w_state,
    i_item_id
ORDER BY
    w_state,
    i_item_id;

