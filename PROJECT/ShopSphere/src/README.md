# ShopSphere - Online E-Commerce & Inventory Management System
### Advanced Java Lab Project (5th Semester)

**Developer:** Pratham Kumar Singh  
**Roll No:** 24EGJAD036  
**Course:** B.Tech Computer Science & Engineering / AI & DS (5th Sem)  
**College:** Global Institute of Technology (GIT), Jaipur  
**University:** Rajasthan Technical University (RTU), Kota  

---

## What is ShopSphere?

ShopSphere is an e-commerce project built for my 5th Semester Advanced Java Lab. 

Instead of making just a standard website or just a desktop form, I combined both:
1. **Web Store (Tomcat Web Application):** A full web application using Servlets and JSP where customers can browse products, manage their cart, and place orders. It also includes an admin panel to manage products and track orders.
2. **Desktop Inventory Tool (Java Swing GUI):** A standalone desktop app (`SwingInventoryViewer.java`) made for back-office or shop managers. It connects directly to the same MySQL database via JDBC, displays current stock levels in a table, and allows one-click restocking.

Both the website and desktop application run simultaneously on the same MySQL database, so whenever a customer buys an item online or stock is updated from the desktop app, the changes reflect in real time.

---

## Tech Stack Used

* **Language:** Java (JDK 17)
* **Web Layer:** Jakarta Servlets 6.1, JSP 3.1, JSTL 3.0
* **Desktop UI:** Java Swing (MVC pattern)
* **Database:** MySQL 8.x (using MySQL Connector/J 8.3)
* **Server:** Apache Tomcat 11
* **Build Tool:** Apache Maven 3.9
* **Styling:** Custom CSS with responsive layouts

---

## Features

### 1. Customer Web Store
* **User Accounts:** Sign up, log in, session tracking, and logout.
* **Product Catalog:** Products organized into categories (Electronics, Fashion, Home & Living, Books, Fitness, Personal Care).
* **Live Search & Filters:** Search products by name, filter by category, and sort by price.
* **Shopping Cart:** Add items, change quantities, remove items, with automatic subtotal and discount calculations.
* **Checkout & Orders:** Enter shipping address, choose payment mode (Cash on Delivery or Card simulation), and get an instant order confirmation.
* **My Orders Page:** View all previous orders with their current delivery status.

### 2. Admin Panel (`/admin/dashboard`)
* **Dashboard Summary:** Quick look at total revenue, total orders placed, registered customers, and low-stock alerts.
* **Product Management:** Add new products with image URLs, change prices, update stock, or remove products.
* **Order Management:** View all customer orders and change order status (`Processing` ➔ `Shipped` ➔ `Delivered` ➔ `Cancelled`).
* **Customer List:** View registered users and their details.

### 3. Desktop Swing Inventory App (`SwingInventoryViewer`)
* Opens as a native desktop window.
* Shows all products in a clean `JTable` with columns: ID, Name, Category, Price, and Stock.
* Automatically highlights low-stock items (stock under 5) in red so the warehouse team knows what to reorder.
* Has a "Restock" button to quickly add quantity to any selected item directly in MySQL.

---

## Database Design

The database schema is saved in [`database/shopsphere.sql`](file:///p:/Vth%20SEM/ADVANCE%20JAVA%20LAB/PROJECT/ShopSphere/database/shopsphere.sql). It has 5 main tables:

1. **`users`** - Stores customer and admin accounts (name, email, hashed password, phone, role).
2. **`categories`** - Product categories.
3. **`products`** - Product items with category ID, title, brand, description, price, discount, stock, and image link.
4. **`orders`** - Placed orders with user ID, shipping address, total amount, payment method, and status.
5. **`order_items`** - Items inside each order with product ID, quantity, and price at purchase time.

The SQL file also comes with **24 sample products** across all 6 categories, so the store is pre-loaded with realistic data upon import.

---

## Project Structure

```text
ShopSphere/
├── pom.xml                               # Maven build configuration & dependencies
├── database/
│   └── shopsphere.sql                   # MySQL tables schema + seed items
└── src/
    ├── README.md                        # This project documentation
    └── main/
        ├── java/com/shopsphere/
        │   ├── controller/              # Servlets (ProductServlet, CartServlet, CheckoutServlet, etc.)
        │   ├── dao/                     # JDBC Database access classes (UserDAO, ProductDAO, OrderDAO)
        │   ├── desktop/                 # SwingInventoryViewer.java (Desktop app)
        │   ├── filter/                  # AuthFilter (protects admin pages) & EncodingFilter
        │   ├── model/                   # Data objects / POJOs (User, Product, Order, CartItem)
        │   └── util/                    # DBConnectionUtil.java (JDBC connection helper)
        │
        └── webapp/                      # JSP pages, HTML, CSS & web assets
            ├── WEB-INF/web.xml          # Web deployment descriptor
            ├── fragments/               # header.jsp, navbar.jsp, footer.jsp
            ├── admin/                   # Admin pages (dashboard.jsp, products.jsp, orders.jsp, users.jsp)
            ├── index.jsp                # Store homepage
            ├── products.jsp             # Catalog & search page
            ├── product-details.jsp      # Single product page
            ├── cart.jsp                 # Shopping cart
            ├── checkout.jsp             # Checkout & address form
            ├── order-success.jsp        # Order receipt page
            ├── orders.jsp               # Past orders list
            ├── login.jsp                # Login form
            └── register.jsp             # Register form
```

---

## How to Run

### Method 1: Using the 1-Click Batch File (Recommended)
Inside the `PROJECT/` folder, run:
```cmd
quick_start.bat
```
Press `1` for **1-Click Launch**. It will:
1. Automatically run `setup_database.bat` to import `shopsphere.sql` into MySQL.
2. Build the project using Maven (`mvn clean package`).
3. Deploy the WAR file and start Apache Tomcat.
4. Open the website in your browser at `http://localhost:8080/ShopSphere/`.

To launch the desktop inventory app, just select option `3` in the menu or double-click `run_desktop_swing.bat`.

---

### Method 2: Manual Setup

1. **Import the Database:**
   Open MySQL Workbench or MySQL Command Line and run:
   ```sql
   source P:/Vth SEM/ADVANCE JAVA LAB/PROJECT/ShopSphere/database/shopsphere.sql;
   ```

2. **Build with Maven:**
   ```cmd
   cd "P:\Vth SEM\ADVANCE JAVA LAB\PROJECT\ShopSphere"
   mvn clean package -DskipTests
   ```
   This creates `target/ShopSphere.war`.

3. **Deploy on Tomcat:**
   * Copy `target/ShopSphere.war` into your Tomcat `webapps/` folder.
   * Start Tomcat using `bin/startup.bat`.
   * Open `http://localhost:8080/ShopSphere/` in your browser.

4. **Run the Desktop Inventory Viewer:**
   ```cmd
   cd "P:\Vth SEM\ADVANCE JAVA LAB\PROJECT"
   run_desktop_swing.bat
   ```

---

## Test Accounts

You can test the project immediately with these accounts:

| Account Type | Email | Password | Access |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@shopsphere.com` | `admin123` | Access to `/admin/dashboard`, add/edit items, manage orders |
| **Customer** | `customer@shopsphere.com` | `user123` | Browse store, add to cart, place orders |

*Note: You can also register any new customer account directly from the website's Register page.*

---

## Key Concepts Demonstrated in this Project

* **MVC Pattern:** Servlets handle requests (Controller), DAOs handle database queries (Model), and JSPs render the HTML (View).
* **PreparedStatements:** Used in every DAO query to prevent SQL Injection.
* **Session Management:** Java `HttpSession` used for user login state and shopping cart tracking.
* **Filters:** `AuthFilter` intercepts any URL starting with `/admin/` and redirects non-admin users to login.
* **Try-with-Resources:** All database connections and statements are automatically closed to prevent memory/connection leaks.
* **Desktop & Web Integration:** Shows how a desktop Java Swing app and a web app can cooperate using a shared relational database.
