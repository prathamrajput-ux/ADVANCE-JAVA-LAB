<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="ShopSphere - Products Catalog" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-4">
    <div class="row g-4">
        <!-- Sidebar: Categories & Filters -->
        <div class="col-lg-3 col-md-4">
            <div class="card border-0 shadow-sm p-3 mb-4 sticky-top" style="top: 80px;">
                <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-funnel-fill text-primary"></i> Categories
                </h5>
                <div class="list-group list-group-flush">
                    <a href="${pageContext.request.contextPath}/products"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${empty selectedCategoryId ? 'active fw-bold' : ''}">
                        All Categories
                        <i class="bi bi-chevron-right small"></i>
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/products?categoryId=${cat.categoryId}"
                           class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${selectedCategoryId == cat.categoryId ? 'active fw-bold' : ''}">
                            ${cat.name}
                            <i class="bi bi-chevron-right small"></i>
                        </a>
                    </c:forEach>
                </div>

                <c:if test="${not empty selectedCategoryId || not empty searchQuery}">
                    <hr class="my-3">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm w-100">
                        <i class="bi bi-x-circle me-1"></i>Reset All Filters
                    </a>
                </c:if>
            </div>
        </div>

        <!-- Main Product Grid -->
        <div class="col-lg-9 col-md-8">
            <!-- Header bar -->
            <div class="d-flex flex-wrap justify-content-between align-items-center bg-white p-3 rounded shadow-sm mb-4">
                <div>
                    <h4 class="fw-bold mb-0">
                        <c:choose>
                            <c:when test="${not empty searchQuery}">
                                Search Results for: "<span class="text-primary">${searchQuery}</span>"
                            </c:when>
                            <c:when test="${not empty selectedCategoryId}">
                                Filtered Category
                            </c:when>
                            <c:otherwise>
                                All Products
                            </c:otherwise>
                        </c:choose>
                    </h4>
                    <small class="text-muted">${products.size()} product(s) available</small>
                </div>
            </div>

            <!-- Products List -->
            <c:choose>
                <c:when test="${empty products}">
                    <div class="card border-0 shadow-sm p-5 text-center my-4">
                        <i class="bi bi-search display-1 text-muted mb-3"></i>
                        <h4 class="fw-bold">No Products Found</h4>
                        <p class="text-muted">We couldn't find any products matching your selection.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                                Browse All Products
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-xl-3 g-4">
                        <c:forEach var="p" items="${products}">
                            <div class="col">
                                <div class="card h-100 border-0 shadow-sm product-card position-relative">
                                    <!-- Discount Badge -->
                                    <c:if test="${p.discount > 0}">
                                        <span class="position-absolute top-0 start-0 m-2 badge bg-danger shadow-sm">
                                            -${p.discount}% OFF
                                        </span>
                                    </c:if>

                                    <!-- Product Image (Optimized Async & Lazy) -->
                                    <div class="ratio ratio-4x3 bg-light overflow-hidden rounded-top">
                                        <img src="${p.imageUrl}" class="card-img-top object-fit-cover" alt="${p.name}"
                                             loading="lazy" decoding="async" width="400" height="300"
                                             onerror="this.onerror=null;this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'400\' height=\'300\'><rect width=\'100%25\' height=\'100%25\' fill=\'%23e9ecef\'/><text x=\'50%25\' y=\'50%25\' dominant-baseline=\'middle\' text-anchor=\'middle\' fill=\'%236c757d\' font-family=\'sans-serif\' font-size=\'16\'>ShopSphere Item</text></svg>';">
                                    </div>

                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="badge bg-light text-secondary border">${p.categoryName}</span>
                                            <c:choose>
                                                <c:when test="${p.stock > 0}">
                                                    <span class="badge bg-success-subtle text-success small">In Stock (${p.stock})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger small">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <h6 class="card-title fw-bold mb-1 text-truncate" title="${p.name}">
                                            <a href="${pageContext.request.contextPath}/product-details?id=${p.productId}" class="text-dark text-decoration-none">
                                                ${p.name}
                                            </a>
                                        </h6>
                                        <p class="text-muted small mb-2">${p.brand}</p>

                                        <!-- Pricing -->
                                        <div class="mt-auto pt-2">
                                            <div class="d-flex align-items-baseline gap-2 mb-3">
                                                <h5 class="fw-bold text-primary mb-0">
                                                    ₹<fmt:formatNumber value="${p.effectivePrice}" pattern="#,##0.00" />
                                                </h5>
                                                <c:if test="${p.discount > 0}">
                                                    <span class="text-muted text-decoration-line-through small">
                                                        ₹<fmt:formatNumber value="${p.price}" pattern="#,##0.00" />
                                                    </span>
                                                </c:if>
                                            </div>

                                            <!-- Buttons -->
                                            <div class="d-grid gap-2">
                                                <form action="${pageContext.request.contextPath}/cart" method="POST">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${p.productId}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <button type="submit" class="btn btn-outline-primary btn-sm w-100 fw-semibold"
                                                            <c:if test="${p.stock <= 0}">disabled</c:if>>
                                                        <i class="bi bi-cart-plus me-1"></i>Add to Cart
                                                    </button>
                                                </form>
                                                <a href="${pageContext.request.contextPath}/product-details?id=${p.productId}"
                                                   class="btn btn-light btn-sm text-secondary">
                                                    View Details
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
