# Python - API Scraping and Wrangling - YouTube’s API Search

## Description
This project demonstrates my skills in scraping data using the **YouTube Data API**, managing **API keys and quota limits**, and converting raw JSON responses into a clean, analysis-ready dataframe. The workflow includes scraping and wrangling Youtube Video data (Key metrics are Videoid, title, likes, favorites, views).

## Skills
- Python
- API integration & authentication
- Quota limit handling and key rotation
- Data wrangling (JSON → CSV / DataFrame)

## Key Insights
- Implemented a **multi-key rotation** mechanism that automatically switches keys when quota is hit and respects the **daily reset (midnight, America/Los_Angeles)**.
- Validates inputs (e.g., `type_` and `max_result`), handles **pagination with `nextPageToken`**, and writes **per-page raw JSON** for auditing.
- Produces an **analysis-ready CSV** (title, channel, publishedAt, videoId, etc.) for quick EDA or dashboarding.

## How to Run
1. Create and activate a virtual environment, then install requirements:
   ```bash
   python -m venv venv
   # Windows
   venv\Scripts\activate
   # macOS/Linux
   # source venv/bin/activate

   pip install -r requirements.txt

2. Add your API keys to a .env file (same folder) with format below:
   ```bash
   YOUTUBE_API_KEY_1=your_key_1
   YOUTUBE_API_KEY_2=your_key_2
    # add more keys if needed

3. Run a syntax as example on last syntax boxframe.

## How to Run
- Name: Ryan Luong
- Email: [ryanluong4work@gmail.com](mailto:ryanluong4work@gmail.com)
- Linkedin [https://www.linkedin.com/in/ryanluong4work](https://www.linkedin.com/in/ryanluong4work)
- Portfolio Website: [https://github.com/ryanluong4work](https://github.com/ryanluong4work)
