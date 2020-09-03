-- USE tpcds.sf1;

WITH credit_demographics AS (
    SELECT
        (year (now()) - c_birth_year) AS age,
        cd_credit_rating AS credit_rating,
        cd_gender AS gender,
        count(cd_gender) AS gender_count
    FROM
        tpcds.sf1.customer
        LEFT JOIN hive.default.customer_demographics ON c_current_cdemo_sk = cd_demo_sk
    WHERE
        c_birth_year IS NOT NULL
        AND cd_credit_rating IS NOT NULL
        AND lower(cd_credit_rating) != 'unknown'
        AND cd_gender IS NOT NULL
    GROUP BY
        cd_credit_rating,
        c_birth_year,
        cd_gender
)
SELECT
    age,
    credit_rating,
    gender,
    gender_count
FROM
    credit_demographics
WHERE
    age BETWEEN 21 AND 65
ORDER BY
    age,
    credit_rating,
    gender;

