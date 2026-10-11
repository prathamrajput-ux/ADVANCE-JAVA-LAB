<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="NovaMart - Shopping Cart" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-5">
    <h3 class="fw-bold mb-4 d-flex align-items-center gap-2">
        <i class="bi bi-cart3 text-primary"></i> Your Shopping Cart
    </h3>

    <c:choose>
        <c:when test="${empty sessionScope.cart || sessionScope.cart.size() == 0}">
            <div class="card border-0 shadow-sm p-5 text-center my-4 rounded-3">
                <div class="mb-3">
                    <i class="bi bi-cart-x display-1 text-muted"></i>
                </div>
                <h4 class="fw-bold">Your Cart is Empty</h4>
                <p class="text-muted mb-4">You haven't added any products to your shopping cart yet.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary px-4 py-2 fw-semibold">
                        <i class="bi bi-bag-plus me-1"></i>Start Shopping
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <!-- Items Table Column -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" style="min-width: 250px;">Product</th>
                                        <th scope="col">Unit Price</th>
                                        <th scope="col" style="min-width: 130px;">Quantity</th>
                                        <th scope="col">Subtotal</th>
                                        <th scope="col" class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${sessionScope.cart}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${item.product.imageUrl}" alt="${item.product.name}"
                                                         class="rounded" style="width: 55px; height: 55px; object-fit: cover;"
                                                         onerror="this.src='https://placehold.co/100x100?text=Product'">
                                                    <div>
                                                        <h6 class="mb-0 fw-semibold">
                                                            <a href="${pageContext.request.contextPath}/product-details?id=${item.product.productId}" class="text-dark text-decoration-none">
                                                                ${item.product.name}
                                                            </a>
                                                        </h6>
                                                        <small class="text-muted">${item.product.brand}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-semibold">
                                                    ₹<fmt:formatNumber value="${item.product.effectivePrice}" pattern="#,##0.00" />
                                                </span>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex align-items-center gap-1">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${item.product.productId}">
                                                    <input type="number" name="quantity" value="${item.quantity}"
                                                           min="1" max="${item.product.stock}" class="form-control form-control-sm text-center" style="width: 65px;">
                                                    <button type="submit" class="btn btn-outline-secondary btn-sm" title="Update Quantity">
                                                        <i class="bi bi-arrow-clockwise"></i>
                                                    </button>
                                                </form>
                                            </td>
                                            <td>
                                                <span class="fw-bold text-primary">
                                                    ₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00" />
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <form action="${pageContext.request.contextPath}/cart" method="POST">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${item.product.productId}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm" title="Remove Item">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Card footer with clear and continue shopping buttons -->
                        <div class="card-footer bg-white d-flex justify-content-between align-items-center py-3">
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-left me-1"></i>Continue Shopping
                            </a>
                            <form action="${pageContext.request.contextPath}/cart" method="POST">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                    <i class="bi bi-trash3 me-1"></i>Clear Entire Cart
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Order Summary Sidebar -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4 rounded-3 sticky-top" style="top: 80px;">
                        <h5 class="fw-bold mb-3">Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Total Items:</span>
                            <span class="fw-semibold">${totalItems}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal:</span>
                            <span class="fw-semibold">₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00" /></span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Delivery Charges:</span>
                            <span class="text-success fw-semibold">FREE</span>
                        </div>

                        <hr class="my-3">

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fs-5 fw-bold">Grand Total:</span>
                            <span class="fs-4 fw-bold text-primary">
                                ₹<fmt:formatNumber value="${grandTotal}" pattern="#,##0.00" />
                            </span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm mb-3">
                            Proceed to Checkout <i class="bi bi-arrow-right ms-1"></i>
                        </a>

                        <div class="alert alert-light border small text-muted mb-0">
                            <i class="bi bi-shield-check text-success me-1"></i> Safe and secure checkout with verified order placement.
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="fragments/footer.jsp" %>
