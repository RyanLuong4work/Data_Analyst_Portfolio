# SQL + Python - Warehouse - Sales + Customers Analysis

## Project Overview

This project showcases my **end-to-end analytics workflow** where data is prepared with SQL and analyzed & visualized in Python. The goal is to provide insights into sales, profit, customers, employees, **Churn (RFM) Analysis and Delivery SLA Analysis** for a warehouse business.

---

## Dataset

The project uses **4 tables**:

1. **`ORDERS.csv`**  
   - Contains transactional sales data.  
   - **Key columns:** `ORDER_ID`, `ORDER_DATE`, `PRODUCT_ID`, `CUSTOMER_ID`, `ID_EMPLOYEE`, `SALES`, `DISCOUNT`, `PROFIT`, `STATE`.

2. **`PRODUCT.csv`**  
   - Contains product details.  
   - **Key columns:** `ID`, `CATEGORY`, `SUB_CATEGORY`, `PRODUCT_NAME`.

3. **`CUSTOMER.csv`**  
   - Contains customer demographic data.  
   - **Key columns:** `ID`, `CUSTOMER_NAME`, `SEGMENT`, `COUNTRY`, `STATE`, `CITY`.

4. **`EMPLOYEES.csv`**  
   - Contains sales employee information.  
   - **Key columns:** `ID_EMPLOYEE`, `NAME`, `DEPARTMENT`.

---

## Objectives

- Build clean datasets from warehouse using SQL.
- Apply **SQL and Python Skills** into project:
    - **SQL**: joins, aggregations, KPI calculations.
    - **Python**: pandas, numpy, matplotlib, seaborn.
    - **Analysis Areas**: sales, profit, margins, discounts, churn, SLA (delivery performance).
- Visualize sales performance and generate actionable business recommendations.
- Showcase SQL + Python skills for data analysis.

---

## SQL Stage
- Join fact and dimension tables.
- Clean and normalize data.
- Aggregate sales, profit, orders, margins.

---

## Python Stage
- Import database from SQL to Python
- Normalize fact + dimension tables
- Sales & Profit by Region, Category, Employee
- Top/Bottom 10 Customers by sales
- Trend Analysis (Year, Month)
- Discount vs Profit trade-off
- Profit Margin by Category
- Delivery SLA Analysis
- Customer Churn Analysis

---

## Business Recommendations
### 1. Maintan Customers Loyal
<img width="1229" height="655" alt="image" src="https://github.com/user-attachments/assets/c428cbff-f013-4d8a-ba9a-801c29787ade" />

- Focus on keeping existing customers, especially those at risk of leaving (customer group: At Risk)

### 2. Use Discounts Smarter
<img width="844" height="555" alt="image" src="https://github.com/user-attachments/assets/3b40f5ee-61f7-41f7-8a23-c8454754f42e" />

- Stop giving discounts that cut into profit.
- Offer promotions only to the right customer groups: Potential or Promising.

### 3. Grow in the Right Places
<img width="1963" height="577" alt="image" src="https://github.com/user-attachments/assets/6606152d-783b-4173-a5b4-77cb46793bcb" />

- Spend more effort and resources in regions where sales are strong.
- Investigate why some regions are weak (competition, distribution, demand).

<img width="997" height="999" alt="image" src="https://github.com/user-attachments/assets/f53cef2b-4457-4cfc-b261-506902481d3c" />

- Use past sales trends to plan ahead with suppliers.

<img width="1712" height="1091" alt="image" src="https://github.com/user-attachments/assets/5e0a1c06-fa22-4ee2-a7bd-9315bfd938a2" />
<img width="527" height="752" alt="image" src="https://github.com/user-attachments/assets/8b5f69a4-5fb3-4088-aa5c-c943d18cd2a8" />

- Invest in products and categories that bring in the most profit.
- Cut or fix products that sell poorly and make little money.

### 4. Support Employees (for e.g: Products training, Sales Skills training, etc)
<img width="1067" height="587" alt="image" src="https://github.com/user-attachments/assets/cb72102e-4fbb-4715-9dd9-6bf5a37be8d0" />
- Reward employees who bring in high sales and profits.
- Train employees who are underperforming.

### 5. Improve Delivery Performance
<img width="1698" height="722" alt="image" src="https://github.com/user-attachments/assets/6bab3da5-8005-42ad-af00-24b8d4d251ec" />

- Improve delivery times and reduce delays to keep customers happy.
- Use better planning tools to manage demand.

---
## How to Run

1. Load the CSV files into a SQL Server database (`dbo.ORDERS`, `dbo.PRODUCT`, `dbo.CUSTOMER`, `dbo.EMPLOYEES`).
2. Open `SQL - Warehouse.sql` in **SQL Server Management Studio (SSMS)**.
3. Execute queries
4. Open `Python - Warehouse.ipynb` in **Jupyter Notebook**.
5. Run All Cells

---

## Contact
- Name: Ryan Luong
- Email: [ryanluong4work@gmail.com](mailto:ryanluong4work@gmail.com)
- Linkedin: [https://www.linkedin.com/in/ryanluong4work](https://www.linkedin.com/in/ryanluong4work)
- Portfolio Website: [https://github.com/ryanluong4work](https://github.com/ryanluong4work)
