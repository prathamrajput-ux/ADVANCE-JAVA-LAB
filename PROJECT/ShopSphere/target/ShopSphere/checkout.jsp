<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="NovaMart - Checkout" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-5">
    <div class="row g-4">
        <!-- Left: Shipping & Payment Form -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm p-4 rounded-3 mb-4">
                <h4 class="fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-geo-alt-fill text-primary"></i> Shipping Address
                </h4>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/checkout" method="POST">
                    <!-- Read-only User Summary -->
                    <div class="row g-2 mb-3">
                        <div class="col-sm-6">
                            <label class="form-label small text-muted">Recipient Name</label>
                            <input type="text" class="form-control bg-light" value="${sessionScope.user.name}" readonly>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label small text-muted">Email Address</label>
                            <input type="email" class="form-control bg-light" value="${sessionScope.user.email}" readonly>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="addressLine" class="form-label fw-semibold">Street / Flat / Apartment</label>
                        <input type="text" class="form-control" id="addressLine" name="addressLine"
                               placeholder="e.g. 104, Sunrise Apartments, M.G. Road" required>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-5">
                            <label for="city" class="form-label fw-semibold">City</label>
                            <input type="text" class="form-control" id="city" name="city"
                                   placeholder="e.g. Jaipur" required>
                        </div>
                        <div class="col-md-4">
                            <label for="state" class="form-label fw-semibold">State</label>
                            <input type="text" class="form-control" id="state" name="state"
                                   placeholder="e.g. Rajasthan" required>
                        </div>
                        <div class="col-md-3">
                            <label for="pincode" class="form-label fw-semibold">PIN Code</label>
                            <input type="text" class="form-control" id="pincode" name="pincode"
                                   placeholder="302001" required pattern="[0-9]{6}">
                        </div>
                    </div>

                    <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-credit-card-fill text-primary"></i> Payment Method
                    </h5>

                    <div class="p-3 border rounded mb-4 bg-light">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="cod"
                                   value="Cash On Delivery" checked>
                            <label class="form-check-label fw-semibold" for="cod">
                                Cash On Delivery (COD)
                            </label>
                            <small class="text-muted d-block ps-1">Pay with cash upon delivery of your items.</small>
                        </div>
                        <hr class="my-2">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="upi"
                                   value="UPI / QR Code">
                            <label class="form-check-label fw-semibold" for="upi">
                                UPI / QR Code (Instant Demo)
                            </label>
                            <small class="text-muted d-block ps-1">Pay via PhonePe, Google Pay, or Paytm.</small>
                        </div>
                        <hr class="my-2">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="card"
                                   value="Credit / Debit Card">
                            <label class="form-check-label fw-semibold" for="card">
                                Credit / Debit Card (Simulated)
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm py-3">
                        <i class="bi bi-lock-fill me-2"></i>Place Order (₹<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00" />)
                    </button>
                </form>
            </div>
        </div>

        <!-- Right: Items In Order Preview -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm p-4 rounded-3 sticky-top" style="top: 80px;">
                <h5 class="fw-bold mb-3">Order Summary</h5>

                <div class="list-group list-group-flush mb-3">
                    <c:forEach var="item" items="${sessionScope.cart}">
                        <div class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center bg-transparent">
                            <div class="d-flex align-items-center gap-2">
                                <img src="${item.product.imageUrl}" class="rounded" style="width: 45px; height: 45px; object-fit: cover;"
                                     onerror="this.src='https://placehold.co/100x100?text=Product'">
                                <div>
                                    <h6 class="mb-0 small fw-semibold text-truncate" style="max-width: 180px;">${item.product.name}</h6>
                                    <small class="text-muted">Qty: ${item.quantity} &times; ₹<fmt:formatNumber value="${item.product.effectivePrice}" pattern="#,##0.00" /></small>
                                </div>
                            </div>
                            <span class="fw-semibold small">
                                ₹<fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00" />
                            </span>
                        </div>
                    </c:forEach>
                </div>

                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Items Subtotal:</span>
                    <span class="fw-semibold">₹<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00" /></span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Delivery Charges:</span>
                    <span class="text-success fw-semibold">FREE</span>
                </div>

                <hr class="my-3">

                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="fw-bold fs-5">Total Payable:</span>
                    <span class="fw-bold fs-4 text-primary">
                        ₹<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00" />
                    </span>
                </div>
                <small class="text-muted d-block text-center mt-2">
                    <i class="bi bi-shield-check text-success me-1"></i>Protected by 256-bit SSL encryption
                </small>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
