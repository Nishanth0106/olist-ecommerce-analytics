-- Top Product Categories by Revenue
-- Purpose: Identify which categories drive revenue, and how order volume vs. 
-- price point differs across categories
-- Finding: Health & Beauty leads revenue, but category mix is diversified — 
-- high-value/low-volume (Watches & Gifts, $199 avg) alongside 
-- high-volume/low-value staples (Bed/Bath/Table, 9,272 orders, $93 avg).

SELECT 
  t.product_category_name_english as category,
  COUNT(DISTINCT oi.order_id) as total_orders,
  ROUND(SUM(oi.price), 2) as total_revenue,
  ROUND(AVG(oi.price), 2) as avg_item_price
FROM `olist_ecommerce.order_items` oi
JOIN `olist_ecommerce.products` p ON oi.product_id = p.product_id
JOIN `olist_ecommerce.category_translation` t ON p.product_category_name = t.product_category_name
JOIN `olist_ecommerce.orders` o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 15;
