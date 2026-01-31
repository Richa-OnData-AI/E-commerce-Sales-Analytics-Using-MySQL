# E-commerce Sales Analytics Using MySQL
This project simulates an end-to-end data analytics workflow for an e-commerce business using MySQL. The dataset represents operational data covering customers, products, orders, payments, reviews, and logistics, similar to a real-world e-commerce platform.

## Project Objectives
* Analyze customer behavior and purchase patterns
* Evaluate sales performance and revenue trends
* Identify top-selling products and categories
* Understand order outcomes (Delivered, Returned, Cancelled)
* Measure customer satisfaction using reviews and ratings
* Apply advanced SQL techniques such as:
  - Joins
  - Subqueries
  - Window functions
  - CTEs
  - Stored Procedures
  - User Defined Functions (UDFs)
 
## Database Schema
The project uses a relational database named ECOMMERCE with the following tables:
* customers – customer demographics and signup details
* products – product catalog with pricing and inventory
* orders – order-level information and order status
* order_items – product-level order details
* payments – payment method and transaction amounts
* reviews – customer feedback and ratings
* All tables are connected using primary and foreign keys, ensuring data integrity and realistic relationships.

## Data Querying & Analysis Techniques
* DDL: Database and table creation
* DML: Data insertion
* Joins: INNER JOIN across multiple tables
* Subqueries
* Aggregate functions (SUM, AVG, COUNT)
* Window functions (RANK, LAG, LEAD)
* CTEs (WITH clause)
* Stored Procedures
* User Defined Functions (UDFs)

## Strategic Analytics
* Ranking products based on total sales value
* Forecasting next purchase using window functions
* Assigning numerical scores to order statuses
* Flagging late customer reviews
* Category-wise and customer-wise sales performance analysis

## Business Insights & Findings
The analysis answers multiple real-world business queries, including:
* Customer distribution by state
* Monthly order trends
* Most sold and top-ranked products
* Revenue analysis by product and category
* High-value customer identification
* Product performance based on customer ratings
* Returned orders with completed payments
* Late review detection after delivery
* Customer spending comparison across consecutive orders
