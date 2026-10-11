<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top shadow-sm py-2">
    <div class="container">
        <!-- Brand -->
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2 fs-4" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-bag-heart-fill text-primary"></i>
            <span style="letter-spacing: -0.5px;">Nova<span class="text-primary">Mart</span></span>
        </a>

        <!-- Toggle Button for Mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Nav links -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">
                        <i class="bi bi-house me-1"></i>Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-grid me-1"></i>All Products
                    </a>
                </li>
            </ul>

            <!-- Search Form -->
            <form class="d-flex me-lg-3 my-2 my-lg-0" action="${pageContext.request.contextPath}/products" method="GET">
                <div class="input-group">
                    <input class="form-control form-control-sm" type="search" name="search"
                           placeholder="Search products..." value="${param.search}">
                    <button class="btn btn-outline-light btn-sm" type="submit">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>

            <!-- Right-side actions -->
            <ul class="navbar-nav align-items-lg-center">
                <!-- Shopping Cart -->
                <li class="nav-item me-2">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="bi bi-cart3 fs-5"></i>
                        <c:set var="cartCount" value="0" />
                        <c:if test="${not empty sessionScope.cart}">
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <c:set var="cartCount" value="${cartCount + item.quantity}" />
                            </c:forEach>
                        </c:if>
                        <c:if test="${cartCount > 0}">
                            <span class="position-absolute top-1 start-100 translate-middle badge rounded-pill bg-danger">
                                ${cartCount}
                            </span>
                        </c:if>
                    </a>
                </li>

                <!-- User Account / Authentication -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-light d-flex align-items-center gap-1" href="#" id="userMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-5"></i>
                                <span>${sessionScope.user.name}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="userMenu">
                                <li class="dropdown-header">Logged in as: <strong>${sessionScope.user.role}</strong></li>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <li>
                                        <a class="dropdown-item text-primary fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="bi bi-speedometer2 me-2"></i>Admin Dashboard
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                        <i class="bi bi-box-seam me-2"></i>My Orders
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item me-1">
                            <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/login.jsp">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm text-white" href="${pageContext.request.contextPath}/register.jsp">
                                Register
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Global Alert Flash Notifications -->
<div class="container mt-3">
    <c:if test="${not empty sessionScope.flashSuccess}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashSuccess" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.flashError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashError" scope="session" />
    </c:if>
</div>
