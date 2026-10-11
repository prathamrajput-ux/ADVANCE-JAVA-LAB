package com.shopsphere.controller;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userDAO.getAllUsers();
        Map<Integer, List<Order>> userOrdersMap = new HashMap<>();

        for (User u : users) {
            List<Order> orders = orderDAO.getOrdersByUserId(u.getUserId());
            userOrdersMap.put(u.getUserId(), orders);
        }

        request.setAttribute("users", users);
        request.setAttribute("userOrdersMap", userOrdersMap);

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("toggleStatus".equalsIgnoreCase(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String newStatus = request.getParameter("status");
                boolean updated = userDAO.updateUserStatus(userId, newStatus);
                if (updated) {
                    session.setAttribute("flashSuccess", "Customer account status updated to " + newStatus + ".");
                } else {
                    session.setAttribute("flashError", "Failed to update account status.");
                }
            } catch (Exception e) {
                session.setAttribute("flashError", "Invalid user ID.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
