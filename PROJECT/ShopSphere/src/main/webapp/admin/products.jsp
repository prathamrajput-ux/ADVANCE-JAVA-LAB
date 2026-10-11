<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="ShopSphere - Manage Products" />
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/products">
                        <i class="bi bi-boxes me-1"></i>Manage Products
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">
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

    <!-- Page Header & Add Product Accordion Trigger -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Catalog & Inventory Management</h3>
            <p class="text-muted small mb-0">Add new products, adjust inventory quantities, or update pricing</p>
        </div>
        <button class="btn btn-primary fw-semibold" type="button" data-bs-toggle="collapse" data-bs-target="#addProductCollapse" aria-expanded="false" aria-controls="addProductCollapse">
            <i class="bi bi-plus-circle me-1"></i>Add New Product
        </button>
    </div>

    <!-- Collapsible Add Product Card -->
    <div class="collapse mb-4" id="addProductCollapse">
        <div class="card border-0 shadow-sm p-4 rounded-3 border-top border-4 border-primary">
            <h5 class="fw-bold mb-3"><i class="bi bi-plus-square text-primary me-2"></i>Create New Product</h5>
            <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                <input type="hidden" name="action" value="add">

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Product Name *</label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Wireless Ergonomic Mouse" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Category *</label>
                        <select name="categoryId" class="form-select" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Brand</label>
                        <input type="text" name="brand" class="form-control" placeholder="e.g. Logitech">
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Base Price (₹) *</label>
                        <input type="number" step="0.01" name="price" class="form-control" placeholder="999.00" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Discount (%)</label>
                        <input type="number" step="0.01" name="discount" class="form-control" placeholder="0.00" value="0">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Initial Stock *</label>
                        <input type="number" name="stock" class="form-control" placeholder="25" required min="0">
                    </div>
                </div>

                <div class="row g-3 mb-3 align-items-center">
                    <div class="col-md-9">
                        <label class="form-label fw-semibold">Image URL</label>
                        <input type="url" id="newProductImageUrl" name="imageUrl" class="form-control"
                               placeholder="https://images.unsplash.com/..."
                               value="https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500"
                               oninput="document.getElementById('imgPreview').src = this.value">
                    </div>
                    <div class="col-md-3 text-center">
                        <small class="text-muted d-block mb-1">Live Image Preview</small>
                        <img id="imgPreview" src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500"
                             alt="Preview" class="rounded border shadow-sm"
                             style="width: 70px; height: 70px; object-fit: cover;"
                             onerror="this.src='https://placehold.co/100x100?text=Preview'">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Description</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Provide product features and specifications..."></textarea>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success fw-semibold px-4">
                        <i class="bi bi-check-lg me-1"></i>Save Product
                    </button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-toggle="collapse" data-bs-target="#addProductCollapse">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Live Search & Filter Bar -->
    <div class="card border-0 shadow-sm p-3 mb-3 rounded-3 bg-white">
        <div class="row g-2 align-items-center">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input type="text" id="adminProductSearch" class="form-control"
                           placeholder="Filter catalog live by title, category, or brand..."
                           onkeyup="filterProductTable()">
                </div>
            </div>
            <div class="col-md-6 text-md-end text-muted small">
                Showing <strong id="visibleProductCount">${products.size()}</strong> of ${products.size()} products
            </div>
        </div>
    </div>

    <!-- Products Data Table -->
    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="productTable">
                <thead class="table-light">
                    <tr>
                        <th style="width: 70px;">Image</th>
                        <th>Product & Brand</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th class="text-center" style="width: 140px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td>
                                <img src="${p.imageUrl}" alt="${p.name}" class="rounded"
                                     style="width: 50px; height: 50px; object-fit: cover;"
                                     onerror="this.src='https://placehold.co/100x100?text=Product'">
                            </td>
                            <td>
                                <div class="fw-bold">${p.name}</div>
                                <small class="text-muted">#${p.productId} &bull; ${p.brand}</small>
                            </td>
                            <td><span class="badge bg-light text-dark border">${p.categoryName}</span></td>
                            <td class="fw-semibold">₹<fmt:formatNumber value="${p.price}" pattern="#,##0.00" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.discount > 0}">
                                        <span class="badge bg-danger">-${p.discount}%</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">0%</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex align-items-center gap-1">
                                    <c:choose>
                                        <c:when test="${p.stock <= 5}">
                                            <span class="badge bg-danger-subtle text-danger fw-bold">${p.stock} units</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success-subtle text-success">${p.stock} units</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <form action="${pageContext.request.contextPath}/admin/products" method="POST" class="d-inline ms-1">
                                        <input type="hidden" name="action" value="quickStock">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <input type="hidden" name="amount" value="10">
                                        <button type="submit" class="btn btn-outline-success btn-sm py-0 px-1" title="Quick Restock +10 units">
                                            +10
                                        </button>
                                    </form>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 'ACTIVE'}">
                                        <span class="badge bg-success">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editModal${p.productId}" title="Edit Product">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/admin/products" method="POST" class="d-inline"
                                          onsubmit="return confirm('Are you sure you want to deactivate this product?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <button type="submit" class="btn btn-outline-danger" title="Deactivate Product">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>

                                <!-- Edit Modal for Product -->
                                <div class="modal fade text-start" id="editModal${p.productId}" tabindex="-1" aria-labelledby="modalLabel${p.productId}" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title fw-bold" id="modalLabel${p.productId}">Edit Product #${p.productId}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${p.productId}">

                                                    <div class="row g-3 mb-3">
                                                        <div class="col-md-6">
                                                            <label class="form-label fw-semibold">Product Name</label>
                                                            <input type="text" name="name" class="form-control" value="${p.name}" required>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label fw-semibold">Category</label>
                                                            <select name="categoryId" class="form-select" required>
                                                                <c:forEach var="cat" items="${categories}">
                                                                    <option value="${cat.categoryId}" ${cat.categoryId == p.categoryId ? 'selected' : ''}>
                                                                        ${cat.name}
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <label class="form-label fw-semibold">Brand</label>
                                                            <input type="text" name="brand" class="form-control" value="${p.brand}">
                                                        </div>
                                                    </div>

                                                    <div class="row g-3 mb-3">
                                                        <div class="col-md-4">
                                                            <label class="form-label fw-semibold">Price (₹)</label>
                                                            <input type="number" step="0.01" name="price" class="form-control" value="${p.price}" required>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label class="form-label fw-semibold">Discount (%)</label>
                                                            <input type="number" step="0.01" name="discount" class="form-control" value="${p.discount}">
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label class="form-label fw-semibold">Stock Quantity</label>
                                                            <input type="number" name="stock" class="form-control" value="${p.stock}" required min="0">
                                                        </div>
                                                    </div>

                                                    <div class="row g-3 mb-3">
                                                        <div class="col-md-8">
                                                            <label class="form-label fw-semibold">Image URL</label>
                                                            <input type="url" name="imageUrl" class="form-control" value="${p.imageUrl}">
                                                        </div>
                                                        <div class="col-md-4">
                                                            <label class="form-label fw-semibold">Status</label>
                                                            <select name="status" class="form-select">
                                                                <option value="ACTIVE" ${p.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                                                <option value="INACTIVE" ${p.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold">Description</label>
                                                        <textarea name="description" class="form-control" rows="3">${p.description}</textarea>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    <button type="submit" class="btn btn-primary fw-semibold">Update Product</button>
                                                </div>
                                            </form>
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

<script>
function filterProductTable() {
    let input = document.getElementById("adminProductSearch").value.toLowerCase();
    let table = document.getElementById("productTable");
    let trs = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
    let visible = 0;
    for (let i = 0; i < trs.length; i++) {
        let text = trs[i].innerText.toLowerCase();
        if (text.includes(input)) {
            trs[i].style.display = "";
            visible++;
        } else {
            trs[i].style.display = "none";
        }
    }
    let countElem = document.getElementById("visibleProductCount");
    if (countElem) {
        countElem.innerText = visible;
    }
}
</script>

<%@ include file="../fragments/footer.jsp" %>
