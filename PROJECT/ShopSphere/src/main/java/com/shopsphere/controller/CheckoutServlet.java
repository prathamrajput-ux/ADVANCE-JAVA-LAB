package com.shopsphere.controller;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
            session.setAttribute("flashError", "Please sign in to complete your checkout.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            session.setAttribute("flashError", "Your shopping cart is empty.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double totalAmount = calculateCartTotal(cart);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String addressLine = request.getParameter("addressLine");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String paymentMethod = request.getParameter("paymentMethod");

        if (addressLine == null || addressLine.trim().isEmpty() ||
            city == null || city.trim().isEmpty() ||
            state == null || state.trim().isEmpty() ||
            pincode == null || pincode.trim().isEmpty()) {
            request.setAttribute("error", "Please provide complete shipping address details.");
            request.setAttribute("totalAmount", calculateCartTotal(cart));
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        String fullAddress = addressLine.trim() + ", " + city.trim() + ", " + state.trim() + " - " + pincode.trim();
        double serverCalculatedTotal = calculateCartTotal(cart);

        Order newOrder = new Order();
        newOrder.setUserId(user.getUserId());
        newOrder.setShippingAddress(fullAddress);
        newOrder.setTotalAmount(serverCalculatedTotal);
        newOrder.setDiscount(0.0);
        newOrder.setPaymentMethod(paymentMethod != null ? paymentMethod : "Cash On Delivery");
        newOrder.setPaymentStatus("Completed");
        newOrder.setOrderStatus("Processing");

        boolean placed = orderDAO.placeOrder(newOrder, cart);

        if (placed) {
            // Clear cart from session upon successful purchase
            cart.clear();
            session.setAttribute("cart", cart);
            session.setAttribute("latestOrder", newOrder);
            response.sendRedirect(request.getContextPath() + "/order-success.jsp?orderId=" + newOrder.getOrderId());
        } else {
            request.setAttribute("error", "Failed to place order. A selected item may have insufficient stock.");
            request.setAttribute("totalAmount", serverCalculatedTotal);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }

    private double calculateCartTotal(List<CartItem> cart) {
        double sum = 0.0;
        if (cart != null) {
            for (CartItem item : cart) {
                sum += item.getTotalPrice();
            }
        }
        return sum;
    }
}
