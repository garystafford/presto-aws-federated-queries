SELECT
    sum(ss_net_profit) AS total_sum,
    s_state,
    s_county,
    (GROUPING (s_state) + GROUPING (s_county)) AS aggregated,
        (rank() OVER (PARTITION BY GROUPING (s_state) + GROUPING (s_county), CASE WHEN GROUPING (s_county) = 0 THEN
                    s_state
                END ORDER BY sum(ss_net_profit) DESC)) AS rank
                FROM
                    tpcds.sf1.store_sales,
                    tpcds.sf1.date_dim,
                    tpcds.sf1.store
                WHERE
                    d_year = 1999
                    AND d_date_sk = ss_sold_date_sk
                    AND s_store_sk = ss_store_sk
                    AND s_state IN (
                        SELECT
                            s_state
                        FROM (
                            SELECT
                                s_state,
                                rank() OVER (PARTITION BY s_state ORDER BY sum(ss_net_profit) DESC) AS r
                            FROM
                                tpcds.sf1.store_sales,
                                tpcds.sf1.store,
                                tpcds.sf1.date_dim
                            WHERE
                                d_year = 1999
                                AND d_date_sk = ss_sold_date_sk
                                AND s_store_sk = ss_store_sk
                            GROUP BY
                                s_state) AS ssr
                        WHERE
                            r <= 5)
                GROUP BY
                    ROLLUP (s_state, s_county)
            ORDER BY
                s_state;

