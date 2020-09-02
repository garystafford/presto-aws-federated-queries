-- USE tpcds.sf1

-- SELECT DISTINCT
--     c_last_name,
--     c_first_name,
--     c_email_address,
--     cd_gender,
--     cd_education_status,
--     cd_credit_rating
-- FROM
--     customer
--     LEFT OUTER JOIN customer_demographics ON c_current_cdemo_sk = cd_demo_sk
-- WHERE
--     c_last_name IS NOT NULL
--     AND c_first_name IS NOT NULL
-- ORDER BY
--     c_last_name,
--     c_first_name;

SELECT cd_education_status AS education,
       cd_credit_rating    AS credit_rating,
       cd_gender           AS gender,
       count(cd_gender)    AS gender_count
FROM   customer
       LEFT JOIN customer_demographics
              ON c_current_cdemo_sk = cd_demo_sk
WHERE  cd_education_status IS NOT NULL
       AND lower(cd_education_status) != 'unknown'
       AND cd_credit_rating IS NOT NULL
       AND lower(cd_credit_rating) != 'unknown'
       AND cd_gender IS NOT NULL
GROUP  BY cd_education_status,
          cd_credit_rating,
          cd_gender
ORDER  BY cd_education_status,
          cd_credit_rating;