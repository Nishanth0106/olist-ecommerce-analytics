-- Customer Retention: Repeat vs. One-Time Purchase Behavior
-- Purpose: Understand what % of customers return, and their relative value
-- Finding: Only ~3% of customers are repeat buyers, though they spend ~2x more 
-- on average. Business is heavily acquisition-dependent. Possible link to 
-- delivery experience (see 03_delivery_vs_reviews.sql).

WITH customer_orders AS (
  SELECT 
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp,
    p.payment_value
  FROM `olist_ecommerce.orders` o
  JOIN `olist_ecommerce.customers` c ON o.customer_id = c.customer_id
  JOIN `olist_ecommerce.order_payments` p ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
),
rfm_base AS (
  SELECT 
    customer_unique_id,
    DATE_DIFF(DATE('2018-10-17'), DATE(MAX(order_purchase_timestamp)), DAY) as recency_days,
    COUNT(DISTINCT order_id) as frequency,
    ROUND(SUM(payment_value), 2) as monetary
  FROM customer_orders
  GROUP BY customer_unique_id
)
SELECT 
  CASE 
    WHEN frequency >= 2 THEN 'Repeat Customer'
    ELSE 'One-Time Customer'
  END as customer_type,
  COUNT(*) as customer_count,
  ROUND(AVG(recency_days), 1) as avg_recency_days,
  ROUND(AVG(monetary), 2) as avg_total_spent,
  ROUND(SUM(monetary), 2) as total_revenue_contribution
FROM rfm_base
GROUP BY customer_type;
