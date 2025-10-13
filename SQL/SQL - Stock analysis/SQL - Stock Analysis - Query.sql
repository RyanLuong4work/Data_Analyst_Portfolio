-- Create Dims and Facts table + setup table schema
--- create dim-companies table
create table dim_companies (
	company_id int identity(1,1) primary key,
	company_name NVARCHAR(20) NOT NULL
	);

insert into dim_companies (company_name)
values
 ('amazon'),
 ('apple'),
 ('facebook'),
 ('google'),
 ('netflix');

--- create dim_date table
create table dim_date (
	dateid int,
	fulldate date primary key not null,
	year int,
	quarter int,
	month int,
	monthname nvarchar(10),
	day int,
	dayofweek nvarchar(10)
	);

declare @startdate date = '1980-01-01';
declare @enddate date = '2025-12-31';
while @startdate <= @enddate
begin
	insert into dim_date (dateid,fulldate,year,quarter,month,monthname,day,dayofweek)
	values(
		convert(int,format(@startdate, 'yyyyMMdd')),
		@startdate,
		year(@startdate),
		DATEPART(quarter,@startdate),
		month(@startdate),
		datename(month,@startdate),
		day(@startdate),
		DATENAME(weekday,@startdate)
		);

		SET @startdate = dateadd(day,1,@startdate);
end;

--- create facts_stock table
create table fact_stock (
	stockid int identity(1,1) primary key,
	company_id int not null foreign key references dim_companies(company_id),
	fulldate date not null foreign key references dim_date(fulldate),
	openprice float,
	highprice float,
	lowprice float,
	closeprice float,
	adjustcloseprice float,
	volume bigint,
	);

insert into fact_stock (company_id,fulldate,openprice,highprice,lowprice,closeprice,adjustcloseprice,volume)
SELECT 1,[Date],[Open],[High],[Low],[Close],[Adj_Close],[Volume] FROM dbo.Amazon
UNION ALL
SELECT 3,[Date],[Open],[High],[Low],[Close],[Adj_Close],[Volume] FROM dbo.Facebook
UNION ALL
SELECT 4,[Date],[Open],[High],[Low],[Close],[Adj_Close],[Volume] FROM dbo.Google
UNION ALL
SELECT 5,[Date],[Open],[High],[Low],[Close],[Adj_Close],[Volume] FROM dbo.Netflix
UNION ALL
SELECT 2,[Date],[Open],[High],[Low],[Close],[Adj_Close],[Volume] FROM dbo.Apple

-- Descriptive Metrics
--- Highest close & date for each company
select  c.company_name, max(s.closeprice) as close_price from fact_stock as s join dim_companies as c on s.company_id = c.company_id group by c.company_name;
select  c.company_name, min(s.closeprice) as close_price from fact_stock as s join dim_companies as c on s.company_id = c.company_id group by c.company_name;

--- Average daily volume per year per company
select c.company_name, AVG(s.volume) as avg_daily_volume, DATEPART(year,s.fulldate) as year from fact_stock as s join dim_companies as c on s.company_id = c.company_id group by c.company_name,datepart(year,s.fulldate) order by c.company_name, [year];

--- For a given year, list the top 5 days with biggest single-day percentage increase in closing price (i.e. (close − open)/open) for each company.
declare @year int = 2000; -- insert given year

with 
daily as (
	select
		company_id,
		fulldate,
		openprice,
		closeprice,
		cast((closeprice - openprice)/NULLIF(openprice, 0.0) as float) as percentage_increase
	from fact_stock
	where year(fulldate) = @year and openprice is not null and closeprice is not null
	),

ranking as (
	select company_id, fulldate,openprice, closeprice, percentage_increase,
		rank () over (partition by company_id order by percentage_increase desc, fulldate) as rank
	from daily)

select c.company_name, r.rank, r.fulldate, r.openprice, r.closeprice, 
	cast(r.percentage_increase * 100.0 AS float) as percentage_increase

from dim_companies as c join ranking as r on c.company_id = r.company_id 
where r.rank <= 5 
order by company_name, r.rank;

-- Time Series / Window Analysis
--- Monthly returns (percentage change) for each company
with 
month_end_price as (
	select
		company_id,
		fulldate,
		coalesce(adjustcloseprice, closeprice) as month_end_price,
		EOMONTH(fulldate) as month_end
		from fact_stock
		),
month_end_rows as (
	select
		company_id,
		month_end,
		fulldate,
		month_end_price,
		ROW_NUMBER() over (partition by company_id, month_end order by fulldate desc) as row_number
		from month_end_price
		),
month_end_prices as (
	select
		company_id,
		month_end,
		month_end_price
		from month_end_rows where row_number=1
		),
monthly_return as (
	select
		company_id,
		month_end,
		month_end_price,
		lag(month_end_price) over (partition by company_id order by month_end) as prev_month_end_price
	from month_end_price
	)
select
	c.company_name,
	m.month_end,
	m.month_end_price,
	m.prev_month_end_price,
	CASE
		WHEN m.prev_month_end_price is null or m.prev_month_end_price =0
		then null
		else (m.month_end_price * 1.0 / m.prev_month_end_price)  - 1.0
	end as MOM_return
from monthly_return as m join dim_companies as c on c.company_id=m.company_id
where m.prev_month_end_price is not null
order by c.company_name,m.month_end;

--- 7-day / 30-day moving averages for closing price
with
price as (
	select
		company_id,
		fulldate,
		coalesce(adjustcloseprice,closeprice) as end_price
	from fact_stock
	),
moving_average as (
	select
		company_id,
		fulldate,
		end_price,
		avg(end_price) over (partition by company_id order by fulldate rows between 6 preceding and current row) as ma_7_day,
		avg(end_price) over (partition by company_id order by fulldate rows between 29 preceding and current row) as ma_30_day,
		count(*) over (partition by company_id order by fulldate rows between 6 preceding and current row) as count_7_day,
		count(*) over (partition by company_id order by fulldate rows between 29 preceding and current row) as count_30_day
	from price
	)
select 
	c.company_name,
	m.fulldate,
	m.end_price,
	m.ma_7_day,
	m.ma_30_day
from moving_average as m join dim_companies as c on c.company_id = m.company_id
where m.count_7_day = 7 and m.count_30_day = 30
order by c.company_name, m.fulldate;
