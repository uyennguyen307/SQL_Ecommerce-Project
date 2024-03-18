# I. Introduction
This project contains an eCommerce dataset that I will explore using SQL on Google BigQuery. The dataset is based on the Google Analytics public dataset and contains data from an eCommerce website.

# II. Requirements
Complete 08 query with expected output in Bigquery base on Google Analytics dataset to fulfill analysis requests.

# III. Dataset Access
The eCommerce dataset is stored in a public Google BigQuery dataset. To access the dataset, follow these steps:

Log in to your Google Cloud Platform account and create a new project.
Navigate to the BigQuery console and select your newly created project.
In the navigation panel, select "Add Data" and then "Search a project".
Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions" and click "Enter".
Click on the "ga_sessions_" table to open it.

**Question 1: Calculate total visit, pageview, transaction and revenue for January, February and March 2017 order by month**

_**SQL Code**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/d1916659-7e4e-41f6-bd43-fb0b188cf765)

_**Query result 1**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/c0c1d57e-b9a6-41f8-84a6-67db06cfbde0)

---
**Question 2: Bounce rate per traffic source in July 2017**

_**SQL Code**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/4f188ac7-b92e-4f46-b8a8-4e045c31b076)

_**Query result 2**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/48e29473-6ebb-4a54-8d70-b7af0a1b6cec)

---
**Question 3: Revenue by traffic source by week, by month in June 2017**

_**SQL Code**_

![image](https://github.com/uyennguyen307/Ecommerce-Project/assets/162019618/70bb9090-4e0d-4575-b0c2-f3142a15418f)

_**Query result 3**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/1b85e451-4030-4602-9b44-422e3a65d667)

---
**Question 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.**

_**SQL Code**_
![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/1783d746-8c46-402a-8c28-297cef463aa5)

_**Query result 4**_
![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/bfcb7876-be30-49c5-8cc3-e5fbe7dc7069)


---
**Question 5: Average number of transactions per user that made a purchase in July 2017**

_**SQL Code**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/aa017c47-2687-4de5-bfa8-4796234c31f0)

_**Query result 5**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/93d25d06-528e-43a7-b4d4-434b283d0ae7)


---
**Question 6: Average amount of money spent per session. Only include purchaser data in July 2017**
_**SQL Code**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/297b5e83-d7fc-4635-a7fa-6c5966c18f6b)

_**Query result 6**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/9314f6d4-e63c-478f-aefc-1ba62dc01e1f)
---
**Question 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.**

_**SQL Code**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/b62c9733-3378-4a21-9068-ea7f5c8d5c86)

_**Query result 7**_
![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/2f0f1cd4-299c-4821-b451-5dcc8894730d)


---
**Question 8:Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase**

_**SQL Code**_

![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/cd9d5473-d440-44ec-b76e-b0593e4e3639)

_**Query result 8**_
![image](https://github.com/uyennguyen307/SQL_Ecommerce-Project/assets/162019618/27610560-c30a-4557-a23e-a1c66cba53f9)

