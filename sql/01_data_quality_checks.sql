-- Data Quality Checks
-- Purpose: Validate row counts, nulls, duplicates, and date ranges before analysis

-- Row counts across all tables
SELECT 'orders' as table_name, COUNT(*) as row_count FROM `olist_ecommerce.orders`
UNION ALL
SELECT 'customers', COUNT(*) FROM `olist_ecommerce.customers`
UNION ALL
SELECT 'order_items', COUNT(*) FROM `olist_ecommerce.order_items`
UNION ALL
SELECT 'order_payments', COUNT(*) FROM `olist_ecommerce.order_payments`
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM `olist_ecommerce.order_reviews`
UNION ALL
SELECT 'products', COUNT(*) FROM `olist_ecommerce.products`
UNION ALL
SELECT 'sellers', COUNT(*) FROM `olist_ecommerce.sellers`
UNION ALL
SELECT 'geolocation', COUNT(*) FROM `olist_ecommerce.geolocation`
UNION ALL
SELECT 'category_translation', COUNT(*) FROM `olist_ecommerce.category_translation`;

-- Missing delivery dates
SELECT 
  COUNT(*) as total_orders,
  COUNTIF(order_delivered_customer_date IS NULL) as missing_delivery_date,
  ROUND(COUNTIF(order_delivered_customer_date IS NULL) / COUNT(*) * 100, 2) as pct_missing
FROM `olist_ecommerce.orders`;

-- Order status breakdown
SELECT order_status, COUNT(*) as count
FROM `olist_ecommerce.orders`
GROUP BY order_status
ORDER BY count DESC;

-- Date range
SELECT 
  MIN(order_purchase_timestamp) as earliest_order,
  MAX(order_purchase_timestamp) as latest_order
FROM `olist_ecommerce.orders`;

-- Duplicate order ID check (should return zero rows)
SELECT order_id, COUNT(*) as cnt
FROM `olist_ecommerce.orders`
GROUP BY order_id
HAVING cnt > 1;
