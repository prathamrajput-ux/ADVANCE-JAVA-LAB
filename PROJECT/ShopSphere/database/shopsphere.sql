-- ===================================================================
-- ShopSphere E-Commerce Database Schema & Comprehensive Enterprise Dataset
-- RTU Advanced Java / Java Enterprise Project
-- ===================================================================

CREATE DATABASE IF NOT EXISTS shopsphere;
USE shopsphere;

-- -------------------------------------------------------------------
-- 1. Table Drops (Foreign Key Ordered)
-- -------------------------------------------------------------------
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- -------------------------------------------------------------------
-- 2. Table: users
-- -------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    mobile VARCHAR(20),
    role VARCHAR(20) DEFAULT 'CUSTOMER',  -- 'CUSTOMER' or 'ADMIN'
    status VARCHAR(20) DEFAULT 'ACTIVE',  -- 'ACTIVE' or 'INACTIVE'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------------
-- 3. Table: categories
-- -------------------------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- -------------------------------------------------------------------
-- 4. Table: products
-- -------------------------------------------------------------------
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(150) NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(5, 2) DEFAULT 0.00,
    stock INT DEFAULT 0,
    image_url VARCHAR(255),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id)
        REFERENCES categories(category_id) ON DELETE SET NULL
);

-- -------------------------------------------------------------------
-- 5. Table: orders
-- -------------------------------------------------------------------
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shipping_address TEXT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    payment_method VARCHAR(50) DEFAULT 'Cash On Delivery',
    payment_status VARCHAR(50) DEFAULT 'Completed',
    order_status VARCHAR(50) DEFAULT 'Processing', -- Processing, Shipped, Delivered, Cancelled
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id)
        REFERENCES users(user_id) ON DELETE CASCADE
);

-- -------------------------------------------------------------------
-- 6. Table: order_items
-- -------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product FOREIGN KEY (product_id)
        REFERENCES products(product_id) ON DELETE SET NULL
);

-- ===================================================================
-- Comprehensive Enterprise Seed Data
-- ===================================================================

-- 1. Essential App Administrator & Demo Customer
INSERT INTO users (name, email, password, mobile, role, status, created_at) VALUES
('Super Administrator', 'admin@shopsphere.com', 'admin123', '9829012345', 'ADMIN', 'ACTIVE', '2026-01-10 10:00:00'),
('Demo Customer', 'customer@shopsphere.com', 'user123', '9829112233', 'CUSTOMER', 'ACTIVE', '2026-01-10 10:00:00');

-- 2. Categories
INSERT INTO categories (category_id, name, description, status) VALUES
(1, 'Electronics & Gadgets', 'Smart devices, audio gear, computing accessories, and wearables.', 'ACTIVE'),
(2, 'Fashion & Apparel', 'Contemporary clothing, premium footwear, jackets, and accessories.', 'ACTIVE'),
(3, 'Home & Living', 'Kitchen appliances, thermal drinkware, cookware, and modern decor.', 'ACTIVE'),
(4, 'Books & Learning', 'Core computer science textbooks, programming guides, and bestsellers.', 'ACTIVE'),
(5, 'Fitness & Outdoors', 'Gym accessories, yoga gear, training equipment, and outdoor gear.', 'ACTIVE'),
(6, 'Personal Care', 'Grooming kits, organic skin care, fragrances, and daily essentials.', 'ACTIVE');

-- 3. Rich Products Dataset (24 items across all 6 categories)
INSERT INTO products (category_id, name, brand, description, price, discount, stock, image_url, status) VALUES
-- Electronics
(1, 'Wireless Noise-Canceling Headphones', 'SoundMax', 'High-definition 40mm drivers with active hybrid noise cancellation and 35-hour battery life.', 3499.00, 15.00, 22, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500', 'ACTIVE'),
(1, 'Smart AMOLED Fitness Watch', 'FitPulse', 'Ultra-crisp 1.43-inch display, 24/7 heart rate monitor, SpO2 sensor, and 10-day battery backup.', 2999.00, 20.00, 35, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500', 'ACTIVE'),
(1, 'RGB Mechanical Gaming Keyboard', 'KeyTech', 'Tactile blue switches, per-key RGB backlighting with braided USB-C cable and aluminum body.', 2299.00, 10.00, 14, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500', 'ACTIVE'),
(1, 'Ultra-Slim Ergonomic Wireless Mouse', 'LogiWave', 'Dual-mode Bluetooth 5.2 and 2.4GHz wireless connection with silent click switches.', 999.00, 5.00, 4, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500', 'ACTIVE'),
(1, 'Portable Bluetooth Speaker 20W', 'BoomBass', 'Waterproof IPX7 speaker with deep bass radiator, party pairing mode, and 12-hour playback.', 1799.00, 12.00, 18, 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500', 'ACTIVE'),

-- Fashion
(2, 'Classic Washed Denim Jacket', 'UrbanStyle', 'Tailored from 100% breathable cotton denim with durable metal buttons and dual chest pockets.', 1899.00, 15.00, 28, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500', 'ACTIVE'),
(2, 'Breathable Running Sports Shoes', 'AeroStride', 'High-rebound EVA foam sole with flexible mesh upper designed for jogging, marathon, and gym.', 2499.00, 10.00, 16, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500', 'ACTIVE'),
(2, 'Casual Cotton Slim-Fit Oxford Shirt', 'StitchCraft', 'Timeless button-down formal-casual shirt crafted from pre-shrunk combed organic cotton.', 1199.00, 20.00, 42, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500', 'ACTIVE'),
(2, 'Polarized Aviator Sunglasses', 'SunShield', 'UV400 protective polarized lenses in a lightweight corrosion-resistant metallic alloy frame.', 899.00, 25.00, 3, 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500', 'ACTIVE'),

-- Home & Living
(3, 'Stainless Steel Double-Wall Thermal Flask (1L)', 'HydroKeep', 'Vacuum insulation keeps beverages hot for 18 hours or ice-cold for 24 hours. BPA-free lid.', 799.00, 0.00, 50, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=500', 'ACTIVE'),
(3, 'Ceramic Minimalist Pour-Over Coffee Dripper', 'BeanCraft', 'Handcrafted matte ceramic brewer for extracting smooth, rich pour-over coffee at home.', 849.00, 10.00, 19, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500', 'ACTIVE'),
(3, 'Modern Non-Stick Cast Iron Skillet 28cm', 'ChefPro', 'Pre-seasoned heavy-duty cast iron skillet with ergonomic heat-resistant silicone handle grip.', 1699.00, 5.00, 12, 'https://images.unsplash.com/photo-1590794056226-79ef3a8147e1?w=500', 'ACTIVE'),
(3, 'Ambient LED Desk Lamp with Wireless Charging', 'LumiGlow', 'Touch dimmer control, adjustable color temperatures (3000K-6000K), and built-in 10W Qi charger.', 1499.00, 15.00, 2, 'https://images.unsplash.com/photo-1534073828943-f801091bb18c?w=500', 'ACTIVE'),

-- Books & Learning
(4, 'Effective Java (3rd Edition)', 'Addison-Wesley', 'The industry standard guide by Joshua Bloch with 90 best practices for enterprise Java developers.', 890.00, 10.00, 30, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500', 'ACTIVE'),
(4, 'Designing Data-Intensive Applications', 'O Reilly Media', 'Martin Kleppmanns authoritative guide on distributed storage, transactions, and data pipelines.', 1250.00, 5.00, 15, 'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?w=500', 'ACTIVE'),
(4, 'Clean Code: A Handbook of Agile Software Craftmanship', 'Prentice Hall', 'Robert C. Martin guides developers on writing readable, testable, and maintainable software.', 799.00, 12.00, 20, 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=500', 'ACTIVE'),
(4, 'Hardcover Dotted Bullet Journal (A5)', 'ArtisansNote', '160 GSM bleed-resistant ivory paper with pen loop, inner back pocket, and double ribbon bookmarks.', 499.00, 0.00, 60, 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=500', 'ACTIVE'),

-- Fitness & Outdoors
(5, 'Non-Slip Eco TPE Yoga Mat 6mm', 'ZenFlex', 'Dual-textured grip surface with body alignment guidance lines and carrying strap included.', 1099.00, 18.00, 25, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500', 'ACTIVE'),
(5, 'Adjustable Neoprene Dumbbell Pair (10kg)', 'IronForce', 'Anti-roll hex design with soft-touch non-slip neoprene coating for home strength workouts.', 1799.00, 10.00, 10, 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=500', 'ACTIVE'),
(5, 'High-Density Foam Roller for Deep Tissue Massage', 'MuscleRelief', 'Target tight myofascial trigger points, relieve back soreness, and accelerate athletic recovery.', 649.00, 15.00, 5, 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=500', 'ACTIVE'),

-- Personal Care
(6, 'Professional Electric Beard & Hair Trimmer', 'GroomMaster', 'Self-sharpening titanium blades with 20 precision length dial settings and 90min run time.', 1399.00, 20.00, 24, 'https://images.unsplash.com/photo-1621607512214-68297480165e?w=500', 'ACTIVE'),
(6, 'Organic Vitamin C Brightening Facial Serum', 'DermaPure', 'Formulated with hyaluronic acid, 20% active Vitamin C, and antioxidant ferulic plant extracts.', 599.00, 10.00, 45, 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500', 'ACTIVE'),
(6, 'Essential Oil Aromatherapy Diffuser 500ml', 'AuraMist', 'Ultrasonic quiet cold-mist humidifier with 7 color LED night lights and auto-shutoff timer.', 1299.00, 15.00, 18, 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=500', 'ACTIVE'),
(6, 'Activated Charcoal Whitening Toothpaste', 'SmileBright', 'Enamel-safe fluoride-free mineral toothpaste formulated with bamboo charcoal and peppermint.', 299.00, 0.00, 80, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500', 'ACTIVE');
