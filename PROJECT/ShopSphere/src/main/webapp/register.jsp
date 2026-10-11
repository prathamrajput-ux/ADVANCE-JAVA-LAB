<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="NovaMart - Register" />
<%@ include file="fragments/header.jsp" %>
<%@ include file="fragments/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card border-0 shadow-sm p-4 rounded-3">
                <div class="text-center mb-4">
                    <div class="bg-primary text-white d-inline-flex p-3 rounded-circle mb-3 shadow-sm">
                        <i class="bi bi-person-plus-fill fs-2"></i>
                    </div>
                    <h3 class="fw-bold">Create Account</h3>
                    <p class="text-muted small">Join NovaMart to enjoy smooth and fast shopping</p>
                </div>

                <!-- Error Alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:set var="isRoleAdmin" value="${selectedRole eq 'ADMIN' or param.role eq 'ADMIN'}" />

                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <!-- Account Role Selector -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Account Role</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="role" id="roleCustomer" value="CUSTOMER" ${not isRoleAdmin ? 'checked' : ''}>
                                <label class="btn btn-outline-primary w-100 py-2 d-flex flex-column align-items-center justify-content-center h-100" for="roleCustomer">
                                    <i class="bi bi-person-fill fs-4 text-primary"></i>
                                    <span class="fw-bold mt-1">Customer</span>
                                    <span class="small text-muted" style="font-size: 0.75rem;">Browse & Shop</span>
                                </label>
                            </div>
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="role" id="roleAdmin" value="ADMIN" ${isRoleAdmin ? 'checked' : ''}>
                                <label class="btn btn-outline-danger w-100 py-2 d-flex flex-column align-items-center justify-content-center h-100" for="roleAdmin">
                                    <i class="bi bi-shield-lock-fill fs-4 text-danger"></i>
                                    <span class="fw-bold mt-1">Administrator</span>
                                    <span class="small text-muted" style="font-size: 0.75rem;">Manage Store</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="name" class="form-label fw-semibold">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="name" name="name"
                                   placeholder="e.g. John Doe" value="${param.name}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email"
                                   placeholder="name@example.com" value="${param.email}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="mobile" class="form-label fw-semibold">Mobile Number</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-phone"></i></span>
                            <input type="tel" class="form-control" id="mobile" name="mobile"
                                   placeholder="10-digit mobile number" value="${param.mobile}" required>
                        </div>
                    </div>

                    <div class="row g-2 mb-4">
                        <div class="col-sm-6">
                            <label for="password" class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Minimum 6 characters" required minlength="6">
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <label for="confirmPassword" class="form-label fw-semibold">Confirm Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock-fill"></i></span>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                       placeholder="Re-type password" required minlength="6">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow-sm">
                        <i class="bi bi-check2-circle me-1"></i>Register Account
                    </button>
                </form>

                <hr class="my-4">

                <div class="text-center">
                    <span class="text-muted small">Already have an account?</span>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="fw-semibold text-decoration-none ms-1">
                        Sign In Here
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="fragments/footer.jsp" %>
