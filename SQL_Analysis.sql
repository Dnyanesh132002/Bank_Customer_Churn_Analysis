CREATE DATABASE bank_churn;
USE bank_churn;

SELECT *
FROM bank_customer
LIMIT 10;

SELECT COUNT(*)
FROM bank_customer;

describe bank_customer;

SHOW COLUMNs FROM bank_customer;

-- 1. Total Number of Customers

SELECT COUNT(*) AS Total_Customers
FROM bank_customer;


-- 2. Total Number of Churned Customers

SELECT COUNT(*) AS Churned_Customers
FROM bank_customer
WHERE Exited = 1;


-- 3. Total Number of Retained Customers

SELECT COUNT(*) AS Retained_Customers
FROM bank_customer
WHERE Exited = 0;


-- 4. Overall Customer Churn Rate (%)

SELECT
ROUND(
SUM(Exited) * 100.0 / COUNT(*),
2
) AS Churn_Rate
FROM bank_customer;


-- 5. Customer Distribution by Geography

SELECT
Geography,
COUNT(*) AS Total_Customers
FROM bank_customer
GROUP BY Geography
ORDER BY Total_Customers DESC;


-- 6. Churn Rate by Geography

SELECT
Geography,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Geography
ORDER BY Churn_Rate DESC;


-- 7. Churn Rate by Gender

SELECT
Gender,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Gender
ORDER BY Churn_Rate DESC;


-- 8. Average Age of Churned vs Retained Customers

SELECT
Exited,
ROUND(AVG(Age),2) AS Avg_Age
FROM bank_customer
GROUP BY Exited;


-- 9. Average Account Balance by Churn Status

SELECT
Exited,
ROUND(AVG(Balance),2) AS Avg_Balance
FROM bank_customer
GROUP BY Exited;


-- 10. Churn Rate by Active Membership Status

SELECT
IsActiveMember,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY IsActiveMember;


-- 11. Customer Churn by Age Group

SELECT
CASE
    WHEN Age < 30 THEN 'Under 30'
    WHEN Age BETWEEN 30 AND 50 THEN '30-50'
    ELSE 'Above 50'
END AS Age_Group,
COUNT(*) AS Total_Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Age_Group
ORDER BY Churn_Rate DESC;


-- 12. Customer Churn by Credit Score Category

SELECT
CASE
    WHEN CreditScore < 600 THEN 'Poor'
    WHEN CreditScore BETWEEN 600 AND 750 THEN 'Average'
    ELSE 'Good'
END AS Credit_Category,
COUNT(*) AS Total_Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Credit_Category
ORDER BY Churn_Rate DESC;


-- 13. Customer Churn by Balance Category

SELECT
CASE
    WHEN Balance = 0 THEN 'Zero Balance'
    WHEN Balance < 100000 THEN 'Low Balance'
    ELSE 'High Balance'
END AS Balance_Category,
COUNT(*) AS Total_Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Balance_Category
ORDER BY Churn_Rate DESC;


-- 14. Customer Churn by Number of Products

SELECT
NumOfProducts,
COUNT(*) AS Total_Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY NumOfProducts
ORDER BY Churn_Rate DESC;


-- 15. Customer Churn by Credit Card Ownership

SELECT
HasCrCard,
COUNT(*) AS Total_Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY HasCrCard;


-- 16. Customer Churn by Tenure

SELECT
Tenure,
COUNT(*) AS Total_Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Tenure
ORDER BY Churn_Rate DESC;


-- 17. Top 10 Highest Balance Customers Who Churned

SELECT
CustomerId,
Balance,
Age,
Geography
FROM bank_customer
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 10;


-- 18. Average Salary by Churn Status

SELECT
Exited,
ROUND(AVG(EstimatedSalary),2) AS Avg_Salary
FROM bank_customer
GROUP BY Exited;


-- 19. Geography-wise Average Balance

SELECT
Geography,
ROUND(AVG(Balance),2) AS Avg_Balance
FROM bank_customer
GROUP BY Geography
ORDER BY Avg_Balance DESC;

-- 20. Top 5 High-Risk Customer Segments

SELECT
Geography,
Gender,
COUNT(*) AS Customers,
ROUND(AVG(Exited) * 100,2) AS Churn_Rate
FROM bank_customer
GROUP BY Geography, Gender
ORDER BY Churn_Rate DESC
LIMIT 5;


-- Rank countries based on customer churn rate

SELECT
    Geography,
    ROUND(AVG(Exited) * 100, 2) AS Churn_Rate,
    RANK() OVER(
        ORDER BY AVG(Exited) DESC
    ) AS Country_Rank
FROM bank_customer
GROUP BY Geography;


-- Customers having balance greater than overall average balance

SELECT
    CustomerId,
    Balance,
    Geography
FROM bank_customer
WHERE Balance >
(
    SELECT AVG(Balance)
    FROM bank_customer
);


-- High-risk customers likely to churn

SELECT
    CustomerId,
    Age,
    Balance,
    IsActiveMember
FROM bank_customer
WHERE Age > 50
AND IsActiveMember = 0
AND Balance > 100000;


-- Calculate churn rate using CTE

WITH churn_summary AS
(
    SELECT
        COUNT(*) AS total_customers,
        SUM(Exited) AS churned_customers
    FROM bank_customer
)

SELECT
    total_customers,
    churned_customers,
    ROUND(
        churned_customers * 100.0 /
        total_customers,
        2
    ) AS churn_rate
FROM churn_summary;


-- Top 5 churned customers with highest balance

SELECT
    CustomerId,
    Geography,
    Balance
FROM bank_customer
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 5;