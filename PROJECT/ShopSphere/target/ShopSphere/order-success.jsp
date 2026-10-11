<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="NovaMart - Order Confirmed" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-5 text-center">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-sm p-5 rounded-4">
                <div class="text-success mb-3">
                    <i class="bi bi-check-circle-fill display-1"></i>
                </div>
                <h2 class="fw-bold mb-2">Thank You for Your Order!</h2>
                <p class="text-muted mb-4">
                    Your order has been received and is currently being processed by our automated inventory pipeline.
                </p>

                <div class="p-3 bg-light rounded-3 text-start mb-4">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Order Tracking ID:</span>
                        <span class="fw-bold text-primary">#${not empty param.orderId ? param.orderId : sessionScope.latestOrder.orderId}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Status:</span>
                        <span class="badge bg-warning text-dark">Processing</span>
                    </div>
                    <c:if test="${not empty sessionScope.latestOrder}">
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Total Paid:</span>
                            <span class="fw-bold text-success">
                                ₹<fmt:formatNumber value="${sessionScope.latestOrder.totalAmount}" pattern="#,##0.00" />
                            </span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span class="text-muted">Payment Method:</span>
                            <span class="fw-semibold">${sessionScope.latestOrder.paymentMethod}</span>
                        </div>
                    </c:if>
                </div>

                <div class="d-flex flex-wrap gap-2 justify-content-center">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary px-4 fw-semibold">
                        <i class="bi bi-box-seam me-1"></i>View My Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary px-4">
                        Continue Shopping
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
