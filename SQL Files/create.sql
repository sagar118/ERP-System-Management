DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS categories_description;
DROP TABLE IF EXISTS post_address_lookup CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS territories CASCADE;
DROP TABLE IF EXISTS employee_territories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS shippers CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_details CASCADE;

CREATE TABLE categories(
id int PRIMARY KEY,
name varchar(25) NOT NULL
);

CREATE TABLE categories_description (
category_id int REFERENCES categories(id) ON DELETE SET NULL ON UPDATE CASCADE,
description varchar(100)
);

CREATE TABLE post_address_lookup(
postal_code varchar(20) NOT NULL,
country varchar(20) NOT NULL,
city varchar(30) NOT NULL,
PRIMARY KEY (postal_code, country)
);

CREATE TABLE supplier(
id int PRIMARY KEY,
company_name varchar(40) NOT NULL,
contact_name varchar(40) NOT NULL,
contact_title varchar(40),
postal_code varchar(20) NOT NULL,
country varchar(20),
contact varchar(16) NOT NULL,
FOREIGN KEY (postal_code, country) REFERENCES post_address_lookup (postal_code, country) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE products(
id int PRIMARY KEY,
name varchar(40) NOT NULL,
supplier_id int REFERENCES supplier(id) ON DELETE SET NULL ON UPDATE CASCADE,
category_id int REFERENCES categories(id) ON DELETE SET NULL ON UPDATE CASCADE,
quantity_per_unit int NOT NULL,
unit_price float NOT NULL,
stock int NOT NULL DEFAULT 0,
discontinued BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE employees(
id int PRIMARY KEY,
last_name varchar(25) NOT NULL,
first_name varchar(25) NOT NULL,
title varchar(25),
birthdate DATE,
hire_date DATE DEFAULT CURRENT_DATE,
postal_code VARCHAR(20) NOT NULL,
country varchar(20),
contact varchar(16) NOT NULL,
reports_to int REFERENCES employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (postal_code, country) REFERENCES post_address_lookup (postal_code, country) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE territories(
id int PRIMARY KEY,
name varchar(30) NOT NULL 
);

CREATE TABLE employee_territories(
employee_id int REFERENCES employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
territory_id int REFERENCES territories(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE customers(
id varchar(10) PRIMARY KEY,
name varchar(50) NOT NULL,
contact_name varchar(40) NOT NULL,
title varchar(40),
postal_code varchar(20) NOT NULL,
country varchar(20),
contact varchar(20) NOT NULL,
FOREIGN KEY (postal_code, country) REFERENCES post_address_lookup (postal_code, country) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE shippers(
id int PRIMARY KEY,
name varchar(25) NOT NULL,
contact varchar(16) NOT NULL
);

CREATE TABLE orders(
id int PRIMARY KEY,
customer_id varchar(10) REFERENCES customers(id) ON DELETE SET NULL ON UPDATE CASCADE,
employee_id int REFERENCES employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
order_date DATE DEFAULT CURRENT_DATE,
delivery_date DATE,
shipped_date DATE,
shipper_id int REFERENCES shippers(id) ON DELETE SET NULL ON UPDATE CASCADE,
weight FLOAT,
ship_name VARCHAR(40),
ship_postal_code varchar(20) NOT NULL,
ship_country varchar(20),
FOREIGN KEY (ship_postal_code, ship_country) REFERENCES post_address_lookup (postal_code, country) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE order_details(
order_id int REFERENCES orders(id) ON DELETE SET NULL ON UPDATE CASCADE,
product_id int REFERENCES products(id) ON DELETE SET NULL ON UPDATE CASCADE,
unit_price FLOAT NOT NULL,
quantity int not NULL,
discount FLOAT DEFAULT 0
);