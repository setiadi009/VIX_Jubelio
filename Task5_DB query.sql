CREATE TABLE IF NOT EXISTS promo_code
	(promo_id int PRIMARY KEY NOT null,
	promo_name varchar,
	price_deduction int,
	Description varchar,
	Duration int);

CREATE TABLE IF NOT EXISTS q3_q4_Review (
	purchase_date date,
	total_price int,
	promo_code int,
	sales_after_promo int);

COPY promo_code(promo_id, promo_name, price_deduction, Description, duration)
FROM 'C:\Users\Public\Documents\promo_code.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO q3_q4_review(purchase_date, total_price, promo_code, sales_after_promo)
SELECT 
    sales.purchase_date,
    (sales.quantity * marketplace.price) as total_price,
    sales.promo_id,
    (sales.quantity * marketplace.price - promo.price_deduction) as sales_after_promo
FROM
    sales_table sales
JOIN
    marketplace_table marketplace ON sales.item_id = marketplace.item_id
JOIN
    promo_code promo ON sales.promo_id = promo.promo_id
WHERE
    EXTRACT(MONTH FROM sales.purchase_date) BETWEEN 7 AND 12
    AND EXTRACT(YEAR FROM sales.purchase_date) = 2022;

CREATE TABLE IF NOT EXISTS shipping_summary(
	shipping_date date,
	seller_name varchar,
	buyer_name varchar,
	buyer_adress varchar,
	buyer_city varchar,
	buyer_zipcode bigint,
	tracking_code varchar);
	
INSERT INTO shipping_summary(shipping_date, seller_name, buyer_name, buyer_adress, buyer_city, buyer_zipcode, tracking_code)
SELECT 
	shipping.shipping_date,
	seller.seller_name,
	buyer.buyer_name,
	buyer.address,
	buyer.city,
	buyer.zipcode,
	CONCAT(shipping.shipping_id, '-', TO_CHAR(shipping.purchase_date, 'YYYYMMDD'), '-', TO_CHAR(shipping.shipping_date, 'YYYYMMDD'), '-', buyer.buyer_id, '-', seller.seller_id) 
		AS tracking_code
FROM
	shipping_table shipping
JOIN 
	seller_table seller ON shipping.seller_id = seller.seller_id
JOIN 
	buyer_table buyer ON shipping.buyer_id = buyer.buyer_id;