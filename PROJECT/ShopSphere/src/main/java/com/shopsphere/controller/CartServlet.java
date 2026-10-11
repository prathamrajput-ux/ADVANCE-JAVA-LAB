package com.shopsphere.controller;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        // Calculate Cart Totals
        double subtotal = 0.0;
        int totalItems = 0;
        for (CartItem item : cart) {
            subtotal += item.getTotalPrice();
            totalItems += item.getQuantity();
        }

        request.setAttribute("subtotal", subtotal);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("grandTotal", subtotal); // Free standard shipping

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        switch (action) {
            case "add":
                handleAdd(request, session, cart);
                break;
            case "update":
                handleUpdate(request, session, cart);
                break;
            case "remove":
                handleRemove(request, session, cart);
                break;
            case "clear":
                cart.clear();
                session.setAttribute("flashSuccess", "Cart has been emptied.");
                break;
            default:
                break;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleAdd(HttpServletRequest request, HttpSession session, List<CartItem> cart) {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");

        if (productIdParam != null) {
            try {
                int productId = Integer.parseInt(productIdParam.trim());
                int quantity = 1;
                if (quantityParam != null && !quantityParam.trim().isEmpty()) {
                    quantity = Math.max(1, Integer.parseInt(quantityParam.trim()));
                }

                Product product = productDAO.getProductById(productId);
                if (product != null && product.getStock() > 0) {
                    boolean exists = false;
                    for (CartItem item : cart) {
                        if (item.getProduct().getProductId() == productId) {
                            int newQty = Math.min(item.getQuantity() + quantity, product.getStock());
                            item.setQuantity(newQty);
                            exists = true;
                            break;
                        }
                    }

                    if (!exists) {
                        int finalQty = Math.min(quantity, product.getStock());
                        cart.add(new CartItem(product, finalQty));
                    }

                    session.setAttribute("flashSuccess", "\"" + product.getName() + "\" added to cart.");
                } else {
                    session.setAttribute("flashError", "Selected product is out of stock.");
                }
            } catch (NumberFormatException ignored) {
            }
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpSession session, List<CartItem> cart) {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");

        if (productIdParam != null && quantityParam != null) {
            try {
                int productId = Integer.parseInt(productIdParam.trim());
                int quantity = Integer.parseInt(quantityParam.trim());

                if (quantity <= 0) {
                    cart.removeIf(item -> item.getProduct().getProductId() == productId);
                    session.setAttribute("flashSuccess", "Item removed from cart.");
                } else {
                    for (CartItem item : cart) {
                        if (item.getProduct().getProductId() == productId) {
                            int cappedQty = Math.min(quantity, item.getProduct().getStock());
                            item.setQuantity(cappedQty);
                            session.setAttribute("flashSuccess", "Cart quantity updated.");
                            break;
                        }
                    }
                }
            } catch (NumberFormatException ignored) {
            }
        }
    }

    private void handleRemove(HttpServletRequest request, HttpSession session, List<CartItem> cart) {
        String productIdParam = request.getParameter("productId");
        if (productIdParam != null) {
            try {
                int productId = Integer.parseInt(productIdParam.trim());
                cart.removeIf(item -> item.getProduct().getProductId() == productId);
                session.setAttribute("flashSuccess", "Item removed from cart.");
            } catch (NumberFormatException ignored) {
            }
        }
    }
}
