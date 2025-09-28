# 📦 E-Commerce Shipping Data Analysis (SQL + DBeaver)

## Overview
This project explores an **E-Commerce Shipping dataset** (Kaggle) using **SQL in SQLite/DBeaver**.  
The goal was to evaluate **delivery performance (on-time rates)** and uncover operational, business, and customer experience insights.  

Key questions answered:
- How often do shipments arrive on time?
- Do shipping mode and warehouse affect reliability?
- How do discounts and package weight impact delivery?
- What is the link between delivery performance and customer satisfaction?

---

## 📂 Dataset
- Source: [Kaggle – E-Commerce Shipping Data](https://www.kaggle.com/datasets/prachi13/customer-analytics)  
- Records: ~11,000 shipments  
- Key fields:
  - `Mode_of_Shipment` (Ship, Flight, Road)  
  - `Warehouse_block` (A–F)  
  - `Discount_offered` (%)  
  - `Weight_in_gms`  
  - `Customer_rating` (1–5)  
  - `Customer_care_calls` (# of calls)  
  - `Reached.on.Time_Y.N` (1 = On-time, 0 = Late)  

---
## SQL Workflow
1. Imported CSV into **SQLite** via **DBeaver**.  
2. Built reusable flag for on-time deliveries:  
   ```sql
   CASE WHEN "Reached.on.Time_Y.N" = 1 THEN 1 ELSE 0 END AS on_time

---
## Results
- **1. Overall Performance**: 59.7% of orders arrived on time
- **2. Shipment Mode x Warehouse**:
    - Flight slightly outperforms Ship/Road (~60% vs 59%).
    - Road shipments from Warehouses A, B, C have the lowest on-time rates (~57–          58%).
- **3. Discount**:
    - Low discounts (≤9%) → ~47% on-time.
    - 10–19% discounts → improve to ~65%.
    - 20%+ discounts → dataset shows 100% on-time (synthetic but indicates prioritization).
- **4. Package Weight**:
    - Light (Q1 ~1.4kg) → 68% on-time.
    - Medium (Q2 ~3kg) → best at 86% on-time.
    - Heavy (Q3–Q4 ≥4.5kg) → worst, only ~42% on-time.
- **5. Customer Ratings**:
    - Orders rated 3–5 stars → ~60–61% on-time.
    - Orders rated 1–2 stars → ~59% on-time.
- **6. Customer care Calls**:
    - 2–3 calls: late rate ~35–37%.
    - 6–7 calls: late rate ~48%.

---
## Recommendations
- Prioritize improvements in Road shipments from Warehouses A–C.
- Review heavy package logistics → potential investment in equipment or partners.
- Maintain strong SLA compliance for promotional/discounted orders.
- Track customer service costs linked to late deliveries; reducing delays can cut     call volumes.

---
## [Tableau](https://public.tableau.com/views/E-CommerceShippingReliabilityDashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) 

---
## Next Steps (WIP)
- Build Tableau dashboard for KPI monitoring.
- Expand analysis to include predictive modeling (e.g., factors predicting late delivery).
- Normalize dataset into relational schema to practice JOIN queries.
