# Python - Netflix - Content Production Analysis

## Project Overview
This project analyzes the Netflix movies and TV shows dataset, focusing on trends in content type, category, ratings, duration, and release patterns across time and countries. The goal is to uncover insights that can help Netflix achieve a more balanced distribution of its content.

## Dataset Overview
| Column Name    | Description                                                                                                                 |
| -------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `show_id`      | Unique identifier for each show or movie in the dataset. Example: `s1`, `s2`.                                               |
| `type`         | Indicates whether the entry is a **Movie** or a **TV Show**.                                                                |
| `title`        | Title of the movie or TV show.                                                                                              |
| `director`     | Name(s) of the director(s). Empty if not available.                                                                         |
| `cast`         | List of main cast members separated by commas. Empty if not available.                                                      |
| `country`      | Country where the content was produced or released.                                                                         |
| `date_added`   | The date the content was added to the platform (e.g., Netflix). Format: `"Month Day, Year"`.                                |
| `release_year` | The year the movie or show was originally released.                                                                         |
| `rating`       | Content rating (e.g., `PG-13`, `TV-MA`). Shows which audience group it is appropriate for.                                  |
| `duration`     | For movies: duration in minutes (e.g., `90 min`). For TV shows: number of seasons (e.g., `2 Seasons`).                      |
| `listed_in`    | Categories or genres the content belongs to (e.g., `TV Dramas`, `Crime TV Shows`). Multiple genres are separated by commas. |
| `description`  | A short summary or synopsis of the movie or show.                                                                           |

## Tools & Libraries
- **Python**: pandas, numpy, matplotlib, display, seaborn, squarify

## Data Insight
### 1. Type Analysis: 

**Has Netflix been increasingly focusing on TV shows rather than movies in recent years?**
- **Overall (pie chart)**: Movies **(70%)** still dominate Netflix **(30%)**.
- **Trend over time (line chart)**: Both Movies and TV shows expanded rapidly after 2015, but Movies grew much faster, peaking around 2019. TV shows also rose, but they never overtook Movies.
- **Recent Year (line chart)**: After 2019, both categories declined, but movies displayed the sharpest drop.
<img width="1094" height="444" alt="image" src="https://github.com/user-attachments/assets/31256936-5a24-4e9d-971c-e6cd977664e9" />

### 2. Category Analysis:

**How the Category distribution on the platform (Top and Bottom)? Which Category is the most popular nowaday?**
- **Overall (bar chart)**
    - Comedies rank in the top 3, while Stand-Up Comedy & Talk Shows are among the bottom 3. Similarly, although TV Shows overall are the least represented, International TV Shows rank in the top 4.
    - oth TV Dramas and Dramas are strong categories, but still rank behind International Movies.  
- **Trend over time (line chart)**:
    - **International Movies peaked in 2018 with nearly 700 titles**, but the market downturn after 2019. **By 2021, the number of titles in International Movies and Dramas was nearly the same**.
    - This **downturn also affected all of the top 5 categories**.
    - In 2020, Classic & Cult TV was the bottom 3 categories, and by 2021 it became the least-published cate.
<img width="1121" height="483" alt="image" src="https://github.com/user-attachments/assets/d02063c0-db60-41ac-992a-fdace44cf6fd" />

**Which is more common betwween Single Category or Multi-Category?**
- Multi-Category content clearly dominates Single Category.
- For Movies, Single Category accounts for about 1/4 of the total.
- For TV Shows, Single Category accounts for about 1/5 of the total.
<img width="688" height="121" alt="image" src="https://github.com/user-attachments/assets/02436f0e-b9db-40ae-b764-83fd16d3df7c" />

### 3. Rating Analysis:

**Is there enough content for kids and adults? Where are the content gaps, and how can Netflix grow?**
- **Line Chart**: Netflix’s category is dominated by mature content, with **TV-MA** (3,000+) and **TV-14** (2,200+) titles leading. Children's content ratings **(TV-Y, TV-Y7, PG, G)** is very low compared to mature's content.
<img width="993" height="578" alt="image" src="https://github.com/user-attachments/assets/1c0c3c0b-b2ea-4186-8674-d589e40e8376" />

- **Heatmap**: Netflix’s category is dominated by content for adults and teenagers, accounting for over 76% of all titles, while kids and pre-teens make up only about 23.6%, highlighting the limited content available for kids and pre-teens.
<img width="846" height="501" alt="image" src="https://github.com/user-attachments/assets/0cfb008c-5479-4b2f-846c-4bf2eac303d4" />

### 4. Countries Analysis:

**Which country is leading Netflix content production? What are the top 10 countries with the highest number of Netflix titles (TV shows and movies)?**
- **The United States becomes dominant, making up almost 50% of all top-10 Netflix content production**. India remains the second-highest contributor, followed by the United Kingdom, Canada, and France. This highlight most Netflix content comes from Western and South Asian regions, leaving room for competitors to grow in underrepresented markets like Japan, Spain, and South Korea
- **The United States leads in both TV shows and movies, but its dominance in movies (2,750) reflects Hollywood’s strong film industry**. Asian countries like **Japan and South Korea contribute more proportionally to TV shows**, highlighting the popularity of anime and K-dramas. This may suggests Western countries prioritize movie production, while **Asia is driving growth in serialized streaming content in last decade**.
<img width="1025" height="595" alt="image" src="https://github.com/user-attachments/assets/50c99590-5fbf-4144-be54-caccdac185f4" />
<img width="250" height="340" alt="image" src="https://github.com/user-attachments/assets/37621499-69ef-4504-8e61-c4a606b5193e" /><img width="250" height="339" alt="image" src="https://github.com/user-attachments/assets/ff71afd2-7c6d-4aa6-8a9f-ce3ee0bf31dd" />

### 5. Director Analysis:

**Who are the top 10 Directors?**
- **Rajiv Chilaka from India directed the most titles (19)**, followed by Raúl Campos and Jan Suter from Mexico (18). **The United States has the most directors in the top 10**, with five entries including Martin Scorsese and Steven Spielberg. Directors from India, Mexico, the Philippines, and Egypt also appear.
<img width="317" height="333" alt="image" src="https://github.com/user-attachments/assets/712369c6-6a2d-4114-8d67-8f7c21250aca" />

### 6. Actor Analysis:

**Who are the top 10 Actors?**

- Suprisingly, Although the United States leads total production, **there is no United States actor in top 10**. **Actor Anupam Kher appears in the most titles (43)**, followed by Shah Rukh Khan (35) and Julie Tejwani (33), all from India. **8 out of the top 10 most frequent cast members are from India**. Only 2 actors, Takahiro Sakurai and Yuki Kaji, represent Japan in the top 10.
<img width="262" height="330" alt="image" src="https://github.com/user-attachments/assets/868afc62-c1a4-44a1-a376-fa44920a6729" />

### 7. Duration Analysis:

**How do Movies and TV Shows compare their duration trends?**
- **Movies are the most common content type, usually 90–110 minutes long**, while **most TV shows have just 1 season**, showing that limited series dominate.
- Since 2016, movie lengths have steadily grown, suggesting **Netflix is focusing on longer, more cinematic productions**.
- In 2014, average TV show seasons dropped, likely due to a shift toward miniseries or short-format releases.
<img width="1115" height="400" alt="image" src="https://github.com/user-attachments/assets/6a79111a-e037-4044-a785-d51dfbd50c64" />
<img width="1132" height="414" alt="image" src="https://github.com/user-attachments/assets/e8c49324-d633-4fee-af10-94503a257913" />

### 8. Time Series Analysis:

**When does Netflix release the most content? Are there seasonal or yearly patterns?**
- **Bar Chart:** **Netflix releases content consistently across the year**, but **July has highest number of titles added**. On the orther hand, **February and November see noticeably fewer releases**.
- **Heatmap:** **Content production grew rapidly from 2015 to 2019**, with the largest numbers in late 2018 and 2019. However, **after 2019, the number of new titles started to decline**. July 2020 shows the single highest monthly addition (257 titles).
<img width="998" height="482" alt="image" src="https://github.com/user-attachments/assets/82c7e8a0-6ad7-43e9-a0dc-3ba0619ec037" />
<img width="1116" height="545" alt="image" src="https://github.com/user-attachments/assets/60974412-83b3-449e-949b-5b8ac12a0912" />

## Files in this Project

- **Dataset - Netflix.csv** – Raw dataset for analysis.
- **Analysis - Netflix.ipynb** – Jupyter Notebook containing the full data cleaning, exploration, and visualization process.
- **README.md** – Project Overview.

## How to View

1. Please make sure that you already install **Jupyter-Notebook**
2. On **Jupyter-Notebook** open **Analysis - Netflix.ipynb**

## Contact

- Name: Ryan Luong
- Email: [ryanluong4work@gmail.com](mailto:ryanluong4work@gmail.com)
- Linkedin [https://www.linkedin.com/in/ryanluong4work](https://www.linkedin.com/in/ryanluong4work)
- Portfolio Website: [https://github.com/ryanluong4work](https://github.com/ryanluong4work)







