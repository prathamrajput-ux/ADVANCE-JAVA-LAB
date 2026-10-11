<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="NovaMart - Customer Management" />
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
                        <i class="bi bi-clipboard-check me-1"></i>Manage Orders
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                        <i class="bi bi-people-fill me-1"></i>Customer Management
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Registered Customers & User Profiles</h3>
            <p class="text-muted small mb-0">View comprehensive customer purchase histories, expenditure, and account statuses</p>
        </div>
        <span class="badge bg-primary fs-6 px-3 py-2 shadow-sm">${users.size()} Total Registered Users</span>
    </div>

    <!-- Customer Table -->
    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>User Name & Contact</th>
                        <th>Role</th>
                        <th>Orders Placed</th>
                        <th>Total Spent</th>
                        <th>Status</th>
                        <th>Joined On</th>
                        <th class="text-center" style="width: 170px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="fw-bold text-muted">#${u.userId}</td>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold"
                                         style="width: 38px; height: 38px; font-size: 15px;">
                                        ${u.name.substring(0, 1)}
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark">${u.name}</div>
                                        <small class="text-muted">${u.email} &bull; ${u.mobile}</small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'ADMIN'}">
                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle fw-semibold">
                                            <i class="bi bi-shield-lock-fill me-1"></i>ADMIN
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-light text-secondary border fw-semibold">CUSTOMER</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="badge bg-primary-subtle text-primary fs-6 fw-bold">
                                    ${u.orderCount} order(s)
                                </span>
                            </td>
                            <td>
                                <strong class="text-success">
                                    ₹<fmt:formatNumber value="${u.totalSpent}" pattern="#,##0.00" />
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.status == 'ACTIVE'}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Suspended</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <small class="text-muted">
                                    <fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy" />
                                </small>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <!-- View Details Modal Trigger -->
                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#userModal${u.userId}" title="View Profile & Orders">
                                        <i class="bi bi-eye-fill me-1"></i>View Details
                                    </button>

                                    <!-- Status Toggle Form -->
                                    <form action="${pageContext.request.contextPath}/admin/users" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <c:choose>
                                            <c:when test="${u.status == 'ACTIVE'}">
                                                <input type="hidden" name="status" value="INACTIVE">
                                                <button type="submit" class="btn btn-outline-warning" title="Suspend Account"
                                                        <c:if test="${u.role == 'ADMIN'}">disabled</c:if>>
                                                    <i class="bi bi-pause-circle"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="status" value="ACTIVE">
                                                <button type="submit" class="btn btn-outline-success" title="Activate Account">
                                                    <i class="bi bi-play-circle"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </div>

                                <!-- Comprehensive User Detail & Order History Modal -->
                                <div class="modal fade text-start" id="userModal${u.userId}" tabindex="-1" aria-labelledby="userModalLabel${u.userId}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content rounded-3 shadow">
                                            <div class="modal-header bg-light">
                                                <h5 class="modal-title fw-bold" id="userModalLabel${u.userId}">
                                                    <i class="bi bi-person-lines-fill text-primary me-2"></i>Customer Profile: ${u.name}
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body p-4">
                                                <!-- Profile Summary Grid -->
                                                <div class="row g-3 p-3 bg-light rounded-3 mb-4">
                                                    <div class="col-sm-4">
                                                        <small class="text-muted d-block">Account ID</small>
                                                        <strong>#${u.userId}</strong>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <small class="text-muted d-block">Full Name</small>
                                                        <strong>${u.name}</strong>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <small class="text-muted d-block">Role</small>
                                                        <span class="badge bg-secondary">${u.role}</span>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <small class="text-muted d-block">Email</small>
                                                        <span>${u.email}</span>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <small class="text-muted d-block">Mobile Phone</small>
                                                        <span>${u.mobile}</span>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <small class="text-muted d-block">Registration Date</small>
                                                        <span><fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy, hh:mm a" /></span>
                                                    </div>
                                                </div>

                                                <!-- Customer Lifetime Purchasing Analytics -->
                                                <div class="row g-3 mb-4 text-center">
                                                    <div class="col-6">
                                                        <div class="p-3 border rounded-3 bg-white">
                                                            <small class="text-muted text-uppercase fw-semibold d-block">Total Orders Placed</small>
                                                            <h4 class="fw-bold text-primary mb-0 mt-1">${u.orderCount}</h4>
                                                        </div>
                                                    </div>
                                                    <div class="col-6">
                                                        <div class="p-3 border rounded-3 bg-white">
                                                            <small class="text-muted text-uppercase fw-semibold d-block">Lifetime Expenditure</small>
                                                            <h4 class="fw-bold text-success mb-0 mt-1">₹<fmt:formatNumber value="${u.totalSpent}" pattern="#,##0.00" /></h4>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Detailed Order History -->
                                                <h6 class="fw-bold text-dark mb-3"><i class="bi bi-bag-check me-2"></i>Order History Log</h6>
                                                <c:set var="userOrders" value="${userOrdersMap[u.userId]}" />
                                                <c:choose>
                                                    <c:when test="${empty userOrders}">
                                                        <div class="alert alert-light border text-center text-muted small py-3">
                                                            This user has not placed any orders yet.
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="table-responsive border rounded-3">
                                                            <table class="table table-sm align-middle mb-0">
                                                                <thead class="table-light">
                                                                    <tr>
                                                                        <th>Order #</th>
                                                                        <th>Date</th>
                                                                        <th>Amount</th>
                                                                        <th>Payment</th>
                                                                        <th>Status</th>
                                                                        <th>Items</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="ord" items="${userOrders}">
                                                                        <tr>
                                                                            <td class="fw-bold text-primary">#${ord.orderId}</td>
                                                                            <td class="small">
                                                                                <fmt:formatDate value="${ord.createdAt}" pattern="dd MMM yyyy" />
                                                                            </td>
                                                                            <td class="fw-semibold text-success">
                                                                                ₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00" />
                                                                            </td>
                                                                            <td class="small">${ord.paymentMethod}</td>
                                                                            <td>
                                                                                <span class="badge bg-warning text-dark">${ord.orderStatus}</span>
                                                                            </td>
                                                                            <td>
                                                                                <small class="text-muted">${ord.items.size()} item(s)</small>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../fragments/footer.jsp" %>
