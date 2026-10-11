package com.shopsphere.dao;

import com.shopsphere.model.CartItem;
import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;
import com.shopsphere.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Places a customer order atomically using JDBC Transactions (commit & rollback).
     * Automatically inserts the order, records each order line item, and updates product stock.
     */
    public boolean placeOrder(Order order, List<CartItem> cartItems) {
        if (cartItems == null || cartItems.isEmpty()) {
            return false;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Begin Transaction

            // 1. Insert Order
            String orderSql = "INSERT INTO orders (user_id, shipping_address, total_amount, discount, " +
                              "payment_method, payment_status, order_status) VALUES (?, ?, ?, ?, ?, ?, ?)";

            int generatedOrderId = 0;
            try (PreparedStatement psOrder = con.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setString(2, order.getShippingAddress());
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setDouble(4, order.getDiscount());
                psOrder.setString(5, (order.getPaymentMethod() != null) ? order.getPaymentMethod() : "Cash On Delivery");
                psOrder.setString(6, (order.getPaymentStatus() != null) ? order.getPaymentStatus() : "Completed");
                psOrder.setString(7, (order.getOrderStatus() != null) ? order.getOrderStatus() : "Processing");

                int rows = psOrder.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false;
                }

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                        order.setOrderId(generatedOrderId);
                    } else {
                        con.rollback();
                        return false;
                    }
                }
            }

            // 2. Insert Order Items & decrement product stock
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            String stockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

            try (PreparedStatement psItem = con.prepareStatement(itemSql);
                 PreparedStatement psStock = con.prepareStatement(stockSql)) {

                for (CartItem item : cartItems) {
                    // Line item
                    psItem.setInt(1, generatedOrderId);
                    psItem.setInt(2, item.getProduct().getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getProduct().getEffectivePrice());
                    psItem.addBatch();

                    // Stock decrement
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProduct().getProductId());
                    psStock.setInt(3, item.getQuantity());
                    psStock.addBatch();
                }

                psItem.executeBatch();
                psStock.executeBatch();
            }

            // 3. Commit Transaction
            con.commit();
            return true;

        } catch (SQLException e) {
            System.err.println("Transaction rolled back due to error: " + e.getMessage());
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Rollback error: " + rollbackEx.getMessage());
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeEx) {
                    System.err.println("Connection close error: " + closeEx.getMessage());
                }
            }
        }
    }

    /**
     * Retrieves all orders for a specific customer, including items ordered.
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(con, order.getOrderId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching customer orders: " + e.getMessage());
        }
        return orders;
    }

    /**
     * Retrieves an order by ID along with its line items.
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.name AS user_name, u.email AS user_email " +
                     "FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.user_id " +
                     "WHERE o.order_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setUserName(rs.getString("user_name"));
                    order.setUserEmail(rs.getString("user_email"));
                    order.setItems(getOrderItems(con, order.getOrderId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order by ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all orders across all users (for Admin Order Management).
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS user_name, u.email AS user_email " +
                     "FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.user_id " +
                     "ORDER BY o.order_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setUserName(rs.getString("user_name"));
                order.setUserEmail(rs.getString("user_email"));
                order.setItems(getOrderItems(con, order.getOrderId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all orders: " + e.getMessage());
        }
        return orders;
    }

    /**
     * Updates an order status (e.g. Processing -> Shipped -> Delivered).
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Returns total order count for dashboard metrics.
     */
    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting orders: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Returns total sales revenue sum for dashboard metrics.
     */
    public double getTotalSales() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0.0) FROM orders";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("Error calculating total revenue: " + e.getMessage());
        }
        return 0.0;
    }

    private List<OrderItem> getOrderItems(Connection con, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name " +
                     "FROM order_items oi " +
                     "LEFT JOIN products p ON oi.product_id = p.product_id " +
                     "WHERE oi.order_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setDiscount(rs.getDouble("discount"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}
