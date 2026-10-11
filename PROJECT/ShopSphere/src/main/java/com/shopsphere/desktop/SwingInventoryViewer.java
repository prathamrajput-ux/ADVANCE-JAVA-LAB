package com.shopsphere.desktop;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableRowSorter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

/**
 * RTU Advanced Java / Java Enterprise Practical Demonstration:
 * Comprehensive Desktop Administration Suite for ShopSphere.
 * Demonstrates: JFrame, JTabbedPane, JTable, DefaultTableModel, TableRowSorter,
 * JDialog, JMenuBar, Event Listeners, and layered MVC / JDBC integration.
 */
public class SwingInventoryViewer extends JFrame implements ActionListener {

    private final ProductDAO productDAO;
    private final OrderDAO orderDAO;
    private final UserDAO userDAO;
    private final CategoryDAO categoryDAO;

    private JTabbedPane tabbedPane;

    // --- Dashboard Components ---
    private JLabel lblTotalSales, lblTotalOrders, lblTotalProducts, lblTotalUsers;
    private DefaultTableModel lowStockTableModel;
    private JTable lowStockTable;

    // --- Products Components ---
    private DefaultTableModel productTableModel;
    private JTable productTable;
    private TableRowSorter<DefaultTableModel> productSorter;
    private JTextField txtProductSearch;
    private JButton btnAddProduct, btnEditProduct, btnQuickRestock, btnDeleteProduct, btnRefreshProducts;

    // --- Orders Components ---
    private DefaultTableModel orderTableModel;
    private JTable orderTable;
    private JComboBox<String> cmbOrderStatus;
    private JButton btnUpdateOrderStatus, btnViewOrderItems, btnRefreshOrders;

    // --- Users Components ---
    private DefaultTableModel userTableModel;
    private JTable userTable;
    private JButton btnToggleUserStatus, btnRefreshUsers;

    // --- Categories Components ---
    private DefaultTableModel categoryTableModel;
    private JTable categoryTable;
    private JButton btnAddCategory, btnRefreshCategories;

    // --- Status Bar ---
    private JLabel lblStatusBar;

    public SwingInventoryViewer() {
        super("ShopSphere - Enterprise Desktop Administration Suite (RTU Swing Module)");
        this.productDAO = new ProductDAO();
        this.orderDAO = new OrderDAO();
        this.userDAO = new UserDAO();
        this.categoryDAO = new CategoryDAO();

        initializeUI();
        refreshAllData();
    }

    private void initializeUI() {
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(1100, 700);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        // Setup Menu Bar
        setupMenuBar();

        // Setup Tabbed Pane
        tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("SansSerif", Font.BOLD, 13));

        tabbedPane.addTab("📊 Dashboard & KPI", createDashboardPanel());
        tabbedPane.addTab("📦 Product Catalog", createProductsPanel());
        tabbedPane.addTab("🛒 Orders & Fulfillment", createOrdersPanel());
        tabbedPane.addTab("👥 Customer Directory", createUsersPanel());
        tabbedPane.addTab("🏷️ Categories", createCategoriesPanel());

        add(tabbedPane, BorderLayout.CENTER);

        // Setup Bottom Status Bar
        lblStatusBar = new JLabel(" Connected to MySQL [shopsphere] | Port 3306 | RTU Enterprise Capstone Project");
        lblStatusBar.setBorder(new EmptyBorder(6, 12, 6, 12));
        lblStatusBar.setFont(new Font("SansSerif", Font.PLAIN, 12));
        lblStatusBar.setOpaque(true);
        lblStatusBar.setBackground(new Color(238, 242, 246));
        add(lblStatusBar, BorderLayout.SOUTH);
    }

    private void setupMenuBar() {
        JMenuBar menuBar = new JMenuBar();

        JMenu menuFile = new JMenu("File");
        JMenuItem miRefresh = new JMenuItem("Refresh All Data");
        miRefresh.addActionListener(e -> refreshAllData());
        JMenuItem miExit = new JMenuItem("Exit");
        miExit.addActionListener(e -> dispose());
        menuFile.add(miRefresh);
        menuFile.addSeparator();
        menuFile.add(miExit);

        JMenu menuHelp = new JMenu("Help");
        JMenuItem miAbout = new JMenuItem("About ShopSphere");
        miAbout.addActionListener(e -> JOptionPane.showMessageDialog(this,
                "ShopSphere Desktop Admin Suite\n\n" +
                "Engineered for RTU Advanced Java Lab Curriculum.\n" +
                "Demonstrates Swing MVC, Event-Driven Programming, and JDBC Transactions.\n" +
                "© 2026 ShopSphere Project Team",
                "About", JOptionPane.INFORMATION_MESSAGE));
        menuHelp.add(miAbout);

        menuBar.add(menuFile);
        menuBar.add(menuHelp);
        setJMenuBar(menuBar);
    }

    // =========================================================================
    // 1. Dashboard Tab
    // =========================================================================
    private JPanel createDashboardPanel() {
        JPanel panel = new JPanel(new BorderLayout(15, 15));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        // Top KPI Cards Row
        JPanel kpiPanel = new JPanel(new GridLayout(1, 4, 15, 15));

        lblTotalSales = new JLabel("₹0.00", SwingConstants.CENTER);
        lblTotalOrders = new JLabel("0", SwingConstants.CENTER);
        lblTotalProducts = new JLabel("0", SwingConstants.CENTER);
        lblTotalUsers = new JLabel("0", SwingConstants.CENTER);

        kpiPanel.add(createCard("Total Revenue", lblTotalSales, new Color(40, 167, 69)));
        kpiPanel.add(createCard("Total Orders", lblTotalOrders, new Color(13, 110, 253)));
        kpiPanel.add(createCard("Catalog Products", lblTotalProducts, new Color(102, 16, 242)));
        kpiPanel.add(createCard("Registered Customers", lblTotalUsers, new Color(253, 126, 20)));

        panel.add(kpiPanel, BorderLayout.NORTH);

        // Center Low Stock Alert Table
        JPanel alertPanel = new JPanel(new BorderLayout(10, 10));
        alertPanel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(new Color(220, 53, 69)),
                "⚠️ Inventory Critical Alerts (Stock <= 5 Units)"));

        String[] cols = {"Product ID", "Product Name", "Category", "Price (₹)", "Current Stock"};
        lowStockTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int r, int c) { return false; }
        };
        lowStockTable = new JTable(lowStockTableModel);
        lowStockTable.setRowHeight(24);
        alertPanel.add(new JScrollPane(lowStockTable), BorderLayout.CENTER);

        // Low stock quick actions
        JPanel alertActionPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        JButton btnRestockSelected = new JButton("⚡ Restock Selected Item (+10 Units)");
        btnRestockSelected.setBackground(new Color(25, 135, 84));
        btnRestockSelected.setForeground(Color.WHITE);
        btnRestockSelected.addActionListener(e -> restockFromAlertTable());
        alertActionPanel.add(btnRestockSelected);

        alertPanel.add(alertActionPanel, BorderLayout.SOUTH);
        panel.add(alertPanel, BorderLayout.CENTER);

        return panel;
    }

    private JPanel createCard(String title, JLabel valueLabel, Color accentColor) {
        JPanel card = new JPanel(new BorderLayout(5, 5));
        card.setBackground(Color.WHITE);
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createMatteBorder(0, 4, 0, 0, accentColor),
                BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(new Color(230, 230, 230)),
                        new EmptyBorder(12, 12, 12, 12))));

        JLabel lblTitle = new JLabel(title);
        lblTitle.setFont(new Font("SansSerif", Font.BOLD, 12));
        lblTitle.setForeground(Color.GRAY);

        valueLabel.setFont(new Font("SansSerif", Font.BOLD, 22));
        valueLabel.setForeground(accentColor);

        card.add(lblTitle, BorderLayout.NORTH);
        card.add(valueLabel, BorderLayout.CENTER);
        return card;
    }

    // =========================================================================
    // 2. Product Catalog Tab
    // =========================================================================
    private JPanel createProductsPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        // Top Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        toolbar.add(new JLabel("Search Catalog:"));
        txtProductSearch = new JTextField(15);
        txtProductSearch.addKeyListener(new java.awt.event.KeyAdapter() {
            @Override
            public void keyReleased(java.awt.event.KeyEvent e) {
                String query = txtProductSearch.getText().trim();
                productSorter.setRowFilter(query.isEmpty() ? null : RowFilter.regexFilter("(?i)" + query));
            }
        });
        toolbar.add(txtProductSearch);

        btnAddProduct = new JButton("➕ Add New Product");
        btnAddProduct.addActionListener(this);
        toolbar.add(btnAddProduct);

        btnEditProduct = new JButton("✏️ Edit Selected");
        btnEditProduct.addActionListener(this);
        toolbar.add(btnEditProduct);

        btnQuickRestock = new JButton("⚡ +10 Stock");
        btnQuickRestock.addActionListener(this);
        toolbar.add(btnQuickRestock);

        btnDeleteProduct = new JButton("❌ Deactivate");
        btnDeleteProduct.addActionListener(this);
        toolbar.add(btnDeleteProduct);

        btnRefreshProducts = new JButton("🔄 Refresh");
        btnRefreshProducts.addActionListener(this);
        toolbar.add(btnRefreshProducts);

        panel.add(toolbar, BorderLayout.NORTH);

        // Product Table
        String[] cols = {"ID", "Name", "Category", "Brand", "Price (₹)", "Discount %", "Stock", "Status"};
        productTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int r, int c) { return false; }
        };
        productTable = new JTable(productTableModel);
        productTable.setRowHeight(25);
        productSorter = new TableRowSorter<>(productTableModel);
        productTable.setRowSorter(productSorter);

        panel.add(new JScrollPane(productTable), BorderLayout.CENTER);
        return panel;
    }

    // =========================================================================
    // 3. Orders & Fulfillment Tab
    // =========================================================================
    private JPanel createOrdersPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        // Order Action Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        toolbar.add(new JLabel("Change Status to:"));

        cmbOrderStatus = new JComboBox<>(new String[]{"Processing", "Shipped", "Delivered", "Cancelled"});
        toolbar.add(cmbOrderStatus);

        btnUpdateOrderStatus = new JButton("Update Status");
        btnUpdateOrderStatus.addActionListener(this);
        toolbar.add(btnUpdateOrderStatus);

        btnViewOrderItems = new JButton("👁️ View Order Line Items");
        btnViewOrderItems.addActionListener(this);
        toolbar.add(btnViewOrderItems);

        btnRefreshOrders = new JButton("🔄 Refresh Orders");
        btnRefreshOrders.addActionListener(this);
        toolbar.add(btnRefreshOrders);

        panel.add(toolbar, BorderLayout.NORTH);

        // Orders Table
        String[] cols = {"Order ID", "Customer Name", "Customer Email", "Total Amount (₹)", "Payment Method", "Status", "Date"};
        orderTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int r, int c) { return false; }
        };
        orderTable = new JTable(orderTableModel);
        orderTable.setRowHeight(25);

        panel.add(new JScrollPane(orderTable), BorderLayout.CENTER);
        return panel;
    }

    // =========================================================================
    // 4. Customer Directory Tab
    // =========================================================================
    private JPanel createUsersPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        btnToggleUserStatus = new JButton("Toggle Account Status (Active/Suspended)");
        btnToggleUserStatus.addActionListener(this);
        toolbar.add(btnToggleUserStatus);

        btnRefreshUsers = new JButton("🔄 Refresh Customers");
        btnRefreshUsers.addActionListener(this);
        toolbar.add(btnRefreshUsers);

        panel.add(toolbar, BorderLayout.NORTH);

        String[] cols = {"User ID", "Full Name", "Email", "Mobile", "Role", "Orders Placed", "Total Spent (₹)", "Status"};
        userTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int r, int c) { return false; }
        };
        userTable = new JTable(userTableModel);
        userTable.setRowHeight(25);

        panel.add(new JScrollPane(userTable), BorderLayout.CENTER);
        return panel;
    }

    // =========================================================================
    // 5. Categories Management Tab
    // =========================================================================
    private JPanel createCategoriesPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(15, 15, 15, 15));

        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        btnAddCategory = new JButton("➕ Add New Category");
        btnAddCategory.addActionListener(this);
        toolbar.add(btnAddCategory);

        btnRefreshCategories = new JButton("🔄 Refresh Categories");
        btnRefreshCategories.addActionListener(this);
        toolbar.add(btnRefreshCategories);

        panel.add(toolbar, BorderLayout.NORTH);

        String[] cols = {"Category ID", "Category Name", "Description", "Status"};
        categoryTableModel = new DefaultTableModel(cols, 0) {
            @Override
            public boolean isCellEditable(int r, int c) { return false; }
        };
        categoryTable = new JTable(categoryTableModel);
        categoryTable.setRowHeight(25);

        panel.add(new JScrollPane(categoryTable), BorderLayout.CENTER);
        return panel;
    }

    // =========================================================================
    // Data Loading & Refresh
    // =========================================================================
    private void refreshAllData() {
        loadDashboardData();
        loadProductData();
        loadOrderData();
        loadUserData();
        loadCategoryData();
        lblStatusBar.setText(" Connected to MySQL [shopsphere] | All Data Refreshed Successfully.");
    }

    private void loadDashboardData() {
        lblTotalSales.setText(String.format("₹%.2f", orderDAO.getTotalSales()));
        lblTotalOrders.setText(String.valueOf(orderDAO.getTotalOrderCount()));
        lblTotalProducts.setText(String.valueOf(productDAO.getTotalProductCount()));
        lblTotalUsers.setText(String.valueOf(userDAO.getTotalUserCount()));

        lowStockTableModel.setRowCount(0);
        List<Product> lowStock = productDAO.getLowStockProducts(5);
        for (Product p : lowStock) {
            lowStockTableModel.addRow(new Object[]{
                    p.getProductId(),
                    p.getName(),
                    p.getCategoryName(),
                    String.format("%.2f", p.getPrice()),
                    p.getStock()
            });
        }
    }

    private void loadProductData() {
        productTableModel.setRowCount(0);
        List<Product> products = productDAO.getAllProducts();
        for (Product p : products) {
            productTableModel.addRow(new Object[]{
                    p.getProductId(),
                    p.getName(),
                    p.getCategoryName(),
                    p.getBrand(),
                    String.format("%.2f", p.getPrice()),
                    String.format("%.1f", p.getDiscount()),
                    p.getStock(),
                    p.getStatus()
            });
        }
    }

    private void loadOrderData() {
        orderTableModel.setRowCount(0);
        List<Order> orders = orderDAO.getAllOrders();
        for (Order o : orders) {
            orderTableModel.addRow(new Object[]{
                    o.getOrderId(),
                    o.getUserName(),
                    o.getUserEmail(),
                    String.format("%.2f", o.getTotalAmount()),
                    o.getPaymentMethod(),
                    o.getOrderStatus(),
                    o.getCreatedAt() != null ? o.getCreatedAt().toString() : ""
            });
        }
    }

    private void loadUserData() {
        userTableModel.setRowCount(0);
        List<User> users = userDAO.getAllUsers();
        for (User u : users) {
            userTableModel.addRow(new Object[]{
                    u.getUserId(),
                    u.getName(),
                    u.getEmail(),
                    u.getMobile(),
                    u.getRole(),
                    u.getOrderCount(),
                    String.format("%.2f", u.getTotalSpent()),
                    u.getStatus()
            });
        }
    }

    private void loadCategoryData() {
        categoryTableModel.setRowCount(0);
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category c : categories) {
            categoryTableModel.addRow(new Object[]{
                    c.getCategoryId(),
                    c.getName(),
                    c.getDescription(),
                    c.getStatus()
            });
        }
    }

    // =========================================================================
    // Action Event Router
    // =========================================================================
    @Override
    public void actionPerformed(ActionEvent e) {
        Object src = e.getSource();

        if (src == btnAddProduct) {
            showAddProductDialog();
        } else if (src == btnEditProduct) {
            showEditProductDialog();
        } else if (src == btnQuickRestock) {
            quickRestockSelectedProduct();
        } else if (src == btnDeleteProduct) {
            deleteSelectedProduct();
        } else if (src == btnRefreshProducts) {
            loadProductData();
        } else if (src == btnUpdateOrderStatus) {
            updateSelectedOrderStatus();
        } else if (src == btnViewOrderItems) {
            showOrderItemsDialog();
        } else if (src == btnRefreshOrders) {
            loadOrderData();
        } else if (src == btnToggleUserStatus) {
            toggleSelectedUserStatus();
        } else if (src == btnRefreshUsers) {
            loadUserData();
        } else if (src == btnAddCategory) {
            showAddCategoryDialog();
        } else if (src == btnRefreshCategories) {
            loadCategoryData();
        }
    }

    // --- Action Implementations ---
    private void restockFromAlertTable() {
        int sel = lowStockTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Please select an item in the alert table.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }
        int productId = (int) lowStockTableModel.getValueAt(sel, 0);
        Product p = productDAO.getProductById(productId);
        if (p != null) {
            p.setStock(p.getStock() + 10);
            productDAO.updateProduct(p);
            JOptionPane.showMessageDialog(this, "Restocked \"" + p.getName() + "\" by 10 units!", "Success", JOptionPane.INFORMATION_MESSAGE);
            refreshAllData();
        }
    }

    private void quickRestockSelectedProduct() {
        int sel = productTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Select a product to restock.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }
        int modelRow = productTable.convertRowIndexToModel(sel);
        int productId = (int) productTableModel.getValueAt(modelRow, 0);
        Product p = productDAO.getProductById(productId);
        if (p != null) {
            p.setStock(p.getStock() + 10);
            productDAO.updateProduct(p);
            JOptionPane.showMessageDialog(this, "Added 10 units to \"" + p.getName() + "\". New stock: " + p.getStock());
            refreshAllData();
        }
    }

    private void deleteSelectedProduct() {
        int sel = productTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Select a product to deactivate.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }
        int modelRow = productTable.convertRowIndexToModel(sel);
        int productId = (int) productTableModel.getValueAt(modelRow, 0);
        String name = (String) productTableModel.getValueAt(modelRow, 1);

        int confirm = JOptionPane.showConfirmDialog(this,
                "Are you sure you want to deactivate \"" + name + "\"?",
                "Confirm Deactivation", JOptionPane.YES_NO_OPTION);

        if (confirm == JOptionPane.YES_OPTION) {
            productDAO.deleteProduct(productId);
            refreshAllData();
        }
    }

    private void showAddProductDialog() {
        List<Category> categories = categoryDAO.getAllCategories();
        if (categories.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Please create at least one category first.");
            return;
        }

        JTextField txtName = new JTextField();
        JComboBox<CategoryItem> cmbCat = new JComboBox<>();
        for (Category c : categories) {
            cmbCat.addItem(new CategoryItem(c.getCategoryId(), c.getName()));
        }
        JTextField txtBrand = new JTextField();
        JTextField txtPrice = new JTextField();
        JTextField txtDiscount = new JTextField("0");
        JTextField txtStock = new JTextField("20");
        JTextField txtImage = new JTextField("https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500");
        JTextArea txtDesc = new JTextArea(3, 20);

        JPanel panel = new JPanel(new GridLayout(8, 2, 8, 8));
        panel.add(new JLabel("Product Name:")); panel.add(txtName);
        panel.add(new JLabel("Category:")); panel.add(cmbCat);
        panel.add(new JLabel("Brand:")); panel.add(txtBrand);
        panel.add(new JLabel("Price (₹):")); panel.add(txtPrice);
        panel.add(new JLabel("Discount (%):")); panel.add(txtDiscount);
        panel.add(new JLabel("Stock Quantity:")); panel.add(txtStock);
        panel.add(new JLabel("Image URL:")); panel.add(txtImage);
        panel.add(new JLabel("Description:")); panel.add(new JScrollPane(txtDesc));

        int res = JOptionPane.showConfirmDialog(this, panel, "Add New Catalog Product", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (res == JOptionPane.OK_OPTION) {
            try {
                Product p = new Product();
                p.setName(txtName.getText().trim());
                p.setCategoryId(((CategoryItem) cmbCat.getSelectedItem()).id);
                p.setBrand(txtBrand.getText().trim());
                p.setPrice(Double.parseDouble(txtPrice.getText().trim()));
                p.setDiscount(Double.parseDouble(txtDiscount.getText().trim()));
                p.setStock(Integer.parseInt(txtStock.getText().trim()));
                p.setImageUrl(txtImage.getText().trim());
                p.setDescription(txtDesc.getText().trim());
                p.setStatus("ACTIVE");

                productDAO.addProduct(p);
                JOptionPane.showMessageDialog(this, "Product added successfully!");
                refreshAllData();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Invalid form data: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void showEditProductDialog() {
        int sel = productTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Please select a product row to edit.");
            return;
        }
        int modelRow = productTable.convertRowIndexToModel(sel);
        int productId = (int) productTableModel.getValueAt(modelRow, 0);
        Product p = productDAO.getProductById(productId);
        if (p == null) return;

        JTextField txtName = new JTextField(p.getName());
        JTextField txtPrice = new JTextField(String.valueOf(p.getPrice()));
        JTextField txtDiscount = new JTextField(String.valueOf(p.getDiscount()));
        JTextField txtStock = new JTextField(String.valueOf(p.getStock()));
        JTextField txtBrand = new JTextField(p.getBrand());

        JPanel panel = new JPanel(new GridLayout(5, 2, 8, 8));
        panel.add(new JLabel("Name:")); panel.add(txtName);
        panel.add(new JLabel("Brand:")); panel.add(txtBrand);
        panel.add(new JLabel("Price (₹):")); panel.add(txtPrice);
        panel.add(new JLabel("Discount (%):")); panel.add(txtDiscount);
        panel.add(new JLabel("Stock:")); panel.add(txtStock);

        int res = JOptionPane.showConfirmDialog(this, panel, "Edit Product #" + productId, JOptionPane.OK_CANCEL_OPTION);
        if (res == JOptionPane.OK_OPTION) {
            try {
                p.setName(txtName.getText().trim());
                p.setBrand(txtBrand.getText().trim());
                p.setPrice(Double.parseDouble(txtPrice.getText().trim()));
                p.setDiscount(Double.parseDouble(txtDiscount.getText().trim()));
                p.setStock(Integer.parseInt(txtStock.getText().trim()));

                productDAO.updateProduct(p);
                JOptionPane.showMessageDialog(this, "Product updated!");
                refreshAllData();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
            }
        }
    }

    private void updateSelectedOrderStatus() {
        int sel = orderTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Select an order to update.");
            return;
        }
        int orderId = (int) orderTableModel.getValueAt(sel, 0);
        String newStatus = (String) cmbOrderStatus.getSelectedItem();

        boolean ok = orderDAO.updateOrderStatus(orderId, newStatus);
        if (ok) {
            JOptionPane.showMessageDialog(this, "Order #" + orderId + " updated to " + newStatus + ".");
            refreshAllData();
        } else {
            JOptionPane.showMessageDialog(this, "Failed to update order.");
        }
    }

    private void showOrderItemsDialog() {
        int sel = orderTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Select an order to view items.");
            return;
        }
        int orderId = (int) orderTableModel.getValueAt(sel, 0);
        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getItems().isEmpty()) {
            JOptionPane.showMessageDialog(this, "No line items found for this order.");
            return;
        }

        String[] cols = {"Product Name", "Quantity", "Unit Price (₹)", "Subtotal (₹)"};
        DefaultTableModel tm = new DefaultTableModel(cols, 0);
        for (OrderItem item : order.getItems()) {
            tm.addRow(new Object[]{
                    item.getProductName(),
                    item.getQuantity(),
                    String.format("%.2f", item.getPrice()),
                    String.format("%.2f", item.getSubTotal())
            });
        }
        JTable table = new JTable(tm);
        table.setRowHeight(22);

        JDialog dialog = new JDialog(this, "Order #" + orderId + " Line Items", true);
        dialog.setSize(600, 300);
        dialog.setLocationRelativeTo(this);
        dialog.add(new JScrollPane(table));
        dialog.setVisible(true);
    }

    private void toggleSelectedUserStatus() {
        int sel = userTable.getSelectedRow();
        if (sel == -1) {
            JOptionPane.showMessageDialog(this, "Select a customer row.");
            return;
        }
        int userId = (int) userTableModel.getValueAt(sel, 0);
        String currentStatus = (String) userTableModel.getValueAt(sel, 7);
        String newStatus = "ACTIVE".equalsIgnoreCase(currentStatus) ? "INACTIVE" : "ACTIVE";

        userDAO.updateUserStatus(userId, newStatus);
        JOptionPane.showMessageDialog(this, "User #" + userId + " status updated to " + newStatus + ".");
        refreshAllData();
    }

    private void showAddCategoryDialog() {
        JTextField txtCatName = new JTextField();
        JTextField txtCatDesc = new JTextField();

        JPanel p = new JPanel(new GridLayout(2, 2, 6, 6));
        p.add(new JLabel("Category Name:")); p.add(txtCatName);
        p.add(new JLabel("Description:")); p.add(txtCatDesc);

        int res = JOptionPane.showConfirmDialog(this, p, "Create Category", JOptionPane.OK_CANCEL_OPTION);
        if (res == JOptionPane.OK_OPTION) {
            String name = txtCatName.getText().trim();
            if (!name.isEmpty()) {
                categoryDAO.addCategory(new Category(name, txtCatDesc.getText().trim()));
                JOptionPane.showMessageDialog(this, "Category created!");
                refreshAllData();
            }
        }
    }

    // Helper class for category combo box
    private static class CategoryItem {
        int id;
        String name;
        CategoryItem(int id, String name) { this.id = id; this.name = name; }
        @Override
        public String toString() { return name; }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignored) {
            }
            new SwingInventoryViewer().setVisible(true);
        });
    }
}
