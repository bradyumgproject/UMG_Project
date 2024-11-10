# Generating insights using mock Audisense data for UMG by Brady Katler

For this project, my goal was to create a report similar to what a Strategic Analyst at Universal Music Group (UMG) might produce. I researched UMG’s use of Audisense to gather data on various audience segments and utilized AI to generate a sample database. The results can be seen by visiting mockaudisense.report. Here were the steps to reproduce:

## 1. Simulate an Audisense database using dummy data

Audisense unsurprisingly has very little public data available, so finding real information I could use to generate insights proved to be extremely difficult. The next best thing was to simulate a database using AI. By feeding ChatGPT information on Audisense and the data they produce, I was able to produce 10,000 rows of dummy data. The specific tables can be seen in the `Backend/Database/Database Schema Directory`.

## 2: Build the database

To build the database, I spun up a Postgres RDS instance. From there, I used DBeaver to create the tables and import the CSV data. For that specific code,see `Backend/Database/SQL Scripts/audisense-db-setup.sql`. For an ERD, see `Backend/Database/UMG ERD.pdf`

## 3: Generate Actionable Insights

I wrote four SQL queries and used three of the main ones on my website. My goal was to use a variety of SQL skills including CTEs, Window Functions, and statistic functions. To see the SQL queries, see 'Backend/Database/SQL Scripts/sql_queries.sql`

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

To view the website files, see the files in `frontend/html`
