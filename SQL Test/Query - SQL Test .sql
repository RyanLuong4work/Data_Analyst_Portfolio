-- QUESTION 1:
/* 
Write an SQL query to calculate the total sales of furniture products, grouped by each quarter of the year, 
and order the results chronologically. 
*/
SELECT CONCAT('Q',DATEPART(QUARTER,[ORDER_DATE]),' - ',DATEPART(YEAR,[ORDER_DATE])) AS Quarter_Year, CAST(SUM(SALES)AS DECIMAL(10,2)) AS Total_Sales 
FROM [dbo].[ORDERS] 
WHERE [PRODUCT_ID] LIKE 'FUR%' 
GROUP BY DATEPART(QUARTER,[ORDER_DATE]),DATEPART(YEAR,[ORDER_DATE]) 
ORDER BY DATEPART(YEAR,[ORDER_DATE]) ASC, DATEPART(QUARTER,[ORDER_DATE]) ASC;

-- QUESTION 2:
/* 
Analyze the impact of different discount levels ON sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification.

Discount level condition:
No Discount = 0
0 < Low Discount <= 0.2
0.2 < Medium Discount <= 0.5
High Discount > 0.5 
*/
SELECT
	[CATEGORY] AS CATEGORY, 
	CASE WHEN [DISCOUNT] = 0 THEN 'No Discount'
		WHEN [DISCOUNT] > 0 AND [DISCOUNT] <= 0.2 THEN 'Low Discount'
		WHEN[DISCOUNT] > 0.2 AND [DISCOUNT] <= 0.5 THEN 'Medium Discount'
		ELSE 'High Discount'
	END AS Discount_Class,
	COUNT([ORDER_ID]) AS Number_of_Orders,
	CAST(SUM([PROFIT])AS DECIMAL(10,2)) AS Total_Profit 
FROM [dbo].[PRODUCT] INNER JOIN [dbo].[ORDERS] ON [ID]=[PRODUCT_ID]
GROUP BY [CATEGORY], 
	CASE WHEN [DISCOUNT] = 0 THEN 'No Discount'
		WHEN [DISCOUNT] > 0 AND [DISCOUNT] <= 0.2 THEN 'Low Discount'
		WHEN[DISCOUNT] > 0.2 AND [DISCOUNT] <= 0.5 THEN 'Medium Discount'
		ELSE 'High Discount'
	END
ORDER BY [CATEGORY] ASC;
-- QUESTION 3:
/* 
Determine the top-performing product categories within each customer segment based ON sales and profit, 
focusing specifically ON those categories that rank within the top two for profitability. 

*/
WITH Total_Sales_Profits_CTE AS(
	SELECT [SEGMENT] AS SEGMENT, 
		[CATEGORY] AS CATEGORY,
		SUM([SALES]) AS total_sales,
		SUM([PROFIT]) AS total_profit
	FROM [dbo].[ORDERS] JOIN [dbo].[CUSTOMER] ON [ID]=[CUSTOMER_ID]
	JOIN [dbo].[PRODUCT] AS PD ON [PRODUCT_ID] =PD.[ID]
	GROUP BY [SEGMENT],[CATEGORY]),
RANK_CTE AS(
	SELECT *,
		RANK()OVER(PARTITION BY SEGMENT ORDER BY total_profit DESC) AS PROFIT_RANK,
		RANK()OVER(PARTITION BY segment ORDER BY total_sales DESC) AS SALES_RANK
	FROM Total_Sales_Profits_CTE)

SELECT SEGMENT,CATEGORY,SALES_RANK,PROFIT_RANK
FROM RANK_CTE
WHERE Profit_Rank <= 2
ORDER BY segment, Profit_Rank ASC;
-- QUESTION 4
/*
Create a report that displays each employee's performance across different product categories, showing not only the 
total profit per category but also what percentage of their total profit each category represents, WITH the result 
ordered by the percentage in descending order for each employee.
*/

WITH category_profit AS(
	SELECT E.[ID_EMPLOYEE],
			[CATEGORY],
			CAST(SUM([PROFIT]) AS DECIMAL (10,2)) AS Rounded_Total_Profit
	FROM [dbo].[ORDERS] AS O 
	JOIN [dbo].[EMPLOYEES] AS E ON O.[ID_EMPLOYEE]= E.[ID_EMPLOYEE]
	JOIN [dbo].[PRODUCT] AS P ON O.[PRODUCT_ID] = P.[ID]
	GROUP BY E.[ID_EMPLOYEE],[CATEGORY]),
Employee_profit AS (
	SELECT [ID_EMPLOYEE],SUM([PROFIT]) AS ETP
	FROM [dbo].[ORDERS]
	GROUP BY [ID_EMPLOYEE])
SELECT
	category_profit.[ID_EMPLOYEE], category_profit.[CATEGORY],category_profit.Rounded_Total_Profit,
	ROUND(category_profit.Rounded_Total_Profit*100/ETP,2) AS Profit_Percentage
FROM category_profit JOIN Employee_profit ON category_profit.[ID_EMPLOYEE]=Employee_profit.[ID_EMPLOYEE]
GROUP BY category_profit.[ID_EMPLOYEE], category_profit.[CATEGORY],Rounded_Total_Profit,ETP
ORDER BY category_profit.[ID_EMPLOYEE] ASC, Profit_Percentage DESC;

-- QUESTION 5:
/*
Develop a user-defined function in SQL Server to calculate the profitability ratio for each product category 
an employee has sold, and then apply this function to generate a report that sorts each employee's product categories
by their profitability ratio.
*/

create function dbo.profitabilityratio
( @TotalSales DECIMAL(20,2), @TotalProfit DECIMAL(20,2)) returns DECIMAL(20,2)
AS
BEGIN
	DECLARE @pratio DECIMAL(20,2)
	SET @pratio=@TotalProfit/@TotalSales
	RETURN @pratio
END

SELECT [ID_EMPLOYEE], [CATEGORY], CAST(SUM([SALES]) AS DECIMAL (20,2)) AS Total_Sales, CAST(SUM([PROFIT]) AS DECIMAL(20,2)) AS Total_Profit, dbo.profitabilityratio(SUM([SALES]),SUM([PROFIT])) AS Profitability_Ratio
FROM [dbo].[ORDERS] JOIN [dbo].[PRODUCT] ON [ID]=[PRODUCT_ID]
GROUP BY [ID_EMPLOYEE],[CATEGORY]
ORDER BY [ID_EMPLOYEE] ASC, Profitability_Ratio DESC

-- QUESTION 6:
/* 
Write a stored procedure to calculate the total sales and profit for a specific EMPLOYEE_ID over a specified date range. 
The procedure should accept EMPLOYEE_ID, StartDate, and EndDate AS parameters.
*/
CREATE PROCEDURE GetEmployeeSalesProfit
	@EmployeeID INT,
	@StartDate DATE,
	@EndDate DATE
AS
BEGIN
SELECT [NAME] AS EMPLOYEE_NAME, CAST(SUM([SALES]) AS DECIMAL(10,2)) AS TOTAL_SALES, CAST(SUM([PROFIT]) AS DECIMAL(10,2)) AS TOTAL_PROFIT
FROM [dbo].[EMPLOYEES] AS E JOIN [dbo].[ORDERS] AS O ON E.[ID_EMPLOYEE]=O.[ID_EMPLOYEE]
WHERE o.[ID_EMPLOYEE]=@EmployeeID AND [ORDER_DATE] BETWEEN @StartDate AND @EndDate
GROUP BY [NAME];
END;

EXEC GetEmployeeSalesProfit @EmployeeID = 3, @StartDate = '2016-12-01',@EndDate = '2016-12-31'
-- QUESTION 7:
/*
Write a query using dynamic SQL query to calculate the total profit for the last six quarters in the datasets, 
pivoted by quarter of the year, for each state.
*/

