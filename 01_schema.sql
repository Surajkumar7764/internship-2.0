-- ============================================================
-- PROJECT 5: E-COMMERCE PERFORMANCE ANALYSIS USING SQL
-- File: 01_schema.sql
-- Purpose: Product, order, and delivery datasets normalized and
--          connected to measure sales, conversion, and delivery KPIs
-- ============================================================

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS website_visits;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- Customers table
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    city          TEXT,
    signup_date   DATE NOT NULL
);

-- Products table
CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  TEXT NOT NULL,
    category      TEXT NOT NULL,
    price         DECIMAL(10,2) NOT NULL
);

-- Website visits table (for conversion rate)
CREATE TABLE website_visits (
    visit_id     INTEGER PRIMARY KEY,
    customer_id   INTEGER,              -- NULL allowed = anonymous/guest visit
    visit_date     DATE NOT NULL,
    visit_hour       INTEGER NOT NULL CHECK (visit_hour BETWEEN 0 AND 23),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Orders table
CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id    INTEGER NOT NULL,
    order_date      DATE NOT NULL,
    order_hour        INTEGER NOT NULL CHECK (order_hour BETWEEN 0 AND 23),
    status              TEXT NOT NULL CHECK (status IN ('Delivered','Cancelled','Processing')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order items table
CREATE TABLE order_items (
    order_item_id  INTEGER PRIMARY KEY,
    order_id        INTEGER NOT NULL,
    product_id        INTEGER NOT NULL,
    quantity            INTEGER NOT NULL,
    unit_price            DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Deliveries table
CREATE TABLE deliveries (
    delivery_id      INTEGER PRIMARY KEY,
    order_id           INTEGER NOT NULL UNIQUE,
    expected_date         DATE NOT NULL,
    delivered_date           DATE,               -- NULL if not yet delivered
    delivery_status            TEXT NOT NULL CHECK (delivery_status IN ('On Time','Delayed','Not Delivered')),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE INDEX idx_visits_date ON website_visits(visit_date);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);
CREATE INDEX idx_deliveries_order ON deliveries(order_id);
