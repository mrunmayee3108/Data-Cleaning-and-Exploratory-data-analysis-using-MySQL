Data Cleaning and Exploratory Analysis with MySQL

This project demonstrates how to clean and explore a raw dataset using SQL. It focuses on fixing common data quality issues and performing summary analyses to prepare the data for further insights.

Overview: 

The workflow includes:

Data Cleaning:
* Remove duplicates
* Handle null and missing values
* Standardize date formats
* Group ages into categories
* Drop irrelevant columns

Exploratory Data Analysis (EDA):
* Salary statistics (min, max, average, standard deviation)
* Department-level salary summaries
* Identify top earners and salary distributions
* Find duplicate names, shared salaries, and upcoming birthdays or anniversaries

Features:
* Uses SQL window functions (`ROW_NUMBER()`, `NTILE()`, `RANK()`) for deduplication and ranking.
* Standardizes inconsistent date formats.
* Groups employees into age bands (20–30, 30–40, etc.).
* Identifies key insights like highest paid employees and department salary spend.


Example Insights:
* Top Earners: Who earns the most in the company.
* Department Summary: Total salaries and average salaries by department.
* Upcoming Events: Employees with birthdays or anniversaries this month.

Why This Matters: 
Clean data is the foundation for meaningful analysis. This project shows how SQL alone can resolve common data issues and uncover trends.
