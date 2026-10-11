<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="ShopSphere - Home" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-4">
    <!-- Hero Banner -->
    <div class="hero-banner p-5 text-center text-lg-start shadow-sm mb-5">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-light text-primary mb-2 px-3 py-2 fw-semibold">RTU Java Enterprise Project</span>
                <h1 class="display-4 fw-bold mb-3">Welcome to ShopSphere</h1>
                <p class="lead mb-4 text-white-50">
                    A complete, modern e-commerce web application engineered with Jakarta Servlets, JSP, JSTL, and MySQL Database.
                </p>
                <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-warning btn-lg fw-bold text-dark px-4 shadow-sm">
                        <i class="bi bi-cart-plus me-2"></i>Start Shopping
                    </a>
                    <c:if test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-light btn-lg px-4">
                            <i class="bi bi-person-plus me-2"></i>Create Account
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="col-lg-4 text-center d-none d-lg-block">
                <i class="bi bi-shop display-1 text-white opacity-75"></i>
            </div>
        </div>
    </div>

    <!-- Features Row -->
    <div class="row g-4 mb-5 text-center">
        <div class="col-md-3 col-6">
            <div class="card h-100 border-0 shadow-sm p-3">
                <div class="fs-1 text-primary mb-2"><i class="bi bi-shield-check"></i></div>
                <h6 class="fw-bold mb-1">Secure Ordering</h6>
                <p class="text-muted small mb-0">ACID Transactions with MySQL & JDBC</p>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="card h-100 border-0 shadow-sm p-3">
                <div class="fs-1 text-success mb-2"><i class="bi bi-truck"></i></div>
                <h6 class="fw-bold mb-1">Fast Delivery</h6>
                <p class="text-muted small mb-0">Real-time status updates</p>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="card h-100 border-0 shadow-sm p-3">
                <div class="fs-1 text-warning mb-2"><i class="bi bi-person-lock"></i></div>
                <h6 class="fw-bold mb-1">Role Security</h6>
                <p class="text-muted small mb-0">Admin & Customer Web Filters</p>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="card h-100 border-0 shadow-sm p-3">
                <div class="fs-1 text-danger mb-2"><i class="bi bi-boxes"></i></div>
                <h6 class="fw-bold mb-1">Live Inventory</h6>
                <p class="text-muted small mb-0">Automatic stock tracking</p>
            </div>
        </div>
    </div>

    <!-- Shop by Category Section -->
    <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0">Browse by Category</h3>
            <a href="${pageContext.request.contextPath}/products" class="text-decoration-none fw-semibold">View All &rarr;</a>
        </div>
        <div class="row g-3">
            <div class="col-md-3 col-sm-6">
                <a href="${pageContext.request.contextPath}/products?categoryId=1" class="text-decoration-none text-dark">
                    <div class="card border-0 shadow-sm p-4 text-center product-card bg-white">
                        <i class="bi bi-laptop display-4 text-primary mb-3"></i>
                        <h5 class="fw-bold mb-1">Electronics</h5>
                        <p class="text-muted small mb-0">Headphones, Watches, Keyboards</p>
                    </div>
                </a>
            </div>
            <div class="col-md-3 col-sm-6">
                <a href="${pageContext.request.contextPath}/products?categoryId=2" class="text-decoration-none text-dark">
                    <div class="card border-0 shadow-sm p-4 text-center product-card bg-white">
                        <i class="bi bi-bag-heart display-4 text-danger mb-3"></i>
                        <h5 class="fw-bold mb-1">Fashion</h5>
                        <p class="text-muted small mb-0">Apparel, Jackets & Footwear</p>
                    </div>
                </a>
            </div>
            <div class="col-md-3 col-sm-6">
                <a href="${pageContext.request.contextPath}/products?categoryId=3" class="text-decoration-none text-dark">
                    <div class="card border-0 shadow-sm p-4 text-center product-card bg-white">
                        <i class="bi bi-cup-hot display-4 text-warning mb-3"></i>
                        <h5 class="fw-bold mb-1">Home & Living</h5>
                        <p class="text-muted small mb-0">Bottles, Kitchen & Essentials</p>
                    </div>
                </a>
            </div>
            <div class="col-md-3 col-sm-6">
                <a href="${pageContext.request.contextPath}/products?categoryId=4" class="text-decoration-none text-dark">
                    <div class="card border-0 shadow-sm p-4 text-center product-card bg-white">
                        <i class="bi bi-book display-4 text-success mb-3"></i>
                        <h5 class="fw-bold mb-1">Books</h5>
                        <p class="text-muted small mb-0">Technical Guides & Textbooks</p>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <!-- Syllabus Architecture Callout -->
    <div class="card bg-white border-0 shadow-sm p-4 mb-4">
        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-diagram-3-fill text-primary me-2"></i>RTU Advanced Java Architecture Mapping</h5>
        <div class="row g-3 text-center">
            <div class="col-md-3">
                <div class="p-2 border rounded bg-light">
                    <span class="badge bg-primary mb-1">Presentation</span>
                    <p class="small mb-0 text-muted">JSP, JSTL, EL, Bootstrap 5</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-2 border rounded bg-light">
                    <span class="badge bg-success mb-1">Controller</span>
                    <p class="small mb-0 text-muted">Jakarta Servlets, Filters, Sessions</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-2 border rounded bg-light">
                    <span class="badge bg-warning text-dark mb-1">Business & DAO</span>
                    <p class="small mb-0 text-muted">JDBC, PreparedStatements, Models</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-2 border rounded bg-light">
                    <span class="badge bg-danger mb-1">Database</span>
                    <p class="small mb-0 text-muted">MySQL 8.x / InnoDB Engine</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
