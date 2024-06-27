SET SQL_SAFE_UPDATES=0;
CREATE DATABASE inventoryDB;
USE inventoryDB;
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2),
    quantity INT,
    category VARCHAR(255)
);
INSERT INTO products (name, description, price, quantity, category) VALUES
('Product1', 'Description of product 1', 100.00, 50, 'Category1'),
('Product2', 'Description of product 2', 200.00, 30, 'Category2'),
('Product3', 'Description of product 3', 150.00, 20, 'Category3');
SELECT * FROM products;
SELECT * FROM products WHERE price < 150.00;
SELECT * FROM products WHERE quantity > 25;
UPDATE products SET price = 120.00 WHERE name = 'Product1';
SELECT * FROM products;
DELETE FROM products WHERE name = 'Product3';
SELECT * FROM products;
