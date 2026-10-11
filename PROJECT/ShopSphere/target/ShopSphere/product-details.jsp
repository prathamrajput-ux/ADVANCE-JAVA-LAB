<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="ShopSphere - ${product.name}" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-4">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Products</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products?categoryId=${product.categoryId}" class="text-decoration-none">${product.categoryName}</a></li>
            <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
        </ol>
    </nav>

    <div class="card border-0 shadow-sm p-4 rounded-3">
        <div class="row g-5 align-items-center">
            <!-- Left: Product Image -->
            <div class="col-md-6 text-center">
                <div class="position-relative overflow-hidden rounded shadow-sm bg-light p-2">
                    <c:if test="${product.discount > 0}">
                        <span class="position-absolute top-0 start-0 m-3 badge bg-danger fs-6 shadow-sm">
                            -${product.discount}% OFF
                        </span>
                    </c:if>
                    <img src="${product.imageUrl}" alt="${product.name}" class="img-fluid rounded"
                         loading="lazy" decoding="async"
                         style="max-height: 420px; object-fit: contain;"
                         onerror="this.onerror=null;this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'600\' height=\'450\'><rect width=\'100%25\' height=\'100%25\' fill=\'%23e9ecef\'/><text x=\'50%25\' y=\'50%25\' dominant-baseline=\'middle\' text-anchor=\'middle\' fill=\'%236c757d\' font-family=\'sans-serif\' font-size=\'20\'>ShopSphere Product</text></svg>';">
                </div>
            </div>

            <!-- Right: Details and Actions -->
            <div class="col-md-6">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="badge bg-primary-subtle text-primary border">${product.categoryName}</span>
                    <span class="text-muted small">&bull; Brand: <strong>${product.brand}</strong></span>
                </div>

                <h2 class="fw-bold mb-3">${product.name}</h2>

                <!-- Price Section -->
                <div class="p-3 bg-light rounded-3 mb-4">
                    <div class="d-flex align-items-baseline gap-3">
                        <span class="display-6 fw-bold text-primary">
                            ₹<fmt:formatNumber value="${product.effectivePrice}" pattern="#,##0.00" />
                        </span>
                        <c:if test="${product.discount > 0}">
                            <span class="fs-5 text-muted text-decoration-line-through">
                                ₹<fmt:formatNumber value="${product.price}" pattern="#,##0.00" />
                            </span>
                            <span class="badge bg-success">Save ${product.discount}%</span>
                        </c:if>
                    </div>
                    <small class="text-muted d-block mt-1">Inclusive of all taxes</small>
                </div>

                <!-- Stock status -->
                <div class="mb-4">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <div class="d-flex align-items-center gap-2 text-success">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>In Stock (<strong>${product.stock}</strong> units available)</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex align-items-center gap-2 text-danger">
                                <i class="bi bi-x-circle-fill"></i>
                                <span>Currently Out of Stock</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Product Description -->
                <div class="mb-4">
                    <h6 class="fw-bold text-secondary text-uppercase small">Description</h6>
                    <p class="text-muted leading-relaxed">${product.description}</p>
                </div>

                <!-- Add to Cart Form -->
                <c:if test="${product.stock > 0}">
                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="mb-3">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.productId}">

                        <div class="row g-3 align-items-center mb-4">
                            <div class="col-auto">
                                <label for="quantity" class="col-form-label fw-semibold">Quantity:</label>
                            </div>
                            <div class="col-auto">
                                <input type="number" id="quantity" name="quantity" class="form-control"
                                       value="1" min="1" max="${product.stock}" style="width: 90px;" required>
                            </div>
                        </div>

                        <div class="d-flex flex-wrap gap-2">
                            <button type="submit" class="btn btn-primary btn-lg px-4 shadow-sm fw-semibold">
                                <i class="bi bi-cart-plus me-2"></i>Add to Shopping Cart
                            </button>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-lg">
                                Continue Shopping
                            </a>
                        </div>
                    </form>
                </c:if>
                <c:if test="${product.stock <= 0}">
                    <div class="alert alert-warning mb-3">
                        <i class="bi bi-bell me-2"></i>This item is currently out of stock. Please check back later.
                    </div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">
                        Back to Products
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
