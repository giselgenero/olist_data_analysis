CREATE SCHEMA olist;

SELECT * FROM olist_raw.customers;

-- Chequeo de duplicados
SELECT count(*), count(distinct (customer_id)), count(distinct (customer_unique_id))
from olist_raw.customers;

select length(phone_number) from olist_raw.customers
order by 1 desc;

-- Table structure for table `customers` 

CREATE TABLE olist.customers (
  `customer_id` varchar (40),
  `customer_unique_id` varchar (40) default null,
  `id_customer_zip_code_prefix` int DEFAULT NULL,
  `customer_city` varchar (100) DEFAULT NULL,
  `customer_state` varchar (40) DEFAULT NULL,
  `first_name` text DEFAULT NULL,
  `last_name` text DEFAULT NULL,
  `email` varchar (40) DEFAULT NULL,
  `phone` varchar (20) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ;
 

-- Insercion de datos en la tabla
insert into olist.customers
select customer_id, customer_unique_id, 
customer_zip_code_prefix, 
customer_city,
customer_state, 
first_name,
last_name,
email,
phone_number FROM olist_raw.customers;

SELECT customer_unique_id, count(*) as cant_orders
from olist_raw.customers
group by customer_unique_id
order by cant_orders desc;


-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE olist.orders (
  `order_id` varchar (40),
  `customer_id` varchar (40) DEFAULT NULL,
  `order_status` text DEFAULT NULL,
  `order_purchase_timestamp` datetime DEFAULT NULL,
  `order_approved_at` datetime DEFAULT NULL,
  `order_delivered_carrier_date` datetime DEFAULT NULL,
  `order_delivered_customer_date` datetime DEFAULT NULL,
  `order_estimated_delivery_date` datetime DEFAULT NULL, 
  primary key (order_id)
) ;
  
 INSERT INTO olist.orders
 SELECT 
    order_id, 
    customer_id, 
    order_status,
    CASE order_purchase_timestamp WHEN "" then null ELSE STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') END AS purchase_date,
	CASE order_approved_at WHEN "" then null ELSE STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s') END AS approved_date,
	CASE order_delivered_carrier_date WHEN "" then null ELSE STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s') END AS delivered_carrier_date,
	CASE order_delivered_customer_date WHEN "" then null ELSE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s') END AS customer_carrier_date,
    CASE order_estimated_delivery_date WHEN "" then null ELSE STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s') END AS estimated_delivered_date
   FROM olist_raw.orders;

-- Agrego foreign key a la tabla de orders 
ALTER TABLE olist.orders
ADD FOREIGN KEY (customer_id) REFERENCES olist.customers(customer_id);

-- Table structure for table `order_items` 

CREATE TABLE olist.order_items (
   `order_id` varchar(40) DEFAULT NULL,
  `order_item_id` int DEFAULT NULL,
  `product_id` varchar(40) DEFAULT NULL,
  `seller_id` varchar(40) DEFAULT NULL,
  `shipping_limit_date` datetime DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `freight_value` decimal(10,2) DEFAULT NULL
);
  
  INSERT INTO olist.order_items
 SELECT 
    order_id, 
    order_item_id, 
	product_id,
    seller_id,
    CASE shipping_limit_date WHEN "" then null ELSE STR_TO_DATE(shipping_limit_date, '%Y-%m-%d %H:%i:%s') END AS shipping_limit_date,
	price,
    freight_value
   FROM olist_raw.order_items;

-- Agrego foreign key a la tabla de orders_items 
ALTER TABLE olist.order_items
ADD FOREIGN KEY (order_id) REFERENCES olist.orders(order_id);

ALTER TABLE olist.order_items
ADD FOREIGN KEY (seller_id) REFERENCES olist.sellers(seller_id);

ALTER TABLE olist.order_items
ADD FOREIGN KEY (product_id) REFERENCES olist.products(product_id);

-- Table structure for table `order_payments`

CREATE TABLE olist.payments (
   `order_id` varchar (40) DEFAULT NULL,
  `payment_sequential` int DEFAULT NULL,
  `payment_type` varchar (40) DEFAULT NULL,
  `payment_installments` int DEFAULT NULL,
  `payment_value` decimal(10,2) DEFAULT NULL
) ;

-- Agrego foreign key a la tabla de payments 
ALTER TABLE olist.payments
ADD FOREIGN KEY (order_id) REFERENCES olist.orders(order_id);

INSERT INTO olist.payments
 SELECT 
    order_id, 
    payment_sequential, 
    payment_type,
	payment_installments,
    payment_value   
   FROM olist_raw.payments;
   
-- Table structure for table productos

CREATE TABLE olist.products (
  `product_id` varchar (40),
  `product_category_name` varchar (100) DEFAULT NULL,
  `product_name_lenght` int DEFAULT NULL,
  `product_description_lenght` int DEFAULT NULL,
  `product_photos_qty` int DEFAULT NULL,
  `product_weight_g` int DEFAULT NULL,
  `product_length_cm` int DEFAULT NULL,
  `product_height_cm` int DEFAULT NULL,
  `product_width_cm` int DEFAULT NULL,
  PRIMARY KEY (product_id)
) ;

insert into olist.products
	select  product_id, 
	product_category_name, 
	product_name_lenght, 
	product_description_lenght, 
	product_photos_qty, 
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
    from olist_raw.productsv2;
   
-- Table structure for table `sellers`

DROP TABLE IF EXISTS `sellers`;
CREATE TABLE olist.sellers (
  `seller_id` varchar (40),
  `seller_zip_code_prefix` int DEFAULT NULL,
  `seller_city` varchar (100) DEFAULT NULL,
  `seller_state` varchar (40) DEFAULT NULL,
  primary key (seller_id)
);

INSERT INTO olist.sellers
select seller_id, 
seller_zip_code_prefix,
seller_city,
seller_state
from olist_raw.sellers;

-- Table structure for table `order_reviews`

DROP TABLE IF EXISTS olist.reviews;
CREATE TABLE olist.reviews (
  `review_id` varchar (40),
  `order_id` varchar (40),
  `review_score` int DEFAULT NULL,
  `review_creation_date` datetime DEFAULT NULL,
  `review_answer_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (review_id,order_id)
) ;

insert into olist.reviews
select review_id,
order_id,
review_score,
CASE review_creation_date WHEN "" then null ELSE STR_TO_DATE(review_creation_date, '%d/%m/%Y %H:%i') END AS review_creation_date,
CASE review_answer_timestamp WHEN "" then null ELSE STR_TO_DATE(review_answer_timestamp, '%d/%m/%Y %H:%i') END AS review_answer_timestamp
from olist_raw.reviews;

-- Error por el que se crea primary key compuesta
/*SELECT * FROM olist_raw.reviews
where REVIEW_ID = '3242cc306a9218d0377831e175d62fbf';*/

ALTER TABLE olist.reviews
ADD FOREIGN KEY (order_id) REFERENCES olist.orders(order_id);