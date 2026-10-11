<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="NovaMart - Login" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-sm p-4 rounded-3">
                <div class="text-center mb-4">
                    <div class="bg-primary text-white d-inline-flex p-3 rounded-circle mb-3 shadow-sm">
                        <i class="bi bi-person-fill fs-2"></i>
                    </div>
                    <h3 class="fw-bold">Sign In</h3>
                    <p class="text-muted small">Access your NovaMart account & orders</p>
                </div>

                <!-- Success Flash Alert -->
                <c:if test="${not empty sessionScope.flashSuccess}">
                    <div class="alert alert-success alert-dismissible fade show small" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashSuccess}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="flashSuccess" scope="session" />
                </c:if>

                <!-- Error Alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Quick Demo 1-Click Fill Helpers -->
                <div class="alert alert-light border shadow-sm p-3 small mb-4 rounded-3">
                    <div class="fw-bold text-secondary mb-2 d-flex align-items-center gap-1">
                        <i class="bi bi-lightning-charge-fill text-warning"></i>
                        <span>1-Click Test Credentials:</span>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <button type="button" class="btn btn-sm btn-outline-danger w-100 py-2 d-flex align-items-center justify-content-center gap-1 shadow-sm fw-semibold" onclick="fillAdminLogin()">
                                <i class="bi bi-shield-lock-fill"></i>
                                <span>Fill Admin</span>
                            </button>
                            <div class="text-muted text-center mt-1" style="font-size: 0.72rem;">admin@shopsphere.com</div>
                        </div>
                        <div class="col-6">
                            <button type="button" class="btn btn-sm btn-outline-primary w-100 py-2 d-flex align-items-center justify-content-center gap-1 shadow-sm fw-semibold" onclick="fillUserLogin()">
                                <i class="bi bi-person-fill"></i>
                                <span>Fill User</span>
                            </button>
                            <div class="text-muted text-center mt-1" style="font-size: 0.72rem;">customer@shopsphere.com</div>
                        </div>
                    </div>
                </div>

                <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email"
                                   placeholder="name@example.com" value="${param.email}" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="Enter your password" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold shadow-sm">
                        <i class="bi bi-box-arrow-in-right me-1"></i>Sign In
                    </button>
                </form>

                <!-- Dual Simplified Signup Section -->
                <div class="mt-4 pt-3 border-top">
                    <div class="text-center mb-3">
                        <span class="text-muted fw-semibold small text-uppercase" style="letter-spacing: 0.5px;">Don't have an account? Sign up below:</span>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/register.jsp?role=CUSTOMER" class="btn btn-outline-success w-100 py-2 d-flex flex-column align-items-center justify-content-center shadow-sm h-100">
                                <i class="bi bi-person-plus-fill fs-5 mb-1 text-success"></i>
                                <span class="fw-bold" style="font-size: 0.85rem;">Sign Up as Customer</span>
                                <span class="text-muted" style="font-size: 0.7rem;">Shopper Account</span>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/register.jsp?role=ADMIN" class="btn btn-outline-danger w-100 py-2 d-flex flex-column align-items-center justify-content-center shadow-sm h-100">
                                <i class="bi bi-shield-lock-fill fs-5 mb-1 text-danger"></i>
                                <span class="fw-bold" style="font-size: 0.85rem;">Sign Up as Admin</span>
                                <span class="text-muted" style="font-size: 0.7rem;">Manager Account</span>
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
function fillAdminLogin() {
    document.getElementById('email').value = 'admin@shopsphere.com';
    document.getElementById('password').value = 'admin123';
}
function fillUserLogin() {
    document.getElementById('email').value = 'customer@shopsphere.com';
    document.getElementById('password').value = 'user123';
}
</script>

<%@ include file="fragments/footer.jsp" %>
