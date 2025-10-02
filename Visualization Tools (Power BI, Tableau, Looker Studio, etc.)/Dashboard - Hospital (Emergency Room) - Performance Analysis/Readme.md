# Dashboard - Hospital (Emergency Room) - Performance Analysis

## Project Overview

This project analyzes patient flow, wait times, and satisfaction scores to uncover the efficiency of a hospital’s Emergency Room (ER) operations. The goal is to identify performance bottlenecks, improve patient experience, and optimize resource allocation.

## Data Visualization Dashboard

<img width="1696" height="1205" alt="image" src="https://github.com/user-attachments/assets/31d3ef85-e65a-4fca-940b-032ce2b0fb5d" />
<img width="1695" height="1204" alt="image" src="https://github.com/user-attachments/assets/27214927-058d-4417-9d9c-0a8fb3a259bf" />
<img width="1696" height="1205" alt="image" src="https://github.com/user-attachments/assets/a0128c53-de99-429f-a822-7dacbe0e3146" />

## Data Insights
### 1. Average Satisfactions Score is too low
- The average waiting time (~35 mins) is higher than the [Government emergency department timeframe](https://www.aihw.gov.au/hospitals/topics/emergency-departments/waiting-times)
- Average Satisfactions Score: 5.74/10
- The Early Childhood age group recorded the lowest satisfaction score and the long waiting time, even though this group requires quick medical attention before conditions worsen
➡️The main issue is patients waiting too long before seeing a doctor

### 2. "Bottleneck” in Referred Patient
- Out of a total of 3,816 transfers, most of Patients were sent to just two departments:
~1840 to General Practice
~1000 to Orthopedics
➡️When these 2 departments are overloaded, the entire Emergency Room system becomes overloaded too, even if there are still enough beds and doctors available

### 3. Complex Patient Characteristics
- 36% of patients are aged 51–80, often with multiple health conditions
- 11% of patients declined to disclose their Race
➡️This highlights the need for a multi-language support system and specialized services for elderly patients.

## Business Recommendations:
- Fast Track: Use [triage optimization](https://pmc.ncbi.nlm.nih.gov/articles/PMC10890971) to separate non-urgent case from urgent case
- Increase staffing levels to anticipate demand surges (e.g., June, midnight, etc.)
- Build/Expand General Practice & Orthopedics departments near Emergency Room
- - Assign experienced pediatric doctors for children, reducing the risk of medical errors
- Add more staff in the Physiotherapy and Neurology departments due to consistently long waiting times
- Provide language support & community communication
- Provide support service for elderly people
  
## Files in this Project

- **Dataset - Hospital.xlsx** – Raw dataset for analysis.
- **Dashboard - Hospital.pbix** – Interactive Power BI dashboard.
- **README.md** – Project Overview.

## How to View

1. Download **Dashboard - Hospital.pbix**.
2. Open it on **Power BI Desktop**.
3. Use filters and slicers to explore insights interactively.

## Contact

- Name: Ryan Luong
- Email: [ryanluong4work@gmail.com](mailto:ryanluong4work@gmail.com)
- Linkedin [https://www.linkedin.com/in/ryanluong4work](https://www.linkedin.com/in/ryanluong4work)
- Portfolio Website: [https://github.com/ryanluong4work](https://github.com/ryanluong4work)
