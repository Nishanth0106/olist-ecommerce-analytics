# Olist E-Commerce Analytics

SQL + Tableau analysis of a real Brazilian e-commerce dataset (2016-2018), 
covering ~99K orders across 9 relational tables. This project follows the 
Ask → Prepare → Process → Analyze → Share → Act framework to investigate 
revenue trends, delivery performance, and customer behavior, ending in 
concrete business recommendations.

## 1. Ask

Key business questions this analysis answers:

1. What are the revenue trends over time, and which categories drive the most revenue?
2. Does delivery time affect customer satisfaction (review scores)?
3. Which regions generate the most revenue, and where is delivery performance worst?
4. Who are the highest-value customers (RFM segmentation)?
5. What % of customers make repeat purchases, and does delivery experience affect retention?

Additional supporting questions (documented but not dashboarded):
- Payment method / installment patterns
- Seller performance outliers
- Freight cost as % of order value by region
- Multi-factor drivers of low review scores

## 2. Prepare

**Data source:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

- 9 relational CSV files: orders, customers, order_items, order_payments, 
  order_reviews, products, sellers, geolocation, category_translation
- ~99,441 orders, spanning September 2016 to October 2018
- Data loaded into Google BigQuery for SQL analysis

## 3. Process

Data quality checks performed before analysis (see `sql/01_data_quality_checks.sql`):

- **Row counts validated** across all 9 tables — no unexpected loading issues
- **CSV parsing issue found and fixed:** `order_reviews` failed to load due to 
  unescaped quote characters within free-text review comments. Fixed by enabling 
  "quoted newlines" in BigQuery's CSV import settings.
- **`category_translation` table initially loaded with the header row misread 
  as data**, due to BigQuery auto-detect misinterpreting the file structure. 
  Fixed by skipping the header row on import and explicitly renaming columns via SQL.
- **2.98% of orders (2,965) have no recorded delivery date** — cross-referenced 
  against order status and confirmed these are non-delivered orders (canceled, 
  unavailable, processing, etc.), not a data defect.
- **2016 is a partial year** (only Sept-Dec, with just 1 order in December) — 
  excluded from year-over-year comparisons to avoid misleading conclusions.
- **No duplicate order IDs found** — primary table integrity confirmed.

## 4. Analyze

### Revenue Trends & Top Categories (`sql/02_revenue_trends.sql`, `sql/06_top_categories.sql`)
Revenue grew consistently from late 2016 through 2018, driven primarily by 
**order volume growth rather than increased average order value** 
(AOV stable in the $150-175 range throughout). November 2017 shows a clear 
seasonal spike (7,289 orders, $1.15M) consistent with Black Friday. 
Note: Sept-Oct 2018 reflects a data export cutoff, not a real sales decline — 
these final months are excluded from trend conclusions.

Revenue is diversified across a healthy mix of category types:

| Category | Orders | Total Revenue | Avg Item Price |
|---|---|---|---|
| Health & Beauty | 8,647 | $1.23M | $130.28 |
| Watches & Gifts | 5,495 | $1.17M | $199.04 |
| Bed, Bath & Table | 9,272 | $1.02M | $93.44 |
| Sports & Leisure | 7,530 | $954.9K | $113.25 |
| Computers Accessories | 6,530 | $888.7K | $116.26 |

The top categories span both high-value/lower-volume items (Watches & Gifts) 
and high-volume/lower-value staples (Bed, Bath & Table) — indicating a 
diversified revenue base rather than dependence on a single category type.

### Delivery Time vs. Review Score (`sql/03_delivery_vs_reviews.sql`)
Strong negative correlation between delivery time and customer satisfaction:

| Delivery Time | Orders | Avg Review Score |
|---|---|---|
| 0-7 days | 30,679 | 4.41 |
| 8-14 days | 37,985 | 4.30 |
| 15-21 days | 16,170 | 4.12 |
| 22-30 days | 7,314 | 3.55 |
| 30+ days | 4,205 | 2.20 |

Review scores drop by more than 2 points between the fastest and slowest 
delivery buckets. ~4.4% of delivered orders took over 30 days.

### Geographic Revenue & Delivery Performance (`sql/04_geographic_analysis.sql`)
Revenue is heavily concentrated in São Paulo (SP), which accounts for ~40% of 
total orders and revenue (40,265 orders, $5.77M) — a notable concentration risk. 
Delivery time and customer satisfaction both correlate with distance from SP, 
the apparent fulfillment hub:

| State | Orders | Avg Delivery (days) | Avg Review Score |
|---|---|---|---|
| SP | 40,265 | 8.7 | 4.25 |
| RJ | 12,211 | 15.3 | 3.97 |
| MG | 11,285 | 11.9 | 4.19 |
| BA | 3,229 | 19.1 | 3.93 |
| RR (slowest) | 41 | 29.3 | 3.90 |

Remote northern/northeastern states see delivery times 2-3x longer than SP, 
with generally lower satisfaction. This suggests delivery delays are 
structurally tied to distance from the fulfillment hub, rather than a uniform 
logistics problem — pointing toward regional fulfillment or better delivery-time 
expectations at checkout for distant states, rather than a blanket fix.

### Customer Retention (`sql/05_rfm_segmentation.sql`)
Only ~3% of customers (2,801 of 93,357) made a repeat purchase, though repeat 
customers spend nearly 2x more on average ($308.59 vs. $160.76). Despite this 
higher per-customer value, repeat customers contribute only ~5.6% of total 
revenue ($864K of ~$15.4M) due to their small numbers — the business is heavily 
acquisition-dependent rather than retention-driven.

This raises a hypothesis worth testing further: given the strong link between 
delivery time and review score (above), poor post-purchase experience — 
particularly delivery delays — may be suppressing repeat purchase behavior. 
Improving delivery reliability could plausibly improve retention, not just 
one-time satisfaction.

## 5. Share

Interactive dashboard: **[Tableau Public link — coming soon]**

## 6. Act

*(Recommendations added once full analysis is complete)*

## Tools Used
- **BigQuery** — data storage and SQL analysis
- **Tableau Public** — dashboard and visualization
- **SQL** — CTEs, window functions, joins across relational tables

## Repo Structure
```
sql/           → all analysis queries, one file per business question
findings/      → detailed written findings and recommendations
dashboard/     → link to published Tableau dashboard
```
