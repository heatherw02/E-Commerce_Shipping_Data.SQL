-- 0)** Reusable on-time flag (1 means on time, 0 not on time **
-- overall on-time rate
WITH s AS (
  SELECT CASE WHEN "Reached.on.Time_Y.N" = 1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT ROUND(AVG(on_time)*100.0, 2) AS on_time_rate_pct
FROM s


SELECT DISTINCT "Reached.on.Time_Y.N"
FROM Shipping_Data

-- 1) How often are package on time?
-- 1.1)Do shipping mode affect reliability?
WITH s AS (
  SELECT Mode_of_Shipment,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT Mode_of_Shipment,
       COUNT(*) AS n_orders,
       ROUND(AVG(on_time)*100.0, 2) AS on_time_rate_pct
FROM s
GROUP BY Mode_of_Shipment
ORDER BY on_time_rate_pct DESC

-- 1.2) Do shipping warehouse affect reliability?
WITH s AS (
  SELECT Warehouse_block,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT Warehouse_block,
       COUNT(*) AS n_orders,
       ROUND(AVG(on_time)*100.0, 2) AS on_time_rate_pct
FROM s
GROUP BY Warehouse_block
ORDER BY on_time_rate_pct DESC

-- 1.3) warehouse × mode heatmap
WITH s AS (
  SELECT Warehouse_block, Mode_of_Shipment,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT Warehouse_block, Mode_of_Shipment,
       COUNT(*) AS n_orders,
       ROUND(AVG(on_time)*100.0,2) AS on_time_rate_pct
FROM s
GROUP BY Warehouse_block, Mode_of_Shipment
HAVING COUNT(*) >= 30
ORDER BY on_time_rate_pct ASC
LIMIT 10

-- 2)How do discounts impact delivery?
WITH s AS (
  SELECT CASE
           WHEN Discount_offered < 5  THEN '0–4%'
           WHEN Discount_offered < 10 THEN '5–9%'
           WHEN Discount_offered < 20 THEN '10–19%'
           ELSE '20%+'
         END AS discount_bucket,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT discount_bucket, COUNT(*) AS n_orders,
       ROUND(AVG(on_time)*100.0,2) AS on_time_rate_pct
FROM s
GROUP BY discount_bucket
ORDER BY MIN(discount_bucket)

-- 3) How do package weight impact delivery?
WITH ranked AS (
  SELECT *,
         NTILE(4) OVER (ORDER BY Weight_in_gms) AS q,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT 'Q'||q AS weight_bucket,
       ROUND(AVG(Weight_in_gms),0) AS avg_weight_g,
       COUNT(*) AS n_orders,
       ROUND(AVG(on_time)*100.0,2) AS on_time_rate_pct
FROM ranked
GROUP BY q
ORDER BY q

-- 4) Customer Experience: What is the link between delivery performance and customer satisfaction?

-- 4.1) rating vs on-time
WITH s AS (
  SELECT Customer_rating,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT Customer_rating, COUNT(*) n_orders,
       ROUND(AVG(on_time)*100.0,2) on_time_rate_pct
FROM s
GROUP BY Customer_rating
ORDER BY Customer_rating

-- 4.2) care-calls vs late rate
WITH s AS (
  SELECT Customer_care_calls,
         CASE WHEN "Reached.on.Time_Y.N"=1 THEN 1 ELSE 0 END AS on_time
  FROM Shipping_Data
)
SELECT Customer_care_calls, COUNT(*) n_orders,
       ROUND(100.0-AVG(on_time)*100.0,2) AS late_rate_pct
FROM s
GROUP BY Customer_care_calls
ORDER BY Customer_care_calls




