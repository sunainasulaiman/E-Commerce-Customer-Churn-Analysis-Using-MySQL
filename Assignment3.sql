USE ECOMM;
SELECT * FROM CUSTOMER_CHURN;
-- ************************************************************Data Cleaning***************************************************************************************
-- ******************************************************** Handling Missing Values and Outliers: *****************************************************************
-- Imputing mean for WarehouseToHome

UPDATE CUSTOMER_CHURN 
SET WarehouseToHome = (
    SELECT ROUND(avg_val) 
    FROM (SELECT AVG(WarehouseToHome) AS avg_val FROM CUSTOMER_CHURN) AS temp
) 
WHERE WarehouseToHome IS NULL;

-- Imputing mean for HourSpendOnApp
UPDATE CUSTOMER_CHURN 
SET HourSpendOnApp = (
    SELECT ROUND(AVERAGE) 
    FROM (SELECT AVG(HourSpendOnApp) AS AVERAGE FROM CUSTOMER_CHURN) AS TEMP
) 
WHERE HourSpendOnApp IS NULL;

-- Imputing mean for OrderAmountHikeFromlastYear
UPDATE CUSTOMER_CHURN 
SET OrderAmountHikeFromlastYear = (
    SELECT ROUND(AVERAGE) 
    FROM (SELECT AVG(OrderAmountHikeFromlastYear) AS AVERAGE FROM CUSTOMER_CHURN) AS temp
) 
WHERE OrderAmountHikeFromlastYear IS NULL;

-- Imputing mean for DaySinceLastOrder
UPDATE CUSTOMER_CHURN
SET DaySinceLastOrder = (
    SELECT ROUND(AVERAGE) 
    FROM (SELECT AVG(DaySinceLastOrder) AS AVERAGE FROM CUSTOMER_CHURN) AS temp
) 
WHERE DaySinceLastOrder IS NULL;

-- ******************************************************** Impute mode for the following columns: Tenure, CouponUsed, OrderCount.
-- Find mode for Tenure
SELECT Tenure,COUNT(*) AS TOTAL_COUNT
FROM CUSTOMER_CHURN
WHERE Tenure IS NOT NULL
GROUP BY Tenure
ORDER BY TOTAL_COUNT DESC LIMIT 1;
-- Here we got mode value as "1"

-- Imputing mode for Tenure
UPDATE CUSTOMER_CHURN 
SET Tenure = 1
WHERE Tenure IS NULL;

-- ******************************************Find mode for CouponUsed

SELECT CouponUsed,COUNT(*) AS TOTAL_COUNT
FROM CUSTOMER_CHURN
GROUP BY CouponUsed
HAVING CouponUsed IS NOT NULL
ORDER BY TOTAL_COUNT DESC LIMIT 1;
-- Here we got mode value as "1"

-- Imputing mode for CouponUsed
UPDATE CUSTOMER_CHURN 
SET CouponUsed = 1
WHERE CouponUsed IS NULL;

-- **********************************************FIND MODE FOR OrderCount
SELECT OrderCount,COUNT(*) AS TOTAL_COUNT
FROM CUSTOMER_CHURN
GROUP BY OrderCount
HAVING OrderCount IS NOT NULL
ORDER BY TOTAL_COUNT DESC LIMIT 1;
-- Here we got mode value as "2"

-- Imputing mode for OrderCount
UPDATE CUSTOMER_CHURN 
SET OrderCount = 2
WHERE OrderCount IS NULL;

-- ********************************** Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100
 DELETE FROM CUSTOMER_CHURN
 WHERE WarehouseToHome>100;

-- ************************************************************Dealing with Inconsistencies: *********************************************************************
-- ➢ Replace occurrences of “Phone” in the 'PreferredLoginDevice' column with "Mobile Phone"
UPDATE CUSTOMER_CHURN
SET PreferredLoginDevice = "Mobile Phone"
WHERE PreferredLoginDevice="Phone";

-- Replace occurrences of  “Mobile” in the 'PreferedOrderCat' column with “Mobile Phone”.
UPDATE CUSTOMER_CHURN
SET PreferedOrderCat = "Mobile Phone"
WHERE PreferedOrderCat ="Mobile";

-- Replace "COD" with "Cash on Delivery" in the PreferredPaymentMode column.
UPDATE CUSTOMER_CHURN
SET PreferredPaymentMode = "Cash On Delivery"
WHERE PreferredPaymentMode ="COD";

-- Replace "CC" with "Credit Card" in the PreferredPaymentMode column.
UPDATE CUSTOMER_CHURN
SET PreferredPaymentMode = "Credit Card"
WHERE PreferredPaymentMode ="CC";

-- *********************************************************** Data Transformation ***********************************************************************************
-- ************************************************************* Column Renaming *************************************************************************************
-- Rename the column "PreferedOrderCat" to "PreferredOrderCat".
ALTER TABLE CUSTOMER_CHURN 
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

-- Rename the column "HourSpendOnApp" to "HoursSpentOnApp".
ALTER TABLE CUSTOMER_CHURN 
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

-- *********************************************************** Creating New Columns *********************************************************************************
-- Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’ is 1, and "No" otherwise.
ALTER TABLE CUSTOMER_CHURN
ADD COLUMN ComplaintReceived varchar(10);

UPDATE CUSTOMER_CHURN
SET ComplaintReceived=
	CASE
		WHEN Complain=1
			THEN "Yes"
		ELSE "No"
	END;

-- Create a new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, else assign “Active”.
ALTER TABLE CUSTOMER_CHURN
ADD COLUMN ChurnStatus varchar(10);

UPDATE CUSTOMER_CHURN
SET ChurnStatus=
	CASE
		WHEN Churn=1
			THEN "Churned"
		ELSE "Active"
	END;

-- ********************************************************************** Column Dropping **************************************************************************
-- **************************************************** Drop the columns "Churn" and "Complain" from the table.*****************************************************
ALTER TABLE CUSTOMER_CHURN
DROP COLUMN Churn,
DROP COLUMN Complain;

-- ********************************************************* Data Exploration and Analysis **************************************************************************
-- Retrieve the count of churned and active customers from the dataset.
SELECT ChurnStatus, COUNT(*) AS Count_Of_Customers 
FROM CUSTOMER_CHURN 
GROUP BY ChurnStatus;

-- Display the average tenure and total cashback amount of customers who churned.
SELECT avg(tenure) AS Average_Tenure, sum(CashbackAmount) AS Total_Cashback 
FROM CUSTOMER_CHURN 
WHERE ChurnStatus="Churned";

-- Determine the percentage of churned customers who complained.
SELECT ROUND(SUM(
		CASE
			WHEN ComplaintReceived ="Yes"
				THEN 1
			ELSE 0
		END ) * 100 / COUNT(*),2) AS PERCENTAGE
FROM CUSTOMER_CHURN
WHERE ChurnStatus="Churned";


-- Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory.
SELECT CityTier,COUNT(*) AS No_Of_Churned_Customers
FROM CUSTOMER_CHURN
WHERE PreferredOrderCat="Laptop & Accessory" AND ChurnStatus="Churned"
GROUP BY CityTier
ORDER BY ChurnStatus DESC 
LIMIT 1;

-- Identify the most preferred payment mode among active customers.

SELECT PreferredPaymentMode,COUNT(*) AS No_Of_Churned_Customers
FROM CUSTOMER_CHURN
GROUP BY PreferredPaymentMode
ORDER BY No_Of_Churned_Customers  DESC 
LIMIT 1;

-- Calculate the total order amount hike from last year for customers who are single and prefer mobile phones for ordering.
SELECT MaritalStatus,PreferredOrderCat,SUM(OrderAmountHikeFromlastYear) AS TOTAL_ORDER_AMOUNT_HIKE
FROM CUSTOMER_CHURN
WHERE MaritalStatus="Single" AND PreferredOrderCat="Mobile Phone";

-- Find the average number of devices registered among customers who used UPI as their preferred payment mode.
SELECT PreferredPaymentMode,
ROUND(AVG(NumberOfDeviceRegistered),2 )AS AVERAGE_NO_OF_DEVICES_REGISTERED
FROM CUSTOMER_CHURN
WHERE PreferredPaymentMode="UPI";

-- Determine the city tier with the highest number of customers.
SELECT CityTier,COUNT(CustomerID) AS NO_OF_CUSTOEMRS
FROM CUSTOMER_CHURN
GROUP BY CityTier
ORDER BY NO_OF_CUSTOEMRS DESC
LIMIT 1;

-- Identify the gender that utilized the highest number of coupons.
SELECT Gender,COUNT(CouponUsed) AS TOTAL_COUPONS_USED
FROM CUSTOMER_CHURN
GROUP BY Gender
ORDER BY TOTAL_COUPONS_USED DESC
LIMIT 1;

-- List the number of customers and the maximum hours spent on the app in each preferred order category.
SELECT PreferredOrderCat,COUNT(CustomerID)AS NO_OF_CUSTOMERS,MAX(HoursSpentOnApp)AS MAXIMUM_HOURS_SPENT
FROM CUSTOMER_CHURN
GROUP BY PreferredOrderCat;

-- Calculate the total order count for customers who prefer using credit cards and have the maximum satisfaction score.
SELECT PreferredPaymentMode,SUM(OrderCount) AS TOTAL_ORDER_COUNT,MAX(SatisfactionScore)
FROM CUSTOMER_CHURN
WHERE PreferredPaymentMode="Credit Card";

-- What is the average satisfaction score of customers who have complained?
SELECT ROUND(AVG(SatisfactionScore),2) AS AVERAGE_SATISFACTION_SCORE
FROM CUSTOMER_CHURN
WHERE ComplaintReceived="Yes";

-- List the preferred order category among customers who used more than 5 coupons.
SELECT PreferredOrderCat,COUNT(CustomerID) AS TOTAL_CUSTOMERS
FROM CUSTOMER_CHURN
WHERE CouponUsed>5
GROUP BY PreferredOrderCat;
-- List the top 3 preferred order categories with the highest average cashback amount.
SELECT PreferredOrderCat,AVG(CashbackAmount) AS HIGHEST_AVERAGE_CASHBACK_AMOUNT
FROM CUSTOMER_CHURN
GROUP BY PreferredOrderCat
ORDER BY HIGHEST_AVERAGE_CASHBACK_AMOUNT DESC 
LIMIT 3;
-- Find the preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders.
SELECT PreferredPaymentMode,ROUND(AVG(Tenure)) AS AVERAGE_TENURE,SUM(OrderCount) AS TOTAL_ORDER
FROM CUSTOMER_CHURN
GROUP BY PreferredPaymentMode
HAVING AVERAGE_TENURE=10 AND TOTAL_ORDER >500 ;

/* Categorize customers based on their distance from the warehouse to home such as 'Very Close Distance' for distances <=5km, 
'Close Distance' for <=10km,'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the churn status breakdown for each distance category.*/
SELECT CustomerID,WarehouseToHome,
CASE 
	WHEN WarehouseToHome <=5
		THEN "Very Close Distance"
	WHEN WarehouseToHome <=10
		THEN "Close Distance"
	WHEN WarehouseToHome <=15
		THEN " Moderate Distance"
	ELSE "Far Distance"
END
AS CATEGORY
FROM CUSTOMER_CHURN;

-- List the customer’s order details who are married, live in City Tier-1, and their order counts are more than the average number of orders placed by all customers.
SELECT CustomerID,MaritalStatus,CityTier,OrderCount
FROM CUSTOMER_CHURN
WHERE MaritalStatus="Married" AND 
CityTier=1 AND
 OrderCount > (SELECT AVG(OrderCount) FROM CUSTOMER_CHURN);
 
 -- ***************************************************** CREATE TABLE **************************************************************************************
 
 CREATE TABLE CUSTOMER_RETURNS(
	ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT );
    
INSERT INTO CUSTOMER_RETURNS VALUES 
	(1001,50022,"2023-01-01",2130),
    (1002,50316,"2023-01-23",2000),
    (1003,51099,"2023-02-14",2290),
    (1004,52321,"2023-03-08",2510),
    (1005,52928,"2023-03-20",3000),
    (1006,53749,"2023-04-17",1740),
    (1007,54206,"2023-04-21",3250),
    (1008,54838,"2023-04-30",1990);
    
SELECT * FROM CUSTOMER_RETURNS;

--  Display the return details along with the customer details of those who have churned and have made complaints.
SELECT * FROM 
CUSTOMER_CHURN AS C JOIN CUSTOMER_RETURNS AS R 
ON C.CustomerID=R.CustomerID
WHERE C.ChurnStatus="Churned" AND C.ComplaintReceived="Yes";