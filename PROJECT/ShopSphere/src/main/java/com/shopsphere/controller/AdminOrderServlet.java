package com.shopsphere.controller;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String orderIdParam = request.getParameter("orderId");
        String status = request.getParameter("status");

        if (orderIdParam != null && status != null) {
            try {
                int orderId = Integer.parseInt(orderIdParam.trim());
                boolean updated = orderDAO.updateOrderStatus(orderId, status.trim());
                if (updated) {
                    session.setAttribute("flashSuccess", "Order #" + orderId + " status updated to " + status + ".");
                } else {
                    session.setAttribute("flashError", "Failed to update order status.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("flashError", "Invalid order ID.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
