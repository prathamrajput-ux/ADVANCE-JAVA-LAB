# ShopSphere - Project Overview

> **Detailed Documentation:** For the full breakdown of features, database tables, and code structure, see:  
> 👉 **[ShopSphere/src/README.md](src/README.md)**

---

### Student Info
* **Name:** Pratham Kumar Singh
* **Roll No:** 24EGJAD036
* **College:** Global Institute of Technology (GIT), Jaipur
* **University:** Rajasthan Technical University (RTU), Kota
* **Semester:** 5th Semester (B.Tech CSE / AI & DS)
* **Subject:** Advanced Java Programming Lab Project

---

## What is this project?

ShopSphere is an e-commerce website with an admin panel and a desktop stock viewer.
* **Web App:** Built with Servlets, JSP, JSTL, running on Tomcat 11. Allows customers to buy items and admins to manage the store.
* **Desktop App:** Built with Java Swing (`SwingInventoryViewer.java`). Shows real-time product stock directly from MySQL with low-stock warnings and restock options.

Both the web and desktop applications run on the same MySQL database.

---

## Quick Run

The fastest way to run everything is using the launcher in the `PROJECT` folder:
```cmd
cd ..
quick_start.bat
```
Choose `1` to set up the database, build with Maven, and start Tomcat in one go.

To run only the desktop inventory viewer:
```cmd
run_desktop_swing.bat
```

---

## Test Logins

* **Admin:** `admin@shopsphere.com` / `admin123`
* **Customer:** `customer@shopsphere.com` / `user123`
