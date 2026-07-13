<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="lf" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin: Blacklist - Lost & Found</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .lf-badword-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f8fafc;
            color: #334155;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            border: 1px solid #cbd5e1;
            margin: 4px;
            transition: all 0.15s ease;
        }
        .lf-badword-tag:hover {
            border-color: #94a3b8;
            background: #f1f5f9;
        }
        .lf-badword-tag .btn-remove-word {
            border: none;
            background: none;
            color: #94a3b8;
            cursor: pointer;
            padding: 0;
            line-height: 1;
            font-size: 1.1rem;
            font-weight: 700;
            transition: color 0.15s ease;
            display: inline-block;
            vertical-align: middle;
        }
        .lf-badword-tag .btn-remove-word:hover {
            color: #ef4444;
        }
        /* Button to show add form inline */
        .lf-badword-add-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #fff8f5;
            color: #fd7e14;
            font-size: 1.25rem;
            font-weight: bold;
            border: 1.5px dashed #fd7e14;
            cursor: pointer;
            margin: 4px;
            transition: all 0.15s ease;
            line-height: 1;
        }
        .lf-badword-add-btn:hover {
            background: #fd7e14;
            color: white;
            border-style: solid;
        }
        /* Inline form to add word */
        .lf-badword-form-inline {
            display: none;
            align-items: center;
            gap: 6px;
            margin: 4px;
        }
        .lf-badword-form-inline.show {
            display: inline-flex;
        }
    </style>
</head>
<body>
<div class="lf-wrapper">
    <!-- NAVBAR (Dùng chung) -->
    <lf:navbar activeMenu="blacklist" />

    <main class="lf-main">
        <div class="lf-breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span class="sep">/</span>
            <span class="current">Blacklist SĐT & Từ cấm</span>
        </div>

        <div class="lf-admin-header">
            <div class="lf-admin-badge">⚙️ Admin Panel</div>
            <h1 class="lf-page-header__title">🛡️ Quản lý Blacklist & Từ cấm</h1>
            <p class="lf-page-header__sub">Ngăn chặn các tài khoản lừa đảo, lọc nội dung tin đăng chứa từ ngữ không phù hợp.</p>
        </div>

        <!-- FLASH MESSAGES -->
        <c:if test="${not empty sessionScope.message}">
            <div class="lf-alert lf-alert-success mb-md">
                <div>✅ ${sessionScope.message}</div>
            </div>
            <c:remove var="message" scope="session"/>
        </c:if>

        <div class="lf-grid-2">
            <div>
                <div class="lf-card mb-lg" style="height: fit-content;">
                    <div class="lf-card__title">Thêm số vào Blacklist</div>
                    <form action="blacklist" method="POST" class="lf-form" style="margin-top: 15px;">
                        <input type="hidden" name="action" value="add">
                        <div class="lf-form-group">
                            <label class="lf-label">Số điện thoại lừa đảo <span class="req">*</span></label>
                            <input type="text" name="phone" class="lf-input" placeholder="VD: 0987654321" required>
                        </div>
                        <button type="submit" class="btn btn-primary mt-sm">Thêm vào Blacklist</button>
                    </form>
                </div>
            </div>

            <div>
                <div class="lf-card">
                    <div class="lf-card__title">Danh sách SĐT Blacklist</div>
                    
                    <c:choose>
                        <c:when test="${not empty blacklistPhones}">
                            <!-- Tìm kiếm SĐT Blacklist -->
                            <div class="mb-3 d-flex justify-content-end" style="margin-top: 15px;">
                                <div style="position: relative; max-width: 280px; width: 100%;">
                                    <input type="text" class="form-control" placeholder="Tìm kiếm số điện thoại..." 
                                           onkeyup="filterBlacklistTable(this)" 
                                           style="padding-left: 36px; border-radius: 8px; border: 1px solid var(--clr-border); font-size: 0.85rem; height: 34px; width: 100%;">
                                    <span style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--txt-muted); font-size: 0.85rem;">🔍</span>
                                </div>
                            </div>
                            <div class="lf-table-wrap">
                                <table class="lf-table" id="blacklistTable">
                                    <thead>
                                        <tr>
                                            <th>Số điện thoại</th>
                                            <th style="width:100px; text-align:right;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="phone" items="${blacklistPhones}">
                                            <tr>
                                                <td>
                                                    <span class="fw-bold text-danger">${phone}</span>
                                                    <c:if test="${not empty phoneOwnerMap[phone]}">
                                                        <span style="color: var(--txt-muted); font-size: 0.85rem; margin-left: 8px;">(chủ nhân: <strong>${phoneOwnerMap[phone]}</strong>)</span>
                                                    </c:if>
                                                </td>
                                                <td style="text-align:right;">
                                                    <form method="POST" action="blacklist" style="display:inline;" onsubmit="return showBlacklistConfirm(event, 'Bỏ chặn SĐT này?');">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="phone" value="${phone}">
                                                        <button class="btn btn-sm btn-ghost">Xóa</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <lf:emptyState title="Blacklist trống" sub="Chưa có SDT nào bị chặn."/>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Bảng từ cấm có thể chỉnh sửa -->
                <div class="lf-card mt-md">
                    <div class="lf-card__title">🚫 Quản lý từ cấm vi phạm</div>
                    <div class="flex flex-wrap gap-xs align-items-center" style="margin-top: 15px;">
                        <c:forEach var="word" items="${badWords}">
                            <span class="lf-badword-tag">
                                ${word}
                                <form method="POST" action="blacklist" style="display:inline; margin:0;" onsubmit="return showBlacklistConfirm(event, 'Xóa từ cấm \'${word}\'?');">
                                    <input type="hidden" name="action" value="remove_word">
                                    <input type="hidden" name="word" value="${word}">
                                    <button type="submit" class="btn-remove-word" title="Xóa từ cấm">&times;</button>
                                </form>
                            </span>
                        </c:forEach>
                        
                        <!-- Nút Thêm và Form Inline -->
                        <button type="button" class="lf-badword-add-btn" id="btnShowAddWord" title="Thêm từ cấm">+</button>
                        
                        <form method="POST" action="blacklist" class="lf-badword-form-inline" id="formAddWordInline">
                            <input type="hidden" name="action" value="add_word">
                            <input type="text" name="word" class="lf-input" placeholder="Nhập từ..." style="padding: 4px 10px; font-size: 0.85rem; width: 140px; height: 32px;" required>
                            <button type="submit" class="btn btn-primary btn-sm" style="padding: 4px 10px; height: 32px; font-size: 0.85rem;">Lưu</button>
                            <button type="button" class="btn btn-secondary btn-sm" id="btnCancelAddWord" style="padding: 4px 10px; height: 32px; font-size: 0.85rem; background:#f1f5f9; border-color:#cbd5e1; color:#475569;">Hủy</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Custom Confirm Modal -->
<div class="lf-modal-overlay" id="confirmModal">
    <div class="lf-modal" style="max-width:400px;">
        <button class="lf-modal__close" onclick="closeConfirmModal()">&times;</button>
        <h3 class="lf-modal__title">Xác nhận</h3>
        <p class="text-sm mb-md" id="confirmText" style="color:var(--txt-primary); margin-top:15px; margin-bottom:20px; font-size:0.95rem;">Bạn chắc chắn muốn thực hiện hành động này?</p>
        <div class="flex gap-sm mt-sm">
            <button type="button" class="btn btn-secondary flex-1" style="background:#f3f4f6; color:#374151; border:1px solid #d1d5db;" onclick="closeConfirmModal()">Hủy</button>
            <button type="button" class="btn btn-primary flex-1" id="confirmBtn" style="background:#fd7e14; border-color:#fd7e14; color:white;">Đồng ý</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    let pendingForm = null;
    function showBlacklistConfirm(event, text) {
        event.preventDefault();
        pendingForm = event.target.closest('form');
        document.getElementById('confirmText').innerText = text;
        document.getElementById('confirmModal').classList.add('open');
        return false;
    }

    function closeConfirmModal() {
        document.getElementById('confirmModal').classList.remove('open');
        pendingForm = null;
    }

    document.getElementById('confirmBtn').addEventListener('click', function() {
        if (pendingForm) {
            pendingForm.submit();
        }
        closeConfirmModal();
    });

    // Inline badword adding UI triggers
    document.getElementById('btnShowAddWord').addEventListener('click', function() {
        this.style.display = 'none';
        document.getElementById('formAddWordInline').classList.add('show');
        document.getElementById('formAddWordInline').querySelector('input').focus();
    });

    document.getElementById('btnCancelAddWord').addEventListener('click', function() {
        document.getElementById('formAddWordInline').classList.remove('show');
        document.getElementById('btnShowAddWord').style.display = 'inline-flex';
    });

    function filterBlacklistTable(input) {
        const filter = input.value.toLowerCase().trim();
        const table = document.getElementById('blacklistTable');
        if (!table) return;
        const rows = table.querySelectorAll('tbody tr');
        rows.forEach(row => {
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
</script>
</body>
</html>
