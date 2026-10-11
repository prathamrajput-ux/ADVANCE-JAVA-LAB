<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="NovaMart - Manage Orders" />
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-grid-1x2-fill me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">
                        <i class="bi bi-boxes me-1"></i>Manage Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/orders">
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

    <!-- Page Title -->
    <div class="mb-4">
        <h3 class="fw-bold mb-1">Customer Order Management</h3>
        <p class="text-muted small mb-0">Track all customer purchases and update dispatch status</p>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card border-0 shadow-sm p-5 text-center my-4 rounded-3">
                <i class="bi bi-inbox display-1 text-muted mb-3"></i>
                <h4 class="fw-bold">No Orders Placed Yet</h4>
                <p class="text-muted">Customer transactions will appear here once submitted.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-4">
                <c:forEach var="order" items="${orders}">
                    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                        <div class="card-header bg-light py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div class="d-flex align-items-center gap-3">
                                <span class="fw-bold fs-5 text-primary">Order #${order.orderId}</span>
                                <span class="badge bg-light text-dark border">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                                </span>
                            </div>

                            <!-- Status Update Inline Form -->
                            <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="d-flex align-items-center gap-2">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <label class="small text-muted fw-semibold me-1">Status:</label>
                                <select name="status" class="form-select form-select-sm" style="width: 140px;">
                                    <option value="Processing" ${order.orderStatus == 'Processing' ? 'selected' : ''}>Processing</option>
                                    <option value="Shipped" ${order.orderStatus == 'Shipped' ? 'selected' : ''}>Shipped</option>
                                    <option value="Delivered" ${order.orderStatus == 'Delivered' ? 'selected' : ''}>Delivered</option>
                                    <option value="Cancelled" ${order.orderStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-outline-primary btn-sm fw-semibold">
                                    Update
                                </button>
                            </form>
                        </div>

                        <div class="card-body p-4">
                            <div class="row g-3 mb-3">
                                <div class="col-md-4">
                                    <span class="text-muted small text-uppercase fw-semibold d-block">Customer Details</span>
                                    <strong>${order.userName}</strong><br>
                                    <small class="text-muted">${order.userEmail}</small>
                                </div>
                                <div class="col-md-5">
                                    <span class="text-muted small text-uppercase fw-semibold d-block">Delivery Address</span>
                                    <span>${order.shippingAddress}</span>
                                </div>
                                <div class="col-md-3 text-md-end">
                                    <span class="text-muted small text-uppercase fw-semibold d-block">Payment & Amount</span>
                                    <span class="badge bg-secondary mb-1">${order.paymentMethod}</span>
                                    <h5 class="fw-bold text-success mb-0">₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00" /></h5>
                                </div>
                            </div>

                            <hr class="my-3">

                            <!-- Order Items Accordion / Summary -->
                            <h6 class="fw-bold small text-secondary text-uppercase mb-2">Order Line Items (${order.items.size()})</h6>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Product Name</th>
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

<%@ include file="../fragments/footer.jsp" %>
