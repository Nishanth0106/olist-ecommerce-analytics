-- Delivery Time vs. Review Score
-- Purpose: Test whether delivery speed impacts customer satisfaction
-- Finding: Strong negative correlation — review scores drop from 4.41 (0-7 days) 
-- to 2.20 (30+ days) as delivery time increases.

SELECT 
  CASE 
    WHEN DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY) <= 7 THEN '0-7 days'
    WHEN DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY) <= 14 THEN '8-14 days'
    WHEN DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY) <= 21 THEN '15-21 days'
    WHEN DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_purchase_timestamp), DAY) <= 30 THEN '22-30 days'
    ELSE '30+ days'
  END as delivery_time_bucket,
  COUNT(*) as order_count,
  ROUND(AVG(r.review_score), 2) as avg_review_score
FROM `olist_ecommerce.orders` o
JOIN `olist_ecommerce.order_reviews` r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_time_bucket
ORDER BY 
  CASE delivery_time_bucket
    WHEN '0-7 days' THEN 1
    WHEN '8-14 days' THEN 2
    WHEN '15-21 days' THEN 3
    WHEN '22-30 days' THEN 4
    ELSE 5
  END;
