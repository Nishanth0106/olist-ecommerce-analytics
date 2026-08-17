-- Geographic Revenue & Delivery Performance
-- Purpose: Identify revenue concentration and regional delivery/satisfaction patterns
-- Finding: SP drives ~40% of orders/revenue. Delivery time and satisfaction 
-- both correlate with distance from SP (fulfillment hub) — remote northern 
-- states (RR, AP, AM) see 26-29 day avg delivery vs. 8.7 days in SP.

SELECT 
  c.customer_state,
  COUNT(DISTINCT o.order_id) as total_orders,
  ROUND(SUM(p.payment_value), 2) as total_revenue,
  ROUND(AVG(DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_purchase_timestamp), DAY)), 1) as avg_delivery_days,
  ROUND(AVG(r.review_score), 2) as avg_review_score
FROM `olist_ecommerce.orders` o
JOIN `olist_ecommerce.customers` c ON o.customer_id = c.customer_id
JOIN `olist_ecommerce.order_payments` p ON o.order_id = p.order_id
JOIN `olist_ecommerce.order_reviews` r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
