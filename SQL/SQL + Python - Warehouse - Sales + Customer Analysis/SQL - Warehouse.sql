-- Build cleaned dim_table

Create table Dim_customer (
  customer_id varchar(50) primary key,
  name varchar(50),
  segment varchar(50),
  country varchar(50),
  city varchar(50),
  state varchar(50),
  postal_code int,
  region varchar(50));

Insert into Dim_customer (customer_id, name, segment, country, city, state, postal_code, region)
Select distinct
 trim ([ID]) as customer_id,
 trim ([NAME]) as name,
 trim ([SEGMENT]) as segment,
 trim ([COUNTRY]) as country,
 trim ([CITY]) as city,
 trim ([STATE]) as state,
 [POSTAL_CODE] as postal_code,
 trim ([REGION]) as region
From [dbo].[CUSTOMER]
Where [ID] is not null;

Create table Dim_employees (
  employee_id int primary key,
  name varchar(50),
  city varchar(50),
  region varchar(50));

Insert into Dim_employees (employee_id, name, city, region)
Select distinct
 [ID_EMPLOYEE] as employee_id,
 trim ([NAME]) as name,
 trim ([CITY]) as city,
 trim ([REGION]) as region
From [dbo].[EMPLOYEES]

Create table Dim_products (
  product_id varchar(50) primary key,
  name varchar(max),
  category varchar(max),
  subcategory varchar(max));

Insert into Dim_products (product_id, name, category, subcategory)
Select distinct
 trim([ID]) as product_id,
 trim ([NAME]) as name,
 trim ([CATEGORY]) as category,
 trim ([SUBCATEGORY]) as subcategory
From [dbo].[PRODUCT]
where [ID] is not null

-- Build cleaned facts_table
Create table Facts_orders (
 order_id varchar(50),
 order_date date,
 ship_date date,
 ship_mode varchar(50),
 customer_id varchar(50),
 product_id varchar(50),
 sales decimal(18,4),
 quantity int,
 discount decimal (5,4),
 profit decimal (18,4),
 employee_id int,
 profit_margin decimal (18,4),
 delivery_days int,
 FOREIGN KEY(customer_id) REFERENCES dim_customer(customer_id),
 FOREIGN KEY(product_id)  REFERENCES dim_products(product_id),
 FOREIGN KEY(employee_id) REFERENCES dim_employees(employee_id));

 Insert into Facts_orders (order_id, order_date, ship_date, ship_mode,customer_id, product_id, employee_id, sales, quantity, discount, profit, profit_margin, delivery_days)
 select distinct
 Trim ([ORDER_ID]) as order_id,
 [ORDER_DATE] as order_date,
 [SHIP_DATE] as ship_date,
 Trim ([SHIP_MODE]) as ship_mode,
 [CUSTOMER_ID] as customer_id,
 cast([PRODUCT_ID] as varchar(50)) as product_id,
 [ID_EMPLOYEE] as employee_id,
 cast([SALES] as decimal (10,2)) as sales,
 [QUANTITY] as quantity,
 cast([DISCOUNT] as decimal (2,2)) as discount,
 cast([PROFIT] as decimal (10,2)) as profit,
 cast([PROFIT] as decimal (10,2))/nullif (cast([SALES] as decimal (10,2)),0) as profit_margin,
 datediff (day,[ORDER_DATE],[SHIP_DATE]) AS delivery_days
 from [dbo].[ORDERS]
