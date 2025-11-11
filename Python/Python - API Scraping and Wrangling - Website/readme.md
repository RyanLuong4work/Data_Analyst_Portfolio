## Competitor's Analysis (Market Research) Project

### 1. Overview

This project tracks and compares the online inventories of **3 used car dealerships** ([Cars24](https://www.cars24.com.au/buy-used-cars-australia), [Cheap Car Co](https://www.cheapcarco.com.au/used-vehicles-rocklea/list), [Brisbane Auto Group](https://www.brisbaneautogroup.com.au))

Every day, I automatically collect (crawl) the car listings from each dealer’s website, store them in a structured table, and then build Power BI dashboards. The goal is to give managers a view of competitors’ pricing and inventory strategy, instead of just looking at their websites manually.

### 2. Business questions and answers:

### 3. Data & Methodolog (Techniqal Explanation)
#### 3.1 Data Source

- 3 car dealership websites (public used-car listings):
  - [Cars24](https://www.cars24.com.au/buy-used-cars-australia)
  - [Cheap Car Co](https://www.cheapcarco.com.au/used-vehicles-rocklea/list)
  - [Brisbane Auto Group](https://www.brisbaneautogroup.com.au)
- Data collected directly from their car listing pages:
  - Car Make / model / year
  - Price
  - Odometer (km)
  - Body type
  - Fuel type
  - Transmission type
  - Listing URL
  - **Crawl date**

#### 3.2 Daily Crawling Logic
- A Python script (using Selenium & BeautifulSoup) runs once per day.
- For each website, it:
  - Opens the listing pages
  - Scrolls / clicks through to load all cars
  - Save to HTML file
  - Extracts key details for each car
  - Save to raw CSV file
  - Wrangling Data
  - Save to final CSV file

#### 3.3 Logic/How can i track sold car
Because the websites don’t say directly “sold on this date”, I infer it from appearance/disappearance:
- Each **car is identified** by a unique combination of fields (all columns except crawl date).
- For each car, I track the **dates it appears** in the daily crawl -> If a car appears on multiple dates and then **stops appearing**, I treat that as sold car -> **The car was sold or removed on the date it disappeared**. Then i marked it in 'Sold' column and 'Sold Date' column will be first date it disappear.

This allows me to estimate:
- Days on market (last seen date – first seen date)
- Number of cars sold over time, per dealer, brand, etc.
- Delearship Revenue

### 4. Tools and their roles
#### 4.1 Python – Data Collection & Cleaning (Crawling and Wrangling)
Python is the ETL engine (Extract – Transform – Load).
**Main libraries:** selenium, BeautifulSoup, Pandas
**Main tasks:**
- **Web crawling:**
  - Open each dealership website.
  - Handle pagination or infinite scroll to load all cars.
  - Collect page source (page_source) or specific HTML elements.
- **Web scraping (extraction):**
  - Use BeautifulSoup to parse HTML.
  - Extract key fields: title, price, odometer, URL, etc.

- **Data cleaning & Normalise:**
  - Convert text prices (e.g. "$23,990") into numeric values.
  - Normalise odometer values (e.g. "45,000 km" → 45000) and group it (e.g. "71,291 km" -> "60,000 - 80,000 km").
  - Extract Make (e.g. BMW, Mazda), Year (e.g. 2010, 2019), Model (e.g C300, Civic) from Title.
  - Normalise Transmission (e.g. "6 SP Dual Clutch Automatic", "8 sport automatic" -> "automatic").
  - Normalise Fuel_type (e.g "Premium Petrol", "98 Petrol" -> "petrol")
  - Add crawl_date and compute the sold flag logic.
  - Save to a clean master CSV that Power BI and Excel can read.
    
#### 4.2 Excel – Validation
**Main tasks:**

- **Quick quality checks:**
  - Spot-check random samples of the data.
  - Confirm that prices, odometer readings, and car details look realistic.

- **Manual cleaning**
  - Check quality of dataset before cleaning step in python.
  - Fix obvious data entry or scraping anomalies (e.g. missing transmission but visible in image or text).
 
#### 4.3 Power BI – Analysis & Visualisation
**Main tasks:**
- **Data modelling**
  - Load the cleaned CSV.
  - Create relationships (e.g. dealers, brands, dates).
  - Build calculated columns/measures.

- **Dashboard & report building**
  - Visualize.
  - Provide clear, interactive dashboards where stakeholders can drill down into specific segments, cars, or time periods.
 
### 5. Project Structure

```text
Project/
├── output/
│   ├── csv/
│   │   ├── Date/
│   │   │   ├── Dealership's/Website's name/
│   │   │   │   ├── clean_csv
│   │   │   │   ├── raw_csv
│   ├── html/
│   │   ├── Date/
│   │   │   ├── Dealership's/Website's name/
├── crawling.ipynb/
├── wrangling.ipynb/
├── requirements.txt
└── README.md
```

### 6 .Contact
- Name: Ryan Luong
- Email: [ryanluong4work@gmail.com](mailto:ryanluong4work@gmail.com)
- Linkedin [https://www.linkedin.com/in/ryanluong4work](https://www.linkedin.com/in/ryanluong4work)
- Portfolio Website: [https://github.com/ryanluong4work](https://github.com/ryanluong4work)
