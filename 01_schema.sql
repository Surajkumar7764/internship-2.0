-- ============================================================
-- PROJECT 1: SALES DATA ANALYSIS USING SQL
-- File: 01_schema.sql
-- Purpose: Create a well-structured relational schema
--          (customers, products, orders, order_items, payments)
-- ============================================================

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Customers table
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email         TEXT UNIQUE NOT NULL,
    city          TEXT,
    signup_date   DATE NOT NULL
);

-- Products table
CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  TEXT NOT NULL,
    category      TEXT NOT NULL,
    price         DECIMAL(10,2) NOT NULL,   -- selling price
    cost          DECIMAL(10,2) NOT NULL    -- cost to business (for profit margin)
);

-- Orders table
CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER NOT NULL,
    order_date    DATE NOT NULL,
    status        TEXT NOT NULL CHECK (status IN ('Completed','Cancelled','Pending')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order items table (one order can have many products)
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER NOT NULL,
    product_id    INTEGER NOT NULL,
    quantity      INTEGER NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments table
CREATE TABLE payments (
    payment_id     INTEGER PRIMARY KEY,
    order_id       INTEGER NOT NULL,
    payment_date   DATE NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_method TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Helpful indexes for performance (well-structured requirement)
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);
CREATE INDEX idx_payments_order ON payments(order_id);
