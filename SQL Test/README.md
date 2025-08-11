# SQL Test Project

## Project Overview
This project showcases my SQL data analysis skills through a series of **business-driven analytical queries** using SQL Server Management Studio 21  
The dataset simulates a retail sales environment, containing orders, products, customers, and employee dataset.

---

## Dataset
The project uses **4 relational tables**:

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

## SQL Exercises & Business Questions
The `Final Test.sql` file contains **6 advanced SQL tasks**:

**1.** Calculate the total sales of furniture products, grouped by each quarter of the year, and order the results chronologically

**2.** Analyze the impact of different discount levels on sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification.

**3.** Determine the top-performing product categories within each customer segment based on sales and profit, focusing specifically on those categories that rank within the top two for profitability.

**4.** Create a report that displays each employee's performance across different product categories, showing not only the total profit per category but also what percentage of their total profit each category represents, with the result ordered by the percentage in descending order for each employee.

**5.** Develop a user-defined function in SQL Server to calculate the profitability ratio for each product category an employee has sold, and then apply this function to generate a report that sorts each employee's product categories by their profitability ratio.

**6.** Write a stored procedure to calculate the total sales and profit for a specific EMPLOYEE_ID over a specified date range. The procedure should accept EMPLOYEE_ID, StartDate, and EndDate as parameters

---

## Skills Demonstrated
- SQL Joins
- Aggregate Functions
- Window Functions
- CTEs (Common Table Expressions)
- CASE Statements
- User-Defined Functions (UDF)
- Stored Procedures
- Pivoting Table

---

## How to Run
1. Load the CSV files into a SQL Server database (`dbo.ORDERS`, `dbo.PRODUCT`, `dbo.CUSTOMER`, `dbo.EMPLOYEES`).
2. Open `Final Test.sql` in **SQL Server Management Studio (SSMS)**.
3. Execute queries sequentially to reproduce analysis.
