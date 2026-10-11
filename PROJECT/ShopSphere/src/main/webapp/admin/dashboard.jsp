<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="ShopSphere - Admin Dashboard" />
<%@ include file="../fragments/header.jsp" %>
<%@ include file="../fragments/navbar.jsp" %>

<div class="container my-4">
    <!-- Admin Navigation Tabs -->
    <div class="card border-0 shadow-sm p-3 mb-4 rounded-3 bg-white">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
            <h4 class="fw-bold mb-0 text-primary d-flex align-items-center gap-2">
                <i class="bi bi-speedometer2"></i> Admin Portal
            </h4>
            <ul class="nav nav-pills">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-grid-1x2-fill me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">
                        <i class="bi bi-boxes me-1"></i>Manage Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                        <i class="bi bi-clipboard-check me-1"></i>Manage Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                        <i class="bi bi-people-fill me-1"></i>Customers
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-3 col-sm-6">
            <div class="card border-0 shadow-sm p-4 h-100 rounded-3 border-start border-4 border-success">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small text-uppercase fw-bold">Total Revenue</span>
                        <h3 class="fw-bold mb-0 text-success mt-1">
                            ₹<fmt:formatNumber value="${totalSales}" pattern="#,##0.00" />
                        </h3>
                    </div>
                    <div class="bg-success-subtle text-success p-3 rounded-circle">
                        <i class="bi bi-currency-rupee fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card border-0 shadow-sm p-4 h-100 rounded-3 border-start border-4 border-primary">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small text-uppercase fw-bold">Total Orders</span>
                        <h3 class="fw-bold mb-0 text-primary mt-1">${totalOrders}</h3>
                    </div>
                    <div class="bg-primary-subtle text-primary p-3 rounded-circle">
                        <i class="bi bi-bag-check-fill fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card border-0 shadow-sm p-4 h-100 rounded-3 border-start border-4 border-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small text-uppercase fw-bold">Active Products</span>
                        <h3 class="fw-bold mb-0 text-dark mt-1">${totalProducts}</h3>
                    </div>
                    <div class="bg-info-subtle text-info p-3 rounded-circle">
                        <i class="bi bi-box-seam-fill fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card border-0 shadow-sm p-4 h-100 rounded-3 border-start border-4 border-warning">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small text-uppercase fw-bold">Customers</span>
                        <h3 class="fw-bold mb-0 text-dark mt-1">${totalUsers}</h3>
                    </div>
                    <div class="bg-warning-subtle text-warning p-3 rounded-circle">
                        <i class="bi bi-people-fill fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions Bar -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-primary w-100 py-3 d-flex align-items-center justify-content-center gap-2 rounded-3 shadow-sm bg-white text-decoration-none">
                <i class="bi bi-plus-circle-fill fs-5"></i>
                <span class="fw-semibold">Add / Manage Products</span>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-success w-100 py-3 d-flex align-items-center justify-content-center gap-2 rounded-3 shadow-sm bg-white text-decoration-none">
                <i class="bi bi-box-seam-fill fs-5"></i>
                <span class="fw-semibold">Process Customer Orders</span>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-dark w-100 py-3 d-flex align-items-center justify-content-center gap-2 rounded-3 shadow-sm bg-white text-decoration-none">
                <i class="bi bi-people-fill fs-5"></i>
                <span class="fw-semibold">Customer Directory & History</span>
            </a>
        </div>
    </div>

    <!-- Low Stock Inventory Alerts -->
    <div class="card border-0 shadow-sm rounded-3 mb-4">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="fw-bold mb-0 text-danger d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill"></i> Low Stock Alerts (&le; 5 units)
            </h5>
            <span class="badge bg-danger">${lowStockProducts.size()} Items Alerted</span>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty lowStockProducts}">
                    <div class="p-4 text-center text-muted">
                        <i class="bi bi-check-circle text-success fs-3 d-block mb-2"></i>
                        All active products currently maintain sufficient stock levels.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Remaining Stock</th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${lowStockProducts}">
                                    <tr>
                                        <td>#${item.productId}</td>
                                        <td class="fw-semibold">${item.name}</td>
                                        <td><span class="badge bg-light text-secondary border">${item.categoryName}</span></td>
                                        <td>₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00" /></td>
                                        <td>
                                            <span class="badge bg-danger-subtle text-danger fs-6 fw-bold">
                                                ${item.stock} left
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/admin/products" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="quickStock">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <input type="hidden" name="amount" value="10">
                                                <button type="submit" class="btn btn-outline-success btn-sm fw-semibold">
                                                    <i class="bi bi-plus-circle me-1"></i>+10 Units
                                                </button>
                                            </form>
                                            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-light btn-sm ms-1">
                                                Edit
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>
