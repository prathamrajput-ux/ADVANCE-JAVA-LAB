package com.shopsphere.controller;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = productDAO.getAllProducts();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            try {
                String name = request.getParameter("name");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String brand = request.getParameter("brand");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                double discount = 0.0;
                String discountParam = request.getParameter("discount");
                if (discountParam != null && !discountParam.trim().isEmpty()) {
                    discount = Double.parseDouble(discountParam.trim());
                }
                int stock = Integer.parseInt(request.getParameter("stock"));
                String imageUrl = request.getParameter("imageUrl");

                Product product = new Product();
                product.setName(name);
                product.setCategoryId(categoryId);
                product.setBrand(brand);
                product.setDescription(description);
                product.setPrice(price);
                product.setDiscount(discount);
                product.setStock(stock);
                product.setImageUrl(imageUrl);
                product.setStatus("ACTIVE");

                boolean created = productDAO.addProduct(product);
                if (created) {
                    session.setAttribute("flashSuccess", "Product \"" + name + "\" added successfully.");
                } else {
                    session.setAttribute("flashError", "Failed to add product.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Invalid form input: " + e.getMessage());
            }

        } else if ("update".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String name = request.getParameter("name");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                String brand = request.getParameter("brand");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                double discount = Double.parseDouble(request.getParameter("discount"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                String imageUrl = request.getParameter("imageUrl");
                String status = request.getParameter("status");

                Product product = new Product();
                product.setProductId(productId);
                product.setName(name);
                product.setCategoryId(categoryId);
                product.setBrand(brand);
                product.setDescription(description);
                product.setPrice(price);
                product.setDiscount(discount);
                product.setStock(stock);
                product.setImageUrl(imageUrl);
                product.setStatus(status != null ? status : "ACTIVE");

                boolean updated = productDAO.updateProduct(product);
                if (updated) {
                    session.setAttribute("flashSuccess", "Product #" + productId + " updated successfully.");
                } else {
                    session.setAttribute("flashError", "Failed to update product.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error updating product: " + e.getMessage());
            }

        } else if ("delete".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                boolean deleted = productDAO.deleteProduct(productId);
                if (deleted) {
                    session.setAttribute("flashSuccess", "Product #" + productId + " deactivated successfully.");
                } else {
                    session.setAttribute("flashError", "Failed to deactivate product.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error deactivating product: " + e.getMessage());
            }

        } else if ("quickStock".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int amount = Integer.parseInt(request.getParameter("amount"));
                Product p = productDAO.getProductById(productId);
                if (p != null) {
                    p.setStock(Math.max(0, p.getStock() + amount));
                    productDAO.updateProduct(p);
                    session.setAttribute("flashSuccess", "Stock updated for \"" + p.getName() + "\" (" + (amount > 0 ? "+" : "") + amount + " units).");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Error adjusting stock: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
