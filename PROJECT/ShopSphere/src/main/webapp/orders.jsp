<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="ShopSphere - My Orders" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-box-seam-fill text-primary"></i> Order History
            </h3>
            <p class="text-muted small mb-0">Track and review all purchases associated with your account</p>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-cart-plus me-1"></i>Continue Shopping
        </a>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card border-0 shadow-sm p-5 text-center my-4 rounded-3">
                <div class="mb-3">
                    <i class="bi bi-receipt display-1 text-muted"></i>
                </div>
                <h4 class="fw-bold">No Orders Placed Yet</h4>
                <p class="text-muted mb-4">You have not placed any orders yet. Discover our latest offers today!</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary px-4 py-2">
                        Explore Catalog
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-4">
                <c:forEach var="order" items="${orders}">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <!-- Order Card Header -->
                        <div class="card-header bg-light py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div class="d-flex align-items-center gap-3">
                                <span class="fw-bold fs-6">Order #${order.orderId}</span>
                                <span class="text-muted small">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                                </span>
                            </div>
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Processing'}">
                                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split me-1"></i>Processing</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Shipped'}">
                                            <span class="badge bg-info text-dark"><i class="bi bi-truck me-1"></i>Shipped</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Delivered'}">
                                            <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Delivered</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="fw-bold text-primary fs-5">
                                    ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" />
                                </span>
                            </div>
                        </div>

                        <!-- Order Card Body -->
                        <div class="card-body p-4">
                            <div class="row g-3 mb-3">
                                <div class="col-md-8">
                                    <small class="text-muted text-uppercase fw-semibold d-block">Delivery Address</small>
                                    <span>${order.shippingAddress}</span>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <small class="text-muted text-uppercase fw-semibold d-block">Payment Method</small>
                                    <span class="badge bg-light text-dark border">${order.paymentMethod}</span>
                                </div>
                            </div>

                            <hr class="my-3">

                            <!-- Order Items Table -->
                            <div class="table-responsive">
                                <table class="table table-sm align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Item</th>
                                            <th class="text-center">Quantity</th>
                                            <th class="text-end">Unit Price</th>
                                            <th class="text-end">Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${order.items}">
                                            <tr>
                                                <td class="fw-semibold">${item.productName}</td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end">₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00" /></td>
                                                <td class="text-end fw-semibold">₹<fmt:formatNumber value="${item.subTotal}" pattern="#,##0.00" /></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="fragments/footer.jsp" %>
