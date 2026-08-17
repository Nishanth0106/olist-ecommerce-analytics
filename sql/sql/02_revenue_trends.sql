-- Revenue Trends by Month
-- Purpose: Track order volume, revenue, and average order value over time
-- Note: Filtered to 'delivered' status only. 2016 and Sept-Oct 2018 reflect 
-- partial data availability, not true seasonal decline.

SELECT 
  FORMAT_TIMESTAMP('%Y-%m', order_purchase_timestamp) as year_month,
  COUNT(DISTINCT o.order_id) as total_orders,
  ROUND(SUM(p.payment_value), 2) as total_revenue,
  ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) as avg_order_value
FROM `olist_ecommerce.orders` o
JOIN `olist_ecommerce.order_payments` p ON o.order_id = p.order_id
WHERE order_status = 'delivered'
GROUP BY year_month
ORDER BY year_month;
