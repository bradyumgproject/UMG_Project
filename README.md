# Uncovering Fan Trends: Simulated Audisense Data Insights for UMG by Brady Katler

For this project, my goal was to create a report similar to what a Strategic Analyst at Universal Music Group (UMG) might produce. I researched UMG’s use of Audisense to gather data on various audience segments and utilized AI to generate a sample database. The results can be seen by visiting [mockaudisense.report](http://mockaudisense.report). Here were the steps to reproduce:

## 1. Simulate an Audisense database using dummy data

Audisense unsurprisingly has very little public data available, so finding real information I could use to generate insights proved to be extremely difficult. The next best thing was to simulate a database using AI, so I used the [Audisense Knowledge Base Documentation](https://help.audiense.com/knowledge/audiense-insights) in conjunction with ChatGPT to produce 10,000 rows of dummy data designed to emulate what UMG might receive from Audisense. The specific tables can be seen in the [Backend/Database/Database_Schema_Directory](https://github.com/bradyumgproject/UMG_Project/tree/main/UMG_Project/Backend/Database/Database_Schema).


## 2: Build the database

To build the database, I spun up a Postgres RDS instance as it is the database management system I am most comfortable with and works great for analysis. From there, I used DBeaver as my SQL editor to create the tables and import the CSV data. For that specific code,see [Backend/Database/SQL_Scripts/audisense_db_setup.sql](https://github.com/bradyumgproject/UMG_Project/blob/main/UMG_Project/Backend/Database/SQL_Scripts/audisense_db_setup.sql). Below are sample rows from each table and the ERD to give an idea of what the database looks like:

### Artists Table

| artist_id | artist_name        | genre     | label                      | social_followers | monthly_listeners | region_popularity |
|-----------|--------------------|-----------|----------------------------|------------------|-------------------|--------------------|
| 1         | Dr. Paul White     | Pop       | Morrow-Collier            | 564,906          | 319,969           | Canada            |
| 2         | Patty Rivera       | EDM       | Patterson-Cochran         | 441,895          | 963,694           | USA               |
| 3         | Aimee Thompson     | Country   | Shelton, Simmons and Mann | 1,100,598        | 539,372           | Germany           |
| 4         | Kristie Ferguson   | Rock      | Oneill, Scott and Reed     | 390,511          | 522,513           | India             |
| 5         | Nicholas Smith     | Country   | Clay, Trujillo and Garza   | 1,810,613        | 26,356            | Germany           |

---

### Audience Profiles Table

| profile_id | age_group | gender   | location    | preferred_genre | average_listening_hours | device_type | music_service  |
|------------|-----------|----------|-------------|-----------------|-------------------------|-------------|----------------|
| 1          | 45-54     | Other    | France      | Pop             | 25.45                   | Desktop     | Amazon Music   |
| 2          | 35-44     | Male     | UK          | Hip-Hop         | 5.09                    | Mobile      | Spotify        |
| 3          | 25-34     | Other    | Japan       | Hip-Hop         | 27.21                   | Tablet      | Apple Music    |
| 4          | 18-24     | Female   | Germany     | Hip-Hop         | 6.16                    | Desktop     | Spotify        |
| 5          | 55+       | Non-binary | Germany   | EDM             | 23.69                   | Tablet      | Apple Music    |

---

### Audience Segments Table

| segment_id | segment_name               | criteria                 | size | average_engagement_score | preferred_device |
|------------|----------------------------|--------------------------|------|--------------------------|------------------|
| 1          | Metalheads                 | 18-24 Pop lovers         | 192  | 4.74                     | Desktop          |
| 2          | Pop Fans                   | 18-24 Hip-Hop lovers     | 245  | 1.64                     | Tablet           |
| 3          | Casual Listeners           | 18-24 Rock lovers        | 323  | 2.17                     | Desktop          |
| 4          | EDM Fans                   | 18-24 EDM lovers         | 110  | 4.86                     | Mobile           |
| 5          | Jazz Enthusiasts           | 18-24 Classical lovers   | 312  | 1.7                      | Desktop          |

---

### Fan Engagement Metrics Table

| engagement_id | profile_id | artist_id | streams | likes | shares | comments | time_spent_on_artist | date       |
|---------------|------------|-----------|---------|-------|--------|----------|-----------------------|------------|
| 1             | 2,343      | 6         | 8       | 32    | 6      | 1        | 59.67                 | 2024-10-08 |
| 2             | 1,895      | 25        | 73      | 19    | 3      | 6        | 41.83                 | 2024-03-24 |
| 3             | 1,476      | 37        | 35      | 42    | 14     | 1        | 161.33                | 2024-02-16 |
| 4             | 1,866      | 49        | 14      | 16    | 3      | 5        | 18.23                 | 2024-08-21 |
| 5             | 974        | 27        | 83      | 17    | 10     | 6        | 169.55                | 2024-06-06 |

---

### Insights Table

| insight_id | segment_id | artist_id | engagement_trend | audience_growth_rate | engagement_rate | top_platform  |
|------------|------------|-----------|------------------|----------------------|-----------------|---------------|
| 1          | 6          | 2         | Steady          | 0.23                 | 9.62            | YouTube Music |
| 2          | 17         | 12        | Steady          | 0.35                 | 4.54            | Apple Music   |
| 3          | 1          | 7         | Rising          | -0.1                 | 2.8             | Spotify       |
| 4          | 4          | 41        | Steady          | 0.18                 | 5.05            | Apple Music   |
| 5          | 15         | 49        | Steady          | 0.36                 | 7.26            | Apple Music   |


![ERD Diagram](https://github.com/bradyumgproject/UMG_Project/blob/main/UMG_Project/Backend/Database/UMG_ERD.png)


## 3: Generate actionable insights

I wrote four SQL queries and used three of the main ones on my website. My goal was to use a variety of SQL skills including CTEs, Window Functions, and statistic functions. To see the SQL queries, see [Backend/Database/SQL_Scripts/sql_queries.sql](https://github.com/bradyumgproject/UMG_Project/blob/main/UMG_Project/Backend/Database/SQL_Scripts/sql_queries.sql)

## 4: Bring SQL queries into Looker Studio

For my data visualization, I decided to use Looker Studio, as it is a free platform I have a lot of experience with. Looker Studio also allows for controls which may not be usable on a website, but can help anyone with access to the report. Click here to [View the Looker Studio Report](https://lookerstudio.google.com/reporting/8decc191-103f-4600-9e4b-855bde6bd6ca)

## 5: Building the AWS site

Rather than displaying my results in a traditional format like Powerpoint, I thought it would stand out better as a website. I created this website through the following steps:
1. Create two S3 buckets: A main bucket for my website and another with the www extension to redirect any www traffic to the main bucket
2. Create my index.html file
3. Buy my domain name from a DNS registrar
4. Use Route 53 to configure DNS for my S3 Buckets
5. Use Amazon Certificate Manager to get an SSL certificate and add the entires into Route 53
6. Use Cloudfront to distribute my HTTPS website

To view the website files, see the files in [Frontend/html](https://github.com/bradyumgproject/UMG_Project/tree/main/UMG_Project/Frontend/html)
