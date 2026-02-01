--                                       Project Title: E-commerce Sales Analytics Using MySQL
-- OBJECTIVES:
-- This project simulates an end-to-end data analytics scenario for an e-commerce company.
-- This is an operational datasets covering customers, orders, products, payments, reviews, and logistics. 
-- The project covers both basic and advanced SQL techniques to derive business insights around customer behavior, sales performance, delivery issues, and product-level KPIs.

-- SECTION-A
   --  DATABASE AND SCHEMAS SETUP

CREATE DATABASE ECOMMERCE;
USE ECOMMERCE;

-- SECTION-B
   -- TABLE CREATION

-- B1. CUSTOMERS
CREATE TABLE customers(customer_id INT PRIMARY KEY,
name VARCHAR(255),
email VARCHAR(255),
city VARCHAR(255),
state VARCHAR(255),
signup_date DATE);

-- B2. PRODUCTS
CREATE TABLE products(product_id INT PRIMARY KEY,
product_name VARCHAR(255),
category VARCHAR(255),
price DECIMAL(10,2),
stock_quantity INT);

-- B3. ORDERS
CREATE TABLE orders (order_id INT PRIMARY KEY,
customer_id INT ,
FOREIGN KEY(customer_id)REFERENCES customers(customer_id),
order_date DATE,
status VARCHAR(255)); -- 'Delivered', 'Cancelled', 'Returned'

-- B4. ORDER_ITEMS
CREATE TABLE order_items (item_id INT PRIMARY KEY ,
order_id INT,
FOREIGN KEY(order_id)REFERENCES orders(order_id),
product_id INT, 
FOREIGN KEY(product_id)REFERENCES products(product_id),
quantity INT,
price_each DECIMAL(10,2));

-- B5. PAYMENTS
CREATE TABLE payments(payment_id INT PRIMARY KEY,
order_id INT,
FOREIGN KEY(order_id)REFERENCES orders(order_id),
payment_method VARCHAR(255), -- 'Credit Card', 'Net Banking', 'UPI', etc.
payment_date DATE,
payment_amount DECIMAL(10,2));

-- B6. REVIEWS
CREATE TABLE reviews(review_id INT PRIMARY KEY,
order_id INT, 
FOREIGN KEY(order_id)REFERENCES orders(order_id),
rating INT, -- 1 to 5
review_text TEXT,
review_date DATE);

-- SECTION-C
   -- DATA INSERTION 

-- C1. CUSTOMERS
INSERT INTO customers VALUES
(1, 'Amit Roy', 'amit@example.com', 'Delhi', 'Delhi', '2022-03-10'),
(2, 'Sonal Jain', 'sonal@example.com', 'Mumbai', 'Maharashtra', '2023-01-22'),
(3, 'Rakesh Singh', 'rakesh@example.com', 'Lucknow', 'UP', '2021-11-05');

-- C2.PRODUCTS
INSERT INTO products VALUES
(101, 'Wireless Mouse', 'Electronics', 599, 100),
(102, 'Bluetooth Speaker', 'Electronics', 1299, 50),
(103, 'Cotton Shirt', 'Fashion', 899, 200),
(104, 'Cooking Oil 1L', 'Grocery', 175, 300);

-- C3. ORDERS
INSERT INTO orders VALUES
(1001, 1, '2024-06-01', 'Delivered'),
(1002, 2, '2024-06-05', 'Delivered'),
(1003, 1, '2024-06-10', 'Returned'),
(1004, 3, '2024-06-11', 'Cancelled');

-- C4. ORDER_ITEMS
INSERT INTO order_items VALUES
(1, 1001, 101, 2, 599),
(2, 1002, 103, 1, 899),
(3, 1003, 102, 1, 1299),
(4, 1004, 104, 5, 175);

-- C5. PAYMENTS
INSERT INTO payments VALUES
(501, 1001, 'Credit Card', '2024-06-01', 1198),
(502, 1002, 'UPI', '2024-06-05', 899),
(503, 1003, 'Net Banking', '2024-06-10', 1299);

-- C6. REVIEWS 
INSERT INTO reviews VALUES
(901, 1001, 5, 'Great product', '2024-06-03'),
(902, 1002, 4, 'Good fit and quality', '2024-06-06'),
(903, 1003, 2, 'Stopped working in 2 days', '2024-06-12');


-- SECTION D: Business Queries and Analysis
		

-- Q1.Count the number of customers per state.

select count(name)as number_of_customers, state from customers group by state;

-- Q2.Show total orders placed in June 2024.
select count(order_id)   from orders 
where order_date >= "2024-06-01";

-- Q3.Find the most sold product by quantity.
select product_id  
from order_items
order by  quantity desc
limit 1;
# This query retrieve the product_id which have the highest sold quantity

-- Q4.List all customers who signed up before 2023.
select customer_id , name , signup_date 
from customers
where year(signup_date) < 2023;

-- Q5.Find products with price above average price.
select product_id,product_name, price
from products
where price > (select avg(price) from products);
# This query retreive two products which have price higher than the avg_price i.e Bluetooth Speaker , Cotton Shirt


-- Q6. Join orders with customers to show buyer details per order.

select orders.order_id,orders.order_date, orders.status,  customers.customer_id , customers.name, customers.email, customers.city , customers.state 
from orders inner join customers
on orders.customer_id = customers.customer_id
where orders.status <> "Cancelled";
# This filters out all orders where the status is "Cancelled", Only active, completed, or in-process orders will appear.

-- Q7. Join order_items with products to show product names per order.

select order_items.order_id,products.product_name
from order_items inner join products
on order_items.product_id = products.product_id;


-- Q8. Join reviews with orders and customers to analyze feedback by region.
select reviews.rating , reviews.review_text, orders.status , customers.city, customers.state
from reviews inner join orders 
on reviews.order_id = orders.order_id
inner join customers
on orders.customer_id = customers.customer_id;


-- Q9. Find all products bought by a specific customer.
select products.product_id,products.product_name,customers.customer_id,customers.name
from customers join orders
on customers.customer_id = orders.customer_id
join order_items
on orders.order_id= order_items.order_id
join products 
on order_items.product_id = products.product_id;
# since there's no direct link between customers and products, we use  tables: orders and order_items.
/*STEPS:
Step 1: Start with customers table
begin with the customers table because you want to retrieve the customer's details.
Step 2: Join orders table
This joins each customer to their orders using the common column customer_id.
Now we know which customer placed which orders.
Step 3: Join order_items table
This connects each order to the products it contains.
Now we know which products were in each order.
Step 4: Join products table
This brings in the product details for each item in the order.
Now we can access product names and IDs.*/




-- Q10. List orders which were returned but still have payment records.
select orders.order_id,orders.order_date, orders.status ,payments.payment_method,payments.payment_amount
from orders join payments
on orders.order_id = payments.order_id
where orders.status = "Returned";


-- Q11. Calculate total revenue per product category.
select sum(payment_amount) as Total_revenue, category
from payments , products
group by category;


-- Q12. Find average rating per product.
select avg(rating) as avg_rating ,product_name
from reviews,products
group by product_name;

-- Q13. Count number of reviews per rating level.
select count(review_id) as number_of_rating ,rating
from reviews
group by rating
order by rating desc;


-- Q14. Find monthly order count trends.
select month(order_date) as order_month , count(order_id) as Total_orders
from orders
group by order_month;


-- Q15.Total value of orders placed by each customer.
#The sum of money spent by each customer on their orders
select customers.customer_id,customers.name,payments.payment_amount
from customers join orders
on customers.customer_id = orders.customer_id
join payments
on orders.order_id = payments.order_id;


-- Q16. Rank products by total sales value.
SELECT products.product_id, products.product_name,SUM(order_items.quantity * order_items.price_each) AS total_sales_value,
RANK() OVER (ORDER BY SUM(order_items.quantity * order_items.price_each) DESC) AS sales_rank
FROM order_items JOIN products  
ON order_items.price_each = products.price
GROUP BY products.product_id,products.product_name
ORDER BY total_sales_value DESC;




-- Q17. compare customer spending across consecutive orders.
select customers.customer_id, customers.name, orders.order_id,payments.payment_amount as current_spending,
lag(payments.payment_amount) over(partition by customers.customer_id) as previous_spending
from customers inner join orders
on customers.customer_id = orders.customer_id
inner join payments
on orders.order_id = payments.order_id;


-- Q18.  forecast expected next purchase (based on order_date).
select customer_id,order_id,order_date,
lead(order_date) over(partition by customer_id order by order_date asc) as expected_order_date
from orders;


-- Q19.  identify high-value customers (total spend > ₹2000).

with higher_value_customer as (select customers.customer_id ,customers.name,sum(order_items.quantity * order_items.price_each) as Total_paid_amount
from customers inner join orders
on customers.customer_id = orders.customer_id
join order_items
on orders.order_id = order_items.order_id
group by customers.customer_id,customers.name)
select * from higher_value_customer
where Total_paid_amount > 2000;

-- Q20. to calculate category-wise sales performance.

with sales_performance as (select  products.category, sum(order_items.quantity * order_items.price_each) as Total_sales_amount
from products inner join order_items
on products.product_id = order_items.product_id
group by products.category)
select * from sales_performance;


-- Q21.  extract all orders with low ratings (< 3).


with low_rating as (select order_items.order_id,products.product_id ,products.product_name, products.category,reviews.rating
from order_items inner join products
on order_items.product_id = products.product_id
join reviews
on order_items.order_id = reviews.order_id
where reviews.rating <3)
select * from low_rating ;



-- Q22. Procedure to get all orders by a customer ID.

delimiter //
create procedure get_customers ( in cust_id int )
begin
select order_id,order_date, customer_id
from orders
where customer_id = cust_id
order by order_date asc ;
end //
delimiter ;
call get_customers  (1);



-- Q23. Procedure to calculate total revenue between two dates.
delimiter //
create procedure Total_income ( in start_date date , in end_date date)
begin 
select sum(order_items.quantity * order_items.price_each) as total_revenue 
from orders inner join order_items
on orders.order_id = order_items.order_id
where orders.order_date between start_date and end_date;
end //
delimiter  ;
call Total_income('2024-01-01', '2024-12-31');


-- Q24. Procedure to show top-rated products in a given category.
delimiter //
create procedure Toprated ( in rated int)
begin 
select products.product_id,products.product_name,products.category,reviews.rating
from products inner join order_items
on products.product_id = order_items.product_id
inner join reviews 
on order_items.order_id = reviews.order_id 
where reviews.rating = rated ;
end //
delimiter ;
call Toprated (5);


-- Q25. Create UDF to calculate average product rating.
delimiter //
create function calculate_average_productrating( )
returns decimal(10,2)
deterministic
begin 
declare avgrate decimal(10,2);
select avg(rating) as avg_product_rating from reviews into avgrate;
return avgrate;
end //
delimiter ;
select calculate_average_productrating();




-- Q26. To flag late reviews (posted after 5 days of delivery).

# here flag means 1 i.e true and 0 i.e false
delimiter //
create function lions(orderid int) 
returns varchar(50)
deterministic
begin
  declare diff_date int;
  set diff_date = (select DATEDIFF(reviews.review_date, payments.payment_date)
from reviews 
JOIN payments  ON reviews.order_id = payments.order_id
WHERE reviews.order_id = orderid);
return case when diff_date > 5 then "Late reviews"
else "review within 5 days"
end;
END //
DELIMITER ;
select lions(1001);



-- Q27. To assign order status scores ('Delivered'=5, 'Returned'=2, 'Cancelled'=0).

 delimiter //
 create function status_order ( status varchar(50))
 returns int
 deterministic
 begin
 return case 
 when status = "Delivered" then 5
 when status = "Returned" then  2
 else 0
 end;
 end //
 delimiter ;
 select order_id , order_date , status,status_order(status) from orders;
 
 
