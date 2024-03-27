-- Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
SELECT month,
       SUM (totals.visits) as visits ,
       SUM (totals.pageviews) pageviews,
       SUM (totals.transactions) transactions
FROM (SELECT format_date('%Y%m',PARSE_DATE('%Y%m%d', date)) as month, *
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix between '0101' and '0331')
GROUP BY month
order bY month;

-- Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
SELECT trafficSource.source as source,
       SUM (totals.visits) as total_visits, 
       SUM (totals.bounces) as total_no_of_bounces, 
       SUM (totals.bounces)*100.0/SUM (totals.visits) as bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY source
order bY total_visits DESC;

-- Query 3: Revenue by traffic source by week, by month in June 2017
-- --Cach 1
WITH abc as (SELECT  CASE WHEN monthweek_by_source.month = '201706' then 'month' 
             WHEN monthweek_by_source.month<>'201706' then 'week' END as time_type,
        month as time,
        trafficSource.source as source,
        ((SUM(product.productRevenue))/1000000) as revenue
        
FROM(SELECT *, format_date('%Y%m',PARSE_DATE('%Y%m%d', date)) as month
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`
UNION ALL
SELECT *, format_date('%Y%W',PARSE_DATE('%Y%m%d', date)) as week
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`) as monthweek_by_source,
UNNEST (hits) hits,
UNNEST (hits.product) product
GROUP BY month,trafficSource.source)

SELECT time_type, time, source, ROUND(revenue,4) as revenue
FROM abc
WHERE revenue is not null
Order by revenue DESC;
-- --Cach 2
with month_data as (SELECT "Month" as timetype,
                    format_date("%Y%m",parse_date("%Y%m%d", date)),
                    trafficSource.source AS source,
                    sum (p.productRevenue)/1000000 AS revenue
                    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
                    UNNEST (hits) as hits,
                    UNNEST (hits.product) as p
                    WHERE p.productRevenue is not null
                    GROUP BY 1,2,3
                    order by revenue DESC),
    week_data as (SELECT "Week" as timetype,
                          format_date("%Y%W",parse_date("%Y%m%d", date)),
                          trafficSource.source AS source,
                          sum (p.productRevenue)/1000000 AS revenue
                  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
                  UNNEST (hits) as hits,
                  UNNEST (hits.product) as p
                  WHERE p.productRevenue is not null
                  GROUP BY 1,2,3
                  order by revenue DESC)
SELECT * FROM month_data
UNION ALL 
SELECT * FROM week_data 
ORDER BY revenue DESC;

-- Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
With pv_pur as (SELECT format_date('%Y%m',PARSE_DATE('%Y%m%d',date)) as month,
                       sum(totals.pageviews)/count(distinct fullVisitorID) as avg_pageviews_purchase
                FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,  
                UNNEST (hits) hits,
                UNNEST (hits.product) product
                WHERE _table_suffix between '0601' and '0731' and totals.transactions >=1 AND product.productRevenue is not NULL
                GROUP BY month),  
   pv_nonpur as (SELECT format_date('%Y%m',PARSE_DATE('%Y%m%d',date)) as month,
                        sum(totals.pageviews)/count(distinct fullVisitorID)as avg_pageviews_nonpurchase
                 FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,  
                 UNNEST (hits) hits,
                 UNNEST (hits.product) product
                 WHERE _table_suffix between '0601' and '0731' and totals.transactions is Null AND product.productRevenue is NULL
                 GROUP BY month) 
SELECT month, 
       avg_pageviews_purchase, 
       avg_pageviews_nonpurchase
FROM pv_pur
FULL JOIN pv_nonpur
USING (month)
ORDER BY month;

-- Query 05: Average number of transactions per user that made a purchase in July 2017
select
    format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
    sum(totals.transactions)/count(distinct fullvisitorid) as Avg_total_transactions_per_user
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    ,unnest (hits) hits,
    unnest(product) product
where  totals.transactions>=1
and totals.totalTransactionRevenue is not null
and product.productRevenue is not null
group by month;

-- Query 06: Average amount of money spent per session. Only include purchaser data in July 2017
SELECT format_date('%Y%m',PARSE_DATE('%Y%m%d',date)) as month,
       ROUND (((SUM(product.productRevenue)/SUM (totals.visits))/1000000),3) as avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, 
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE totals.transactions >=1 AND product.productRevenue is not NULL
GROUP BY month;

-- Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
SELECT 
       product.v2ProductName as other_purchased_products,
       sum(product.productQuantity) as quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, 
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE fullVisitorID in (SELECT fullVisitorID
                        FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`, 
                        UNNEST (hits) hits,
                        UNNEST (hits.product) product 
                          WHERE product.v2ProductName= "YouTube Men's Vintage Henley" and
                          product.productRevenue is not null)
  and product.v2productname <> "YouTube Men's Vintage Henley"
and product.productRevenue is not null
group by other_purchased_products
order by quantity desc;

-- "Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase
WITH num_pdv_atc as (SELECT format_date('%Y%m',PARSE_DATE('%Y%m%d',date)) as month,
       COUNT (case when hits.eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
      COUNT (case when hits.eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_addtocart,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE  _table_suffix between '0101' and '0331'
GROUP BY month),
    num_pur as (SELECT format_date('%Y%m',PARSE_DATE('%Y%m%d',date)) as month,
             COUNT (case when hits.eCommerceAction.action_type = '6' THEN product.v2ProductName END) as num_purchase 
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`, 
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE  _table_suffix between '0101' and '0331' and totals.transactions >=1 AND product.productRevenue is not NULL
GROUP BY month)

SELECT *,
       ROUND((num_addtocart*100.0/num_product_view),2) as add_to_cart_rate,
       ROUND((num_purchase*100.0/num_product_view),2) as purchase_rate
FROM num_pdv_atc
JOIN num_pur
USING (month)
ORDER BY month;
