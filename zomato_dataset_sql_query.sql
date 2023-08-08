drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
VALUES
       (1,'24-09-2017',2),
       (3,'12-08-2019',1),
       (2,'17-02-2020',3),
       (1,'17-12-2019',2),
       (1,'24-10-2018',3),
       (3,'12-02-2016',2),
       (1,'21-09-2016',1),
       (1,'25-02-2016',3),
       (2,'19-04-2017',1),
       (1,'13-11-2017',2),
       (1,'23-11-2016',1),
       (3,'11-10-2016',1),
       (3,'12-07-2017',2),
       (3,'12-05-2016',2),
       (2,'11-08-2017',2),
       (2,'19-10-2018',3);
 

 
 drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);



drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'15-01-2015'),
(3,'11-04-2014');



drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'22-09-2017'),
(3,'21-04-2017');

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;  


-- SOME SQL QUERIES REGARDING THIS DATASET


-- 1. What is the total amount each customer spent on zomato?
select a.userid, sum(b.price) as total_amt_spent from sales a inner join product b on a.product_id = b.product_id
group by a.userid order by total_amt_spent desc

--2. How many days has each customer visited zomato?
select userid, count(distinct created_date) as distinct_days from sales group by userid

--3. What was the first product purchased by each customer?
select *, rank() over(partition by userid order by created_date ) as "rank" from sales

select * from 
 (select *, rank() over(partition by userid order by created_date ) as "rank" from sales)
 a where rank = 1
 
--4. What is the most purchased item on the menu and how many times was it puchased by all customers?
select product_id, count(product_id) as no_of_times_purchased from sales group by product_id order by count(product_id) desc 

select product_id, count(product_id) as no_of_times_purchased from sales group by product_id order by count(product_id) desc limit 1

select product_id  from sales group by product_id order by count(product_id) desc limit 1

select * from sales where product_id = (select product_id  from sales group by product_id order by count(product_id) desc limit 1)

select userid, count(product_id) as count from sales where product_id = (select product_id  from sales group by product_id order by count(product_id) desc limit 1)
group by userid


--5. Which item was the most popular for each customer?
select userid, product_id, count(product_id) as count from sales group by userid, product_id


select * , rank() over(partition by userid order by count desc) as "rank" from
(select userid, product_id, count(product_id) as count from sales group by userid, product_id)a


select * from 
(select * , rank() over(partition by userid order by count desc) as "rank" from
(select userid, product_id, count(product_id) as count from sales group by userid, product_id)a)b
where "rank" = 1
