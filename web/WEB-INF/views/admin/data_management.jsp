<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý dữ liệu hệ thống — Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .lf-tabs {
            display: flex;
            border-bottom: 2px solid var(--clr-border);
            margin-bottom: 24px;
            gap: 8px;
            overflow-x: auto;
        }
        .lf-tab-btn {
            padding: 12px 20px;
            font-weight: 600;
            color: var(--txt-muted);
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 0.95rem;
            white-space: nowrap;
        }
        .lf-tab-btn:hover {
            color: var(--clr-primary);
        }
        .lf-tab-btn.active {
            color: var(--clr-primary);
            border-bottom-color: var(--clr-primary);
        }
        .lf-tab-content {
            display: none;
        }
        .lf-tab-content.active {
            display: block;
        }
        .text-white-force {
            color: #1f2937 !important;
        }
        /* Custom modal for viewing long texts */
        .lf-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.25s ease-out;
        }
        .lf-modal-overlay.open {
            opacity: 1;
            pointer-events: auto;
        }
        .lf-modal {
            background: white;
            border-radius: 16px;
            width: 100%;
            max-width: 500px;
            padding: 32px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
            transform: scale(0.9);
            transition: transform 0.25s ease-out;
        }
        .lf-modal-overlay.open .lf-modal {
            transform: scale(1);
        }
        .lf-modal__title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 16px;
        }
        .text-expandable {
            cursor: pointer;
            transition: color 0.15s ease;
            max-width: 100%;
            word-wrap: break-word;
            display: inline-block;
        }
        .text-expandable:hover {
            color: var(--clr-primary);
        }
        .text-primary-sm {
            font-size: 0.78rem;
            color: var(--clr-primary);
            font-weight: 600;
            margin-left: 4px;
            white-space: nowrap;
        }
    </style>
    <script>
        function getQueryParam(param) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(param);
        }

        document.addEventListener("DOMContentLoaded", function() {
            const tab = getQueryParam("tab") || "${activeTab}";
            switchTab(tab);
        });

        function switchTab(tabId) {
            document.querySelectorAll(".lf-tab-content").forEach(el => el.classList.remove("active"));
            document.querySelectorAll(".lf-tab-btn").forEach(el => el.classList.remove("active"));
            
            const targetContent = document.getElementById("tab-" + tabId);
            const targetBtn = document.getElementById("btn-tab-" + tabId);
            if (targetContent && targetBtn) {
                targetContent.classList.add("active");
                targetBtn.classList.add("active");
            }
            
            const newUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?tab=' + tabId;
            window.history.pushState({path:newUrl},'',newUrl);
        }

        function filterTable(input, tableId) {
            const filter = input.value.toLowerCase().trim();
            const table = document.getElementById(tableId);
            if (!table) return;
            
            const rows = table.querySelectorAll('tbody tr');
            rows.forEach(row => {
                if (row.querySelector('.td-empty')) return;
                
                let text = '';
                row.querySelectorAll('td').forEach(cell => {
                    text += cell.innerText.toLowerCase() + ' ';
                });
                
                if (text.includes(filter)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // ── Shared Confirm Modal logic ──
        var _confirmUrl = '';

        function showDeleteConfirm(msg, url) {
            _confirmUrl = url;
            document.getElementById('confirmModalMessage').innerText = msg;
            document.getElementById('confirmModal').classList.add('open');
        }

        function doConfirmDelete() {
            if (_confirmUrl) {
                window.location = _confirmUrl;
            }
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.remove('open');
            _confirmUrl = '';
        }

        function deleteUser(id) {
            showDeleteConfirm('Bạn chắc chắn muốn xóa người dùng #' + id + '?', '${pageContext.request.contextPath}/deleteuser?id=' + id);
        }

        function deleteCategory(id) {
            showDeleteConfirm('Bạn chắc chắn muốn xóa danh mục #' + id + '?', '${pageContext.request.contextPath}/delete?id=' + id);
        }

        function deleteLocation(id) {
            showDeleteConfirm('Bạn chắc chắn muốn xóa vị trí #' + id + '?', '${pageContext.request.contextPath}/deletelocations?id=' + id);
        }

        function deleteItem(id) {
            showDeleteConfirm('Bạn chắc chắn muốn xóa vật phẩm #' + id + '?', '${pageContext.request.contextPath}/deleteitem?id=' + id);
        }

        function deleteClaim(id) {
            showDeleteConfirm('Bạn chắc chắn muốn xóa yêu cầu nhận đồ #' + id + '?', '${pageContext.request.contextPath}/deleteclaim?id=' + id);
        }

        function viewTextDetail(element, title) {
            const parent = element.parentElement;
            const fullText = parent.querySelector('.full-text-content').innerText;
            
            document.getElementById('detailModalTitle').innerText = title;
            document.getElementById('detailModalBody').innerText = fullText;
            document.getElementById('detailModal').classList.add('open');
        }

        function closeDetailModal() {
            document.getElementById('detailModal').classList.remove('open');
        }
    </script>
</head>
<body>
<div class="lf-wrapper">
    <!-- NAVBAR -->
    <lf:navbar activeMenu="admin" />

    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">/</span>
            <span class="current">Quản lý dữ liệu</span>
        </div>

        <div class="lf-admin-header">
            <div class="lf-admin-badge">⚙️ Admin Panel</div>
            <h1 class="lf-page-header__title">📁 Quản Lý Dữ Liệu Hệ Thống</h1>
            <p class="lf-page-header__sub">Cổng quản trị tập trung danh sách tài khoản, danh mục, vị trí và vật phẩm</p>
        </div>

        <!-- THÔNG BÁO FLASH -->
        <c:if test="${not empty sessionScope.userDeleteSuccess}">
            <div class="lf-alert lf-alert-success mb-md">
                <span>✅ ${sessionScope.userDeleteSuccess}</span>
            </div>
            <c:remove var="userDeleteSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.userDeleteError}">
            <div class="lf-alert lf-alert-error mb-md">
                <span>❌ ${sessionScope.userDeleteError}</span>
            </div>
            <c:remove var="userDeleteError" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.message}">
            <div class="lf-alert lf-alert-success mb-md">
                <span>✅ ${sessionScope.message}</span>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <!-- TABS HEADER -->
        <div class="lf-tabs">
            <button id="btn-tab-users" class="lf-tab-btn" onclick="switchTab('users')">👥 Người dùng</button>
            <button id="btn-tab-categories" class="lf-tab-btn" onclick="switchTab('categories')">🗂️ Danh mục</button>
            <button id="btn-tab-locations" class="lf-tab-btn" onclick="switchTab('locations')">📍 Vị trí</button>
            <button id="btn-tab-items" class="lf-tab-btn" onclick="switchTab('items')">📦 Vật phẩm</button>
        </div>

        <!-- ────────────────────────────────────────── -->
        <!-- TAB 1: USERS -->
        <!-- ────────────────────────────────────────── -->
        <div id="tab-users" class="lf-tab-content">
            <!-- Tìm kiếm nhanh người dùng -->
            <div class="mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div style="font-weight: 600; color: var(--txt-secondary);">Danh sách tài khoản hệ thống</div>
                <div style="position: relative; max-width: 320px; width: 100%;">
                    <input type="text" class="form-control" placeholder="Tìm kiếm tài khoản (Tên, SĐT, Email...)" 
                           onkeyup="filterTable(this, 'table-users')" 
                           style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.88rem; height: 38px;">
                    <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.9rem;">🔍</span>
                </div>
            </div>
            <div class="lf-table-wrap">
                <table class="lf-table" id="table-users">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="u">
                            <tr>
                                <td><span class="badge badge-muted">#${u.userId}</span></td>
                                <td class="fw-bold">${u.username}</td>
                                <td>${u.fullName}</td>
                                <td class="text-sm text-white-force">${u.email}</td>
                                <td class="text-sm">${u.phoneNumber}</td>
                                <td><lf:roleBadge role="${u.role}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.isActive}"><span class="badge badge-success">✅ Active</span></c:when>
                                        <c:otherwise><span class="badge badge-muted">🔒 Locked</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="flex gap-sm">
                                        <a href="${pageContext.request.contextPath}/updateuser?id=${u.userId}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                                        <button type="button" onclick="deleteUser('${u.userId}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr><td colspan="8" class="td-empty">Chưa có người dùng nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ────────────────────────────────────────── -->
        <!-- TAB 2: CATEGORIES -->
        <!-- ────────────────────────────────────────── -->
        <div id="tab-categories" class="lf-tab-content">
            <div class="mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/add" class="btn btn-primary" style="height: 38px; display: inline-flex; align-items: center;">➕ Thêm danh mục mới</a>
                <div style="position: relative; max-width: 320px; width: 100%;">
                    <input type="text" class="form-control" placeholder="Tìm kiếm danh mục (Tên, Mô tả...)" 
                           onkeyup="filterTable(this, 'table-categories')" 
                           style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.88rem; height: 38px;">
                    <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.9rem;">🔍</span>
                </div>
            </div>
            <div class="lf-table-wrap">
                <table class="lf-table" id="table-categories">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên danh mục</th>
                            <th>Mô tả</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${categories}" var="c">
                            <tr>
                                <td><span class="badge badge-muted">#${c.categoryId}</span></td>
                                <td class="fw-bold">🏷️ ${c.name}</td>
                                <td>
                                    <div class="text-expandable" onclick="viewTextDetail(this, 'Mô tả danh mục')">
                                        <c:choose>
                                            <c:when test="${fn:length(c.description) > 30}">
                                                ${fn:substring(c.description, 0, 30)}... <span class="text-primary-sm">[Xem]</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${c.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="d-none full-text-content">${c.description}</div>
                                </td>
                                <td>
                                    <div class="flex gap-sm">
                                        <a href="${pageContext.request.contextPath}/update?id=${c.categoryId}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                                        <button onclick="deleteCategory('${c.categoryId}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categories}">
                            <tr><td colspan="4" class="td-empty">Chưa có danh mục nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ────────────────────────────────────────── -->
        <!-- TAB 3: LOCATIONS -->
        <!-- ────────────────────────────────────────── -->
        <div id="tab-locations" class="lf-tab-content">
            <div class="mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/addlocations" class="btn btn-primary" style="height: 38px; display: inline-flex; align-items: center;">➕ Thêm vị trí mới</a>
                <div style="position: relative; max-width: 320px; width: 100%;">
                    <input type="text" class="form-control" placeholder="Tìm kiếm vị trí..." 
                           onkeyup="filterTable(this, 'table-locations')" 
                           style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.88rem; height: 38px;">
                    <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.9rem;">🔍</span>
                </div>
            </div>
            <div class="lf-table-wrap">
                <table class="lf-table" id="table-locations">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên vị trí</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${locations}" var="l">
                            <tr>
                                <td><span class="badge badge-muted">#${l.locationId}</span></td>
                                <td class="fw-bold">📍 ${l.name}</td>
                                <td>
                                    <div class="flex gap-sm">
                                        <a href="${pageContext.request.contextPath}/updatelocation?id=${l.locationId}" class="btn btn-secondary btn-sm">✏️ Sửa</a>
                                        <button onclick="deleteLocation('${l.locationId}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty locations}">
                            <tr><td colspan="3" class="td-empty">Chưa có vị trí nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ────────────────────────────────────────── -->
        <!-- TAB 4: ITEMS -->
        <!-- ────────────────────────────────────────── -->
        <div id="tab-items" class="lf-tab-content">
            <!-- Đồ Báo Mất -->
            <div class="lf-card mb-lg" style="box-shadow: none; border: 1px solid var(--clr-border);">
                <div class="flex flex-between flex-center-y mb-md flex-wrap gap-2">
                    <div class="lf-section-title">🔴 Danh sách đồ báo mất</div>
                    <div style="position: relative; max-width: 280px; width: 100%;">
                        <input type="text" class="form-control" placeholder="Tìm kiếm đồ báo mất..." 
                               onkeyup="filterTable(this, 'table-items-lost')" 
                               style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.85rem; height: 34px;">
                        <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.85rem;">🔍</span>
                    </div>
                </div>
                <div class="lf-table-wrap">
                    <table class="lf-table" id="table-items-lost">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Người đăng</th>
                                <th>Ngày xảy ra</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasLost" value="false"/>
                            <c:forEach items="${items}" var="i">
                                <c:if test="${i.type == 'lost'}">
                                    <c:set var="hasLost" value="true"/>
                                    <tr>
                                        <td><span class="badge badge-muted">#${i.itemId}</span></td>
                                        <td class="fw-bold">${i.title}</td>
                                        <td><lf:statusBadge status="${i.status}"/></td>
                                        <td class="text-sm text-white-force">User #${i.userId}</td>
                                        <td class="text-sm text-white-force">${i.dateIncident}</td>
                                        <td>
                                            <div class="flex gap-sm">
                                                <a href="${pageContext.request.contextPath}/item_detail?id=${i.itemId}" class="btn btn-secondary btn-sm">🔍 Xem</a>
                                                <button onclick="deleteItem('${i.itemId}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasLost}">
                                <tr><td colspan="6" class="td-empty">Chưa có đồ báo mất nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Đồ Nhặt Được -->
            <div class="lf-card" style="box-shadow: none; border: 1px solid var(--clr-border);">
                <div class="flex flex-between flex-center-y mb-md flex-wrap gap-2">
                    <div class="lf-section-title">🟢 Danh sách đồ nhặt được</div>
                    <div style="position: relative; max-width: 280px; width: 100%;">
                        <input type="text" class="form-control" placeholder="Tìm kiếm đồ nhặt được..." 
                               onkeyup="filterTable(this, 'table-items-found')" 
                               style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.85rem; height: 34px;">
                        <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.85rem;">🔍</span>
                    </div>
                </div>
                <div class="lf-table-wrap">
                    <table class="lf-table" id="table-items-found">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Người đăng</th>
                                <th>Ngày nhặt</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="hasFound" value="false"/>
                            <c:forEach items="${items}" var="i">
                                <c:if test="${i.type == 'found'}">
                                    <c:set var="hasFound" value="true"/>
                                    <tr>
                                        <td><span class="badge badge-muted">#${i.itemId}</span></td>
                                        <td class="fw-bold">${i.title}</td>
                                        <td><lf:statusBadge status="${i.status}"/></td>
                                        <td class="text-sm text-white-force">User #${i.userId}</td>
                                        <td class="text-sm text-white-force">${i.dateIncident}</td>
                                        <td>
                                            <div class="flex gap-sm">
                                                <a href="${pageContext.request.contextPath}/item_detail?id=${i.itemId}" class="btn btn-secondary btn-sm">🔍 Xem</a>
                                                <button onclick="deleteItem('${i.itemId}')" class="btn btn-danger btn-sm">🗑️ Xóa</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasFound}">
                                <tr><td colspan="6" class="td-empty">Chưa có đồ nhặt được nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </main>

    <!-- FOOTER -->
    <lf:footer />
</div>

<!-- Modal hiển thị nội dung to -->
<div class="lf-modal-overlay" id="detailModal">
    <div class="lf-modal" style="max-width: 550px;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="lf-modal__title" id="detailModalTitle" style="margin: 0;">Nội dung chi tiết</h3>
            <button type="button" onclick="closeDetailModal()" style="border:none; background:none; font-size:1.6rem; line-height:1; cursor:pointer; color:var(--txt-muted);">&times;</button>
        </div>
        
        <div class="mb-4" id="detailModalBody" style="max-height: 300px; overflow-y: auto; white-space: pre-wrap; word-break: break-word; color: #1f2937; font-size: 0.95rem; line-height: 1.5; padding: 12px; background: #f8fafc; border-radius: 8px; border: 1px solid var(--clr-border);">
        </div>

        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary" style="font-size:0.85rem; font-weight:600; padding: 6px 16px; background:#e2e8f0; color:#334155; border:none;" onclick="closeDetailModal()">Đóng</button>
        </div>
    </div>
</div>

<!-- Modal xác nhận xóa (thay thế confirm() của trình duyệt) -->
<div class="lf-modal-overlay" id="confirmModal">
    <div class="lf-modal" style="max-width: 420px;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="lf-modal__title" style="margin: 0;">⚠️ Xác nhận thao tác</h3>
            <button type="button" onclick="closeConfirmModal()" style="border:none; background:none; font-size:1.6rem; line-height:1; cursor:pointer; color:var(--txt-muted);">&times;</button>
        </div>
        
        <div class="mb-4" id="confirmModalMessage" style="color: #1f2937; font-size: 0.95rem; line-height: 1.6; padding: 16px; background: #fff7ed; border-radius: 8px; border: 1px solid #fed7aa;">
        </div>

        <div class="d-flex justify-content-end gap-2">
            <button type="button" class="btn btn-secondary" style="font-size:0.85rem; font-weight:600; padding: 8px 20px; background:#e2e8f0; color:#334155; border:none; border-radius:8px;" onclick="closeConfirmModal()">Hủy bỏ</button>
            <button type="button" class="btn btn-danger" style="font-size:0.85rem; font-weight:600; padding: 8px 20px; background:#dc2626; color:white; border:none; border-radius:8px;" onclick="doConfirmDelete()">Xóa</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
