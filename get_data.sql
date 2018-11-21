-- データ理解 --
-- (1) srch_id（検索条件の件数）は「399,344」
SELECT COUNT(Distinct(srch_id)) as srch_id_cnt
FROM data
LIMIT 10


-- (2) (1)のうち、購入あり（booking_bool = 1）のsrch_id（検索条件の件数）は「276,593」
SELECT
    b.booking_bool,
    COUNT(Distinct(a.srch_id)) as srch_id_cnt,
    (1.0*COUNT(Distinct(a.srch_id)))/
        (SELECT COUNT(Distinct(srch_id)) as srch_id_cnt FROM data) as rate
FROM data AS a
INNER JOIN (SELECT srch_id, SUM(booking_bool) AS booking_bool FROM data GROUP BY srch_id) AS b 
    ON a.srch_id = b.srch_id
GROUP BY b.booking_bool
ORDER BY srch_id_cnt DESC
LIMIT 10


-- (3) (2)のうち、Expedia.com（site = 5）のsrch_idの数（検索条件の件数）は「173,575」
SELECT
    CASE 
        WHEN site_id = 5 THEN "Expedia.com"
        ELSE "Others"
    END AS site_name,
    COUNT(Distinct(srch_id)) as srch_id_cnt,
    (1.0*COUNT(Distinct(srch_id))/
        (SELECT COUNT(Distinct(srch_id)) as srch_id_cnt FROM data WHERE booking_bool = 1)) as rate
FROM data
WHERE booking_bool = 1
GROUP BY
    CASE 
        WHEN site_id = 5 THEN "Expedia.com"
        ELSE "Other"
    END
ORDER BY srch_id_cnt DESC
LIMIT 10


-- (4) (3)のうち、居住地がUSA（visitor_location_country_id = 219）のsrch_idの数（検索条件の件数）は「158,464」
SELECT
    CASE 
        WHEN visitor_location_country_id = 219 THEN "USA"
        ELSE "Other"
    END AS visitor_location_country_name,
    COUNT(Distinct(srch_id)) as srch_id_cnt,
    (1.0*COUNT(Distinct(srch_id))/
        (SELECT COUNT(Distinct(srch_id)) as srch_id_cnt 
        FROM data WHERE booking_bool = 1 AND site_id = 5)) as rate
FROM data
WHERE booking_bool = 1
    AND site_id = 5
GROUP BY
    CASE 
        WHEN visitor_location_country_id = 219 THEN "USA"
        ELSE "Other"
    END
ORDER BY srch_id_cnt DESC
LIMIT 10


-- (5) (4)のうち、目的地がUSA（prop_country_id =219）のsrch_idの数（検索条件の件数）は「139,302」
SELECT
    CASE 
        WHEN prop_country_id = 219 THEN "USA"
        ELSE "Other"
    END AS prop_country_name,
    COUNT(Distinct(srch_id)) as srch_id_cnt,
    (1.0*COUNT(Distinct(srch_id))/
        (SELECT COUNT(Distinct(srch_id)) as srch_id_cnt 
        FROM data WHERE booking_bool = 1 
        AND site_id = 5 AND visitor_location_country_id = 219)) as rate
FROM data
WHERE booking_bool = 1
    AND site_id = 5
    AND visitor_location_country_id = 219
GROUP BY
    CASE 
        WHEN prop_country_id = 219 THEN "USA"
        ELSE "Other"
    END
ORDER BY srch_id_cnt DESC
LIMIT 10

-- 対象データ取得 --
SELECT *
FROM data
WHERE booking_bool = 1
    AND site_id = 5
    AND visitor_location_country_id = 219
    AND prop_country_id = 219