# 📋 BÁO CÁO KỸ THUẬT DỰ ÁN LOST & FOUND
**Môn: PRJ301 — Java Web Application Development**

---

## 1. CẤU TRÚC PROJECT (Project Structure)

```
lost-found/
├── src/java/                          ← Mã nguồn Java (back-end)
│   ├── ConnectDB.properties           ← File cấu hình kết nối DB
│   ├── badwords.txt                   ← Danh sách từ cấm (content filter)
│   ├── blacklist_phones.txt           ← Danh sách SĐT bị chặn
│   ├── controller/                    ← Servlet Controllers (36 file)
│   │   ├── loginController.java       ← Đăng nhập
│   │   ├── logoutController.java      ← Đăng xuất
│   │   ├── registerController.java    ← Đăng ký
│   │   ├── homeController.java        ← Trang chủ
│   │   ├── itemDetailController.java  ← Xem chi tiết + Comment/Reply/Claim
│   │   ├── reportLostController.java  ← Đăng tin mất/nhặt đồ
│   │   ├── editItemController.java    ← Sửa bài đăng
│   │   ├── myItemsController.java     ← Quản lý tin của tôi
│   │   ├── editProfileController.java ← Sửa hồ sơ + Avatar
│   │   ├── inboxController.java       ← Hòm thư thông báo
│   │   ├── ReportController.java      ← Báo cáo vi phạm bài viết
│   │   ├── SupportController.java     ← Gửi yêu cầu hỗ trợ
│   │   ├── AuthorizationFilter.java   ← Bộ lọc phân quyền (Filter)
│   │   ├── Admin*Controller.java      ← Các controller quản trị Admin
│   │   ├── List*Controller.java       ← CRUD danh sách (Category, Location, User, Claim, Item)
│   │   ├── Add/Update/Delete*.java    ← CRUD thêm/sửa/xóa
│   │   └── Mark*Controller.java       ← Đánh dấu đã đọc thông báo
│   ├── dal/                           ← Data Access Layer (9 file)
│   │   ├── DBContext.java             ← Kết nối CSDL (SQL Server)
│   │   ├── UserDAO.java               ← Thao tác bảng Users
│   │   ├── ItemDAO.java               ← Thao tác bảng Items
│   │   ├── MessageDAO.java            ← Thao tác bảng Message (Comment, Reply, Report, Notification)
│   │   ├── ClaimDAO.java              ← Thao tác bảng Claims (Yêu cầu nhận đồ)
│   │   ├── CategoryDAO.java           ← Thao tác bảng Categories
│   │   ├── LocationDAO.java           ← Thao tác bảng Locations
│   │   └── SupportRequestDAO.java     ← Thao tác bảng SupportRequests
│   ├── model/                         ← Java Bean / POJO (7 file)
│   │   ├── Users.java                 ← userId, username, password, fullName, email, phoneNumber, avatarUrl, role, isActive
│   │   ├── Items.java                 ← itemId, userId, categoryId, locationId, title, description, imagesJSON, status, type, dateIncident, locationDetails
│   │   ├── Message.java               ← messageId, userId, title, message, isRead, relatedItemId, parentId, senderId
│   │   ├── Claims.java                ← claimId, itemId, claimerId, status
│   │   ├── Categories.java            ← categoryId, name
│   │   ├── Locations.java             ← locationId, name
│   │   └── SupportRequest.java        ← id, userId, subject, message, status
│   └── util/                          ← Lớp tiện ích (2 file)
│       ├── ContentFilter.java         ← Quét từ cấm + SĐT blacklist
│       └── FileUtil.java              ← Lưu/xóa ảnh upload (dual-write)
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                    ← Cấu hình Servlet Mapping
│   │   ├── views/                     ← JSP Views (22 file)
│   │   │   ├── login.jsp, register.jsp
│   │   │   ├── home.jsp, items.jsp, item_detail.jsp
│   │   │   ├── report_lost.jsp, edit_item.jsp, my_items.jsp
│   │   │   ├── inbox.jsp, edit_profile.jsp
│   │   │   ├── support.jsp, user_detail.jsp
│   │   │   ├── list*.jsp, add*.jsp, update*.jsp   ← CRUD views
│   │   │   └── admin/                 ← Admin views
│   │   │       ├── moderation.jsp     ← Kiểm duyệt vi phạm
│   │   │       ├── blacklist.jsp      ← Quản lý từ cấm + SĐT blacklist
│   │   │       ├── data_management.jsp← Thống kê dữ liệu
│   │   │       └── support_list.jsp   ← Quản lý yêu cầu hỗ trợ
│   │   └── tags/                      ← Custom Tag Files (8 file)
│   │       ├── navbar.tag             ← Thanh điều hướng (navbar) + thông báo
│   │       ├── userMenu.tag           ← Menu user dropdown + notification bell
│   │       ├── footer.tag             ← Footer
│   │       ├── avatar.tag             ← Hiển thị avatar
│   │       ├── statusBadge.tag        ← Badge trạng thái (active, completed, processing)
│   │       ├── typeBadge.tag          ← Badge loại tin (lost, found)
│   │       ├── roleBadge.tag          ← Badge vai trò (admin, student)
│   │       └── emptyState.tag         ← Hiển thị trạng thái trống
│   ├── assets/css/style.css           ← File CSS chính
│   ├── assets/js/app.js               ← File JavaScript chính
│   └── uploads/                       ← Thư mục lưu ảnh upload
│       ├── avatars/                   ← Ảnh avatar user
│       └── demo/                      ← Ảnh demo placeholder
└── allowedlib/
    └── mssql-jdbc-13.2.0.jre11.jar    ← JDBC Driver cho SQL Server
```

> **Kiến trúc tổng quan**: Mô hình **MVC (Model – View – Controller)** kết hợp **DAO Pattern** (Data Access Object) để tách biệt hoàn toàn tầng xử lý nghiệp vụ, tầng truy xuất dữ liệu, và tầng giao diện.

---

## 2. WORKFLOW (Luồng Xử Lý Request)

### 2.1. Luồng tổng quát của một Request

```mermaid
sequenceDiagram
    participant Browser
    participant Filter as AuthorizationFilter
    participant Servlet as Controller (Servlet)
    participant DAO as DAO Layer
    participant DB as SQL Server DB
    participant JSP as JSP View

    Browser->>Filter: HTTP Request (GET/POST)
    Filter->>Filter: Kiểm tra Session, phân quyền
    Filter->>Servlet: chain.doFilter()
    Servlet->>DAO: Gọi DAO methods
    DAO->>DB: Thực thi SQL (PreparedStatement)
    DB-->>DAO: ResultSet
    DAO-->>Servlet: Java Objects (Model)
    Servlet->>JSP: request.setAttribute() → forward()
    JSP-->>Browser: HTML Response
```

### 2.2. Chi tiết luồng xử lý từng bước

**Bước 1 – Filter chặn toàn bộ request:**
- File: [AuthorizationFilter.java](file:///d:/prj301/lost-found/src/java/controller/AuthorizationFilter.java) — Annotation `@WebFilter("/*")` (dòng 17)
- Mọi request đều qua Filter trước → Filter kiểm tra:
  - Cho pass tĩnh (assets, uploads) → dòng 35
  - Set unread notification count cho navbar nếu đã login → dòng 41-85
  - Cho pass các trang public (login, register, home, items, item_detail) → dòng 89-93
  - Redirect về `/login` nếu chưa đăng nhập → dòng 96-99
  - Chặn student truy cập trang admin → dòng 104-111

**Bước 2 – Controller nhận request:**
- Servlet mapping được khai báo trong [web.xml](file:///d:/prj301/lost-found/web/WEB-INF/web.xml) (dòng 8-116) hoặc bằng `@WebServlet` annotation
- Controller xử lý logic trong `doGet()` (hiển thị trang) hoặc `doPost()` (xử lý form submit)

**Bước 3 – Controller gọi DAO:**
- DAO kế thừa `DBContext` để lấy `connection` → dùng `PreparedStatement` để thao tác DB

**Bước 4 – Trả về JSP:**
- `request.setAttribute("key", value)` → đặt dữ liệu
- `request.getRequestDispatcher("/WEB-INF/views/xxx.jsp").forward(request, response)` → chuyển tiếp sang View
- Hoặc `response.sendRedirect("url")` → redirect

---

## 3. CÁC MODULE CHÍNH

### Module 1: Đăng nhập / Đăng ký / Đăng xuất

### Module 2: Đăng tin Mất đồ / Nhặt được

### Module 3: Comment & Reply Comment

### Module 4: Thông báo (Notification System)

### Module 5: Yêu cầu nhận đồ (Claim System)

### Module 6: Báo cáo vi phạm (Report System)

### Module 7: Quản trị Admin (Admin Dashboard)

### Module 8: Upload & Quản lý Hình ảnh

### Module 9: Bộ lọc nội dung tự động (Content Filter Bot)

*(Chi tiết từng module xem mục 4 bên dưới)*

---

## 4. TRÌNH BÀY CHI TIẾT TỪNG MODULE

---

### 4.1. MODULE ĐĂNG NHẬP — SESSION

> **Câu hỏi:** *"Trình bày ví dụ login dùng session ntn..."*

#### 4.1.1. Luồng Login đầy đủ

**File Controller:** [loginController.java](file:///d:/prj301/lost-found/src/java/controller/loginController.java)

**`doGet()` (dòng 40-50):** Hiển thị form đăng nhập
```java
// Dòng 42-47: Nếu đã có session → redirect về home, không show form login nữa
HttpSession session = request.getSession(false);
if (session != null && session.getAttribute("currentUser") != null) {
    response.sendRedirect("home");
    return;
}
// Dòng 49: Forward sang trang login.jsp
request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
```

**`doPost()` (dòng 53-80):** Xử lý form login submit
```java
// Dòng 55-56: Lấy username, password từ form
String username = request.getParameter("username");
String password = request.getParameter("password");

// Dòng 66-67: Gọi DAO kiểm tra đăng nhập
UserDAO dao = new UserDAO();
Users loggedInUser = dao.checkLogin(username, password);

// Dòng 71-75: Nếu đăng nhập thành công → TẠO SESSION
if (loggedInUser != null) {
    HttpSession session = request.getSession();           // Tạo session mới
    session.setAttribute("currentUser", loggedInUser);    // Lưu object User vào session
    session.setAttribute("userRole", loggedInUser.getRole()); // Lưu role ("admin" / "student")
    response.sendRedirect("home");                        // Redirect về trang chủ
}
// Dòng 76-79: Nếu sai → trả lỗi, forward lại form login
else {
    request.setAttribute("error", "Sai tai khoan hoac mat khau!");
    request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
}
```

**File DAO:** [UserDAO.java](file:///d:/prj301/lost-found/src/java/dal/UserDAO.java) — method `checkLogin()` (dòng 11-32)
```java
// Dòng 12-15: Query kiểm tra username + password + is_active = 1 (chưa bị khóa)
String sql = "SELECT * FROM Users WHERE username = ? AND password = ? AND is_active = 1";
// Dùng PreparedStatement để chống SQL Injection
ps.setString(1, username);
ps.setString(2, password);
// Nếu có row → mapUser(rs) → trả về object Users
// Nếu không có → trả về null
```

**File View:** [login.jsp](file:///d:/prj301/lost-found/web/WEB-INF/views/login.jsp) — form gửi POST đến `/login`

#### 4.1.2. Session được sử dụng ở đâu trong toàn dự án

| Nơi sử dụng | File | Dòng | Mục đích |
|---|---|---|---|
| Tạo session | [loginController.java](file:///d:/prj301/lost-found/src/java/controller/loginController.java) | 72-74 | `session.setAttribute("currentUser", loggedInUser)` |
| Kiểm tra đăng nhập | [AuthorizationFilter.java](file:///d:/prj301/lost-found/src/java/controller/AuthorizationFilter.java) | 41, 96 | `session.getAttribute("currentUser")` |
| Kiểm tra quyền admin | [AuthorizationFilter.java](file:///d:/prj301/lost-found/src/java/controller/AuthorizationFilter.java) | 46, 101 | `session.getAttribute("userRole")` |
| Lưu flash message | Nhiều controller | — | `session.setAttribute("message", "...")` |
| Admin notification tracking | [AuthorizationFilter.java](file:///d:/prj301/lost-found/src/java/controller/AuthorizationFilter.java) | 48-76 | `session.setAttribute("adminLastCount_*", count)` |
| Hủy session (Logout) | [logoutController.java](file:///d:/prj301/lost-found/src/java/controller/logoutController.java) | 59-63 | `session.invalidate()` |

#### 4.1.3. Logout — Hủy Session

**File:** [logoutController.java](file:///d:/prj301/lost-found/src/java/controller/logoutController.java) — `doGet()` (dòng 57-64)
```java
HttpSession session = request.getSession(false);
if (session != null) {
    session.invalidate();  // Xóa toàn bộ session data
}
response.sendRedirect(request.getContextPath() + "/home"); // Redirect về trang chủ
```

---

### 4.2. VỀ COOKIES — DỰ ÁN NÀY KHÔNG DÙNG COOKIES

> **Câu hỏi:** *"Giỏ hàng dùng cookies như thế này ở đâu..."*

Dự án Lost & Found **không có chức năng giỏ hàng** và **không sử dụng Cookie** để lưu trữ dữ liệu client-side. Lý do:
- Đây là ứng dụng **cộng đồng tìm đồ thất lạc**, không phải ứng dụng thương mại điện tử → không cần giỏ hàng.
- Toàn bộ trạng thái người dùng được quản lý bằng **HttpSession** (server-side), đảm bảo an toàn hơn cookies.
- Cookie duy nhất tồn tại là `JSESSIONID` do Tomcat tự tạo để duy trì phiên làm việc (session tracking).

**Nếu cần so sánh Session vs Cookie:**

| Tiêu chí | Session (dùng trong dự án) | Cookie |
|---|---|---|
| Lưu ở | Server (bộ nhớ Tomcat) | Client (trình duyệt) |
| Bảo mật | Cao (user không thể thay đổi) | Thấp (user có thể xem/sửa) |
| Dung lượng | Không giới hạn | Tối đa 4KB |
| Thời gian sống | Hết khi đóng trình duyệt hoặc timeout | Tùy chỉnh `maxAge` |
| Ứng dụng | Lưu thông tin đăng nhập, quyền truy cập | Remember me, preferences |

---

### 4.3. MODULE COMMENT & REPLY COMMENT

#### 4.3.1. Xem bình luận (doGet)

**File Controller:** [itemDetailController.java](file:///d:/prj301/lost-found/src/java/controller/itemDetailController.java)

**`doGet()` (dòng 172-182):** Lấy tất cả comments của bài viết
```java
int itemId = Integer.parseInt(request.getParameter("id"));
forwardDetail(itemId, request, response, currentUser);
```

**`forwardDetail()` (dòng 79-169):** Xử lý chính
```java
// Dòng 97-103: Lấy tất cả message của item, lọc ra những message có title = "Comment"
List<Message> allMessages = messageDAO.getMessagesByItemId(itemId);
List<Message> comments = new ArrayList<>();
for (Message msg : allMessages) {
    if ("Comment".equalsIgnoreCase(msg.getTitle())) {
        comments.add(msg);
    }
}

// Dòng 105-123: XÂY DỰNG CÂY BÌNH LUẬN (Comment Tree) — Thuật toán parent-child
List<CommentNode> rootNodes = new ArrayList<>();      // Bình luận gốc (parentId = null)
Map<Integer, CommentNode> nodeMap = new HashMap<>();   // Map để tìm nhanh

for (Message c : comments) {
    CommentNode node = new CommentNode(c);
    nodeMap.put(c.getMessageId(), node);
}
for (Message c : comments) {
    CommentNode node = nodeMap.get(c.getMessageId());
    if (c.getParentId() == null || c.getParentId() == 0) {
        rootNodes.add(node);          // Comment gốc → thêm vào danh sách root
    } else {
        CommentNode parentNode = nodeMap.get(c.getParentId());
        if (parentNode != null) {
            parentNode.getReplies().add(node);  // Reply → gắn vào replies của comment cha
        } else {
            rootNodes.add(node);      // Parent không tìm thấy → coi như root
        }
    }
}

// Dòng 158: Gửi cây bình luận sang JSP
request.setAttribute("commentTree", rootNodes);
```

**Cấu trúc `CommentNode`** (dòng 24-39 cùng file):
```java
public static class CommentNode {
    private Message comment;                     // Nội dung bình luận
    private List<CommentNode> replies = new ArrayList<>();  // Danh sách reply con
    // getter/setter...
}
```

#### 4.3.2. Gửi bình luận / Reply (doPost)

**`doPost()` (dòng 304-323):** Phân loại hành động
```java
// Dòng 314-322: Kiểm tra tham số "action" để phân biệt loại POST
if ("respond_claim".equals(request.getParameter("action"))) {
    handleRespondClaim(request, response, currentUser);
} else if ("owner_request_lost".equals(...)) { ... }
  else if ("finder_respond_lost".equals(...)) { ... }
  else {
    handleSendMessage(request, response, currentUser);  // MẶC ĐỊNH = Gửi comment
}
```

**`handleSendMessage()` (dòng 184-215):** Xử lý gửi Comment + Reply
```java
int itemId = Integer.parseInt(request.getParameter("item_id"));
String content = request.getParameter("message");

// Dòng 193-199: Kiểm tra có parent_id không → Nếu có = Reply, không có = Comment gốc
String parentIdRaw = request.getParameter("parent_id");
Integer parentId = null;
if (parentIdRaw != null && !parentIdRaw.trim().isEmpty()) {
    parentId = Integer.parseInt(parentIdRaw.trim());
}

// Dòng 201: Gọi DAO lưu comment vào DB
messageDAO.insertComment(currentUser.getUserId(), itemId, "Comment", content, parentId);

// Dòng 202-208: Nếu là Reply → GỬI THÔNG BÁO cho người bị reply
if (parentId != null) {
    Message parentMsg = messageDAO.getMessageById(parentId);
    if (parentMsg != null && parentMsg.getUserId() != currentUser.getUserId()) {
        String notifMsg = "đã trả lời bình luận của bạn.";
        messageDAO.insertReplyNotification(parentMsg.getUserId(), currentUser.getUserId(), itemId, notifMsg);
    }
}
```

**File DAO:** [MessageDAO.java](file:///d:/prj301/lost-found/src/java/dal/MessageDAO.java)

- `insertComment()` (dòng 167-185):
```java
// Dòng 169: INSERT vào bảng Message với parent_id (null = comment gốc, có giá trị = reply)
String sql = "INSERT INTO Message (user_id, title, message, is_read, related_item_id, parent_id) VALUES (?, ?, ?, 0, ?, ?)";
// Dòng 175-178: Nếu parentId null → setNull, nếu có → setInt
```

- `insertReplyNotification()` (dòng 187-201):
```java
// Dòng 189-190: INSERT notification loại 'Reply' với sender_id
String sql = "INSERT INTO Message (user_id, sender_id, title, message, is_read, related_item_id) VALUES (?, ?, 'Reply', ?, 0, ?)";
// user_id = người NHẬN thông báo, sender_id = người GỬI reply
```

**File View:** [item_detail.jsp](file:///d:/prj301/lost-found/web/WEB-INF/views/item_detail.jsp) — Render cây bình luận bằng `<c:forEach>` lồng nhau (recursive via JSTL)

---

### 4.4. MODULE THÔNG BÁO (Notification System)

#### 4.4.1. Đếm thông báo chưa đọc

**File:** [AuthorizationFilter.java](file:///d:/prj301/lost-found/src/java/controller/AuthorizationFilter.java)

Filter chạy trên **MỌI request** → đảm bảo navbar luôn hiển thị số thông báo chính xác:

```java
// Dòng 82-84 (cho Student):
int unreadCount = msgDao.countUnreadInbox(currUser.getUserId());
req.setAttribute("unreadInboxCount", unreadCount);
req.setAttribute("inboxNotificationsList", msgDao.getInbox(currUser.getUserId()));
```

```java
// Dòng 46-80 (cho Admin — dùng Session để track "đã đọc"):
// Admin có cơ chế đặc biệt: so sánh số lượng hiện tại vs số đã ghi nhận trong session
Integer lastCount = (Integer) session.getAttribute("adminLastCount_" + type);
if (lastCount == null || lastCount != currentCount) {
    session.setAttribute("adminLastCount_" + type, currentCount);
    session.setAttribute("adminRead_" + type, false);  // Có thay đổi → đánh dấu chưa đọc
}
```

**File DAO:** [MessageDAO.java](file:///d:/prj301/lost-found/src/java/dal/MessageDAO.java) — `countUnreadInbox()` (dòng 261-278):
```java
// Đếm message có is_read = 0 thuộc các loại: Comment (trên bài của mình), Reply, System, Account, Support_*
String sql = "SELECT COUNT(m.message_id) FROM Message m LEFT JOIN Items i ON m.related_item_id = i.item_id "
    + "WHERE (i.user_id = ? AND m.is_read = 0 AND m.user_id != i.user_id AND m.title = 'Comment') "
    + "   OR (m.related_item_id IS NULL AND m.user_id = ? AND m.is_read = 0 AND m.title IN ('System', 'Account', ...)) "
    + "   OR (m.user_id = ? AND m.is_read = 0 AND m.title = 'Reply')";
```

#### 4.4.2. Đánh dấu đã đọc

- **Đọc từng tin:** [MarkNotificationReadController.java](file:///d:/prj301/lost-found/src/java/controller/MarkNotificationReadController.java) → gọi `msgDao.markMessageAsReadById(messageId)`
- **Đọc tất cả:** [MarkAllNotificationsReadController.java](file:///d:/prj301/lost-found/src/java/controller/MarkAllNotificationsReadController.java) → gọi `msgDao.markAllInboxMessagesAsRead(userId)`
- **Tự động đọc khi vào trang chi tiết:** [itemDetailController.java](file:///d:/prj301/lost-found/src/java/controller/itemDetailController.java) dòng 91: `messageDAO.markMessagesAsRead(itemId, currentUser.getUserId())`

#### 4.4.3. Các loại thông báo

| Loại (title) | Mô tả | Khi nào tạo |
|---|---|---|
| `Comment` | Ai đó bình luận bài viết của bạn | `itemDetailController.doPost()` |
| `Reply` | Ai đó trả lời bình luận của bạn | `itemDetailController.handleSendMessage()` dòng 206 |
| `Account` | Thông báo tài khoản (khóa, blacklist) | `AdminBlacklistController`, `ReportController` |
| `System` | Thông báo hệ thống | Admin gửi |
| `Support_Resolved` | Yêu cầu hỗ trợ đã được xử lý | `AdminSupportController` |
| `Support_Rejected` | Yêu cầu hỗ trợ bị từ chối | `AdminSupportController` |
| `[REPORT] ...` | Báo cáo vi phạm (chỉ admin thấy) | `ReportController.doPost()` |

---

### 4.5. MODULE UPLOAD & QUẢN LÝ HÌNH ẢNH

#### 4.5.1. Upload ảnh bài đăng

**File Controller:** [reportLostController.java](file:///d:/prj301/lost-found/src/java/controller/reportLostController.java)

Annotation `@MultipartConfig` (dòng 24-28):
```java
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1MB buffer trên bộ nhớ
    maxFileSize = 5 * 1024 * 1024,           // Tối đa 5MB mỗi ảnh
    maxRequestSize = 20 * 1024 * 1024        // Tối đa 20MB toàn request
)
```

**`buildImagesJson()` (dòng 148-184):** Xử lý multipart upload
```java
// Duyệt tất cả Parts có name="images"
for (Part part : request.getParts()) {
    if (!"images".equals(part.getName()) || part.getSize() <= 0) continue;
    if (count >= 5) break;  // Giới hạn tối đa 5 ảnh

    // Kiểm tra content type phải là image/*
    String contentType = part.getContentType();
    if (contentType == null || !contentType.startsWith("image/")) {
        throw new ServletException("Chi duoc upload file anh.");
    }

    // Tạo tên file unique: timestamp + UUID + extension
    String savedName = System.currentTimeMillis() + "_" + UUID.randomUUID()... + extension;

    // Gọi FileUtil để lưu file
    util.FileUtil.saveUploadedFile(part, savedName, getServletContext(), UPLOAD_FOLDER);

    // Tạo relative path để lưu vào DB dưới dạng JSON array
    // Kết quả: ["uploads/1234_abc.jpg","uploads/5678_def.png"]
}
```

#### 4.5.2. Lưu ảnh bền vững (Dual-Write)

**File:** [FileUtil.java](file:///d:/prj301/lost-found/src/java/util/FileUtil.java) — `saveUploadedFile()` (dòng 14-41)
```java
// BƯỚC 1 (dòng 16-24): Lưu vào thư mục deploy (build/web/uploads/)
String deployRoot = context.getRealPath("/");
Path deployFile = Paths.get(deployRoot).resolve(folderName).resolve(savedName);
Files.copy(part.getInputStream(), deployFile, REPLACE_EXISTING);

// BƯỚC 2 (dòng 27-39): Lưu song song vào thư mục source (web/uploads/)
// → Đảm bảo ảnh KHÔNG BỊ MẤT khi Clean & Build
String sourceRoot = deployRoot.replace("build\\web", "web");
Path sourceFile = Paths.get(sourceRoot).resolve(folderName).resolve(savedName);
Files.copy(part.getInputStream(), sourceFile, REPLACE_EXISTING);
```

> **Ý nghĩa**: Tomcat chạy từ thư mục `build/web/` → khi Clean & Build, NetBeans xóa sạch thư mục `build/` rồi copy lại từ `web/`. Nếu chỉ lưu vào `build/web/uploads/` thì ảnh sẽ bị mất. Giải pháp **dual-write** lưu đồng thời cả hai nơi.

#### 4.5.3. Upload Avatar

**File Controller:** [editProfileController.java](file:///d:/prj301/lost-found/src/java/controller/editProfileController.java) — tương tự `reportLostController`, dùng `FileUtil.saveUploadedFile()` lưu vào `uploads/avatars/`, rồi cập nhật `avatar_url` trong bảng Users.

---

### 4.6. MODULE ĐĂNG TIN MẤT ĐỒ / NHẶT ĐƯỢC

**File Controller:** [reportLostController.java](file:///d:/prj301/lost-found/src/java/controller/reportLostController.java)

**`doGet()` (dòng 186-200):** Hiển thị form đăng tin
```java
// Kiểm tra đăng nhập → Load categories, locations → Forward sang report_lost.jsp
String reportType = resolveReportType(request);  // "lost" hoặc "found"
bindFormMeta(request, reportType);    // Set tiêu đề form tùy loại tin
loadReferenceData(request);           // Load dropdown danh mục + vị trí
```

**`doPost()` (dòng 202-325):** Xử lý submit
```java
// Dòng 217-224: Kiểm tra tài khoản bị khóa/blacklist
if (!currentUser.isIsActive() || ContentFilter.getAllBlacklistPhones().contains(phone)) {
    request.setAttribute("ERROR", "Tài khoản đã bị khóa...");
    return;
}

// Dòng 243-250: Validate dữ liệu bắt buộc
// Dòng 252-256: Parse dữ liệu + upload ảnh
// Dòng 272-280: Tạo object Items và set giá trị

// Dòng 282-288: BOT QUÉT NỘI DUNG
String violation = util.ContentFilter.scan(item.getTitle(), item.getDescription());
if (violation != null) {
    item.setStatus("processing");  // ẨN bài → chờ admin duyệt
} else {
    item.setStatus("active");      // HIỂN THỊ bình thường
}

// Dòng 290-291: Lưu vào DB
ItemDAO dao = new ItemDAO();
boolean inserted = dao.insertItemByType(item, reportType);
```

**Servlet mapping:** Cùng 1 controller xử lý cả 2 URL:
- `/report_lost` → type = "lost" (web.xml dòng 94-96)
- `/report_found` → type = "found" (web.xml dòng 97-100)

---

### 4.7. MODULE BÁO CÁO VI PHẠM (Report)

**File Controller:** [ReportController.java](file:///d:/prj301/lost-found/src/java/controller/ReportController.java) — `@WebServlet("/report_item")`

**`doPost()` (dòng 21-101):**
```java
// Dòng 48: Kiểm tra user đã báo cáo bài này chưa (tránh spam)
if (msgDao.hasUserReportedItem(currentUser.getUserId(), itemId)) { return; }

// Dòng 62-67: Lưu báo cáo vào bảng Message với title = "[REPORT] Tên người báo cáo"
msgDao.insertMessage(currentUser.getUserId(), itemId, "[REPORT] " + fullName, reason);

// Dòng 70-74: TỰ ĐỘNG ẨN nếu ≥ 3 người báo cáo khác nhau
int reportCount = msgDao.countReportsByItemId(itemId);
if (reportCount >= 3) {
    itemDao.updateItemStatus(itemId, "processing");  // Chuyển sang "processing" → Admin duyệt
}

// Dòng 76-87: TỰ ĐỘNG KHÓA TÀI KHOẢN chủ bài viết nếu tổng report ≥ 3
int totalOwnerReports = msgDao.countTotalReportsByUserId(ownerId);
if (totalOwnerReports >= 3) {
    uDao.updateUserRoleAndStatus(ownerId, owner.getRole(), false);  // isActive = false
    msgDao.insertAccountNotification(ownerId, "Account", "Tài khoản bị khóa tự động...");
}
```

**File Admin:** [AdminModerationController.java](file:///d:/prj301/lost-found/src/java/controller/AdminModerationController.java) — `@WebServlet("/admin/moderation")`
- `doGet()`: Lấy danh sách bài bị ẩn (`status = 'processing'`) + bài bị báo cáo (còn `status = 'active'`)
- `doPost()`: Admin có 3 hành động: **Giữ lại bài** (approve), **Xóa bài** (delete), **Blacklist SĐT** (blacklist)

---

### 4.8. MODULE BỘ LỌC NỘI DUNG TỰ ĐỘNG (Content Filter Bot)

**File:** [ContentFilter.java](file:///d:/prj301/lost-found/src/java/util/ContentFilter.java)

```java
// Dòng 41-61: Method scan() — quét tiêu đề + mô tả bài viết
public static String scan(String title, String description) {
    String combined = (title + " " + description).toLowerCase();

    // 1. Kiểm tra từ cấm (load từ badwords.txt)
    for (String word : BAD_WORDS) {
        if (combined.contains(word.toLowerCase())) {
            return "Noi dung chua tu ngữ khong phu hop: " + word;
        }
    }

    // 2. Kiểm tra SĐT blacklist (load từ blacklist_phones.txt)
    String phonesInText = extractPhones(combined);
    if (phonesInText != null) {
        return "So dien thoai nam trong danh sach blacklist: " + phonesInText;
    }

    return null; // Nội dung sạch
}
```

**Dữ liệu lọc được lưu trữ trong file text:**
- [badwords.txt](file:///d:/prj301/lost-found/src/java/badwords.txt) — Danh sách từ cấm
- [blacklist_phones.txt](file:///d:/prj301/lost-found/src/java/blacklist_phones.txt) — Danh sách SĐT bị chặn
- Admin có thể thêm/xóa qua giao diện tại trang [blacklist.jsp](file:///d:/prj301/lost-found/web/WEB-INF/views/admin/blacklist.jsp)

---

### 4.9. MODULE KẾT NỐI CSDL (Database)

**File:** [DBContext.java](file:///d:/prj301/lost-found/src/java/dal/DBContext.java) (dòng 21-42)
```java
public class DBContext {
    protected Connection connection;
    public DBContext() {
        // Đọc cấu hình từ ConnectDB.properties
        Properties properties = new Properties();
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream("ConnectDB.properties");
        properties.load(inputStream);

        String user = properties.getProperty("userID");   // sa
        String pass = properties.getProperty("password");  // 123
        String url  = properties.getProperty("url");       // jdbc:sqlserver://localhost:1433;databaseName=...

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        connection = DriverManager.getConnection(url, user, pass);
    }
}
```

**File cấu hình:** [ConnectDB.properties](file:///d:/prj301/lost-found/src/java/ConnectDB.properties)
```properties
url=jdbc:sqlserver://localhost:1433;databaseName=Project_PRJ301_DB;trustServerCertificate=true
userID=sa
password=123
```

**Tất cả DAO đều kế thừa DBContext:**
```java
public class UserDAO extends DBContext { ... }
public class ItemDAO extends DBContext { ... }
public class MessageDAO extends DBContext { ... }
// → Khi new UserDAO() → constructor DBContext() tự động tạo connection
```

---

### 4.10. PHÂN QUYỀN (Authorization Filter)

**File:** [AuthorizationFilter.java](file:///d:/prj301/lost-found/src/java/controller/AuthorizationFilter.java)

**Cơ chế hoạt động (6 bước tuần tự):**

| Bước | Dòng | Mô tả |
|---|---|---|
| 1 | 35-38 | Cho pass tài nguyên tĩnh: `/assets/`, `/uploads/` |
| 2 | 41-85 | Set unread notification count (Admin có cơ chế track riêng bằng session) |
| 3 | 89-93 | Cho pass trang public: `/login`, `/register`, `/home`, `/items`, `/item_detail` |
| 4 | 96-99 | Chặn user chưa đăng nhập → redirect `/login` |
| 5 | 104-111 | Chặn student truy cập trang admin (`/manage_*`, `/update*`, `/delete*`, `/add*`, `/admin/*`) |
| 6 | 114 | Pass cho user đã xác thực |

---

### 4.11. YÊU CẦU NHẬN ĐỒ (Claim System)

**File Controller:** [itemDetailController.java](file:///d:/prj301/lost-found/src/java/controller/itemDetailController.java)

- `handleRespondClaim()` (dòng 217-241): Chủ bài "found" duyệt/từ chối yêu cầu nhận đồ
- `handleOwnerRequestLost()` (dòng 243-270): Chủ bài "lost" yêu cầu nhận lại đồ từ người tìm thấy
- `handleFinderRespondLost()` (dòng 272-302): Người tìm thấy đồng ý/từ chối trả đồ

**File DAO:** [ClaimDAO.java](file:///d:/prj301/lost-found/src/java/dal/ClaimDAO.java) — CRUD bảng Claims

---

### 4.12. CUSTOM JSP TAG FILES

**Thư mục:** [/WEB-INF/tags/](file:///d:/prj301/lost-found/web/WEB-INF/tags)

| Tag | File | Mô tả |
|---|---|---|
| `<lf:navbar>` | [navbar.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/navbar.tag) | Thanh điều hướng + notification bell + responsive menu |
| `<lf:userMenu>` | [userMenu.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/userMenu.tag) | Dropdown menu user + chuông thông báo + badge |
| `<lf:footer>` | [footer.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/footer.tag) | Footer trang |
| `<lf:avatar>` | [avatar.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/avatar.tag) | Hiển thị avatar (có ảnh hoặc chữ cái đầu) |
| `<lf:statusBadge>` | [statusBadge.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/statusBadge.tag) | Badge trạng thái bài viết |
| `<lf:typeBadge>` | [typeBadge.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/typeBadge.tag) | Badge loại tin (lost/found) |
| `<lf:emptyState>` | [emptyState.tag](file:///d:/prj301/lost-found/web/WEB-INF/tags/emptyState.tag) | Hiển thị trạng thái danh sách trống |

---

## 5. BẢNG TỔNG HỢP SERVLET MAPPING

| URL Pattern | Controller | HTTP Method | Mô tả |
|---|---|---|---|
| `/login` | loginController | GET: hiển thị form, POST: xử lý đăng nhập | |
| `/register` | registerController | GET: hiển thị form, POST: xử lý đăng ký | |
| `/logout` | logoutController | GET: hủy session, redirect home | |
| `/home` | homeController | GET: load trang chủ + danh sách bài mới nhất | |
| `/items` | listPublicItemsController | GET: danh sách tất cả bài đăng (có filter/search) | |
| `/item_detail?id=X` | itemDetailController | GET: xem chi tiết, POST: comment/reply/claim | |
| `/report_lost` | reportLostController | GET: form báo mất, POST: lưu bài mất | |
| `/report_found` | reportLostController | GET: form báo nhặt, POST: lưu bài nhặt | |
| `/edit_item` | editItemController | GET: form sửa, POST: cập nhật bài | |
| `/my_items` | myItemsController | GET: danh sách bài của tôi | |
| `/inbox` | inboxController | GET: trang hòm thư | |
| `/edit_profile` | editProfileController | GET: form sửa profile, POST: cập nhật + avatar | |
| `/report_item` | ReportController | POST: báo cáo vi phạm bài viết | |
| `/support` | SupportController | GET: form gửi hỗ trợ, POST: lưu yêu cầu | |
| `/user_detail?id=X` | userDetailController | GET: popup thông tin user (SĐT, avatar) | |
| `/admin/moderation` | AdminModerationController | GET: trang kiểm duyệt, POST: approve/delete/blacklist | |
| `/admin/support` | AdminSupportController | GET: danh sách yêu cầu hỗ trợ, POST: xử lý | |
| `/admin/blacklist` | AdminBlacklistController | GET: quản lý blacklist, POST: thêm/xóa | |
| `/admin/data` | AdminDataManagementController | GET: trang thống kê dữ liệu | |
| `/manage_*`, `/add*`, `/update*`, `/delete*` | List/Add/Update/Delete Controllers | CRUD Admin cho Users, Categories, Locations, Claims, Items | |
| `/mark_read` | MarkNotificationReadController | POST: đánh dấu 1 thông báo đã đọc | |
| `/mark_all_read` | MarkAllNotificationsReadController | POST: đánh dấu tất cả thông báo đã đọc | |

---

## 6. CÁC BẢNG CSDL CHÍNH

| Bảng | Mô tả | Các cột quan trọng |
|---|---|---|
| `Users` | Tài khoản người dùng | user_id, username, password, full_name, email, phone_number, avatar_url, role, is_active |
| `Items` | Bài đăng mất/nhặt đồ | item_id, user_id, category_id, location_id, title, description, images, status, type, date_incident, location_details |
| `Message` | Comment, Reply, Notification, Report | message_id, user_id, title, message, is_read, related_item_id, parent_id, sender_id |
| `Claims` | Yêu cầu nhận đồ | claim_id, item_id, claimer_id, status, message |
| `Categories` | Danh mục đồ vật | category_id, name |
| `Locations` | Khu vực/Vị trí | location_id, name |
| `SupportRequests` | Yêu cầu hỗ trợ từ user | id, user_id, subject, message, status |

---

## 7. CÔNG NGHỆ SỬ DỤNG

| Thành phần | Công nghệ |
|---|---|
| **Ngôn ngữ** | Java 17 |
| **Web Server** | Apache Tomcat 10.1.54 (Jakarta EE) |
| **IDE** | NetBeans 17 |
| **CSDL** | Microsoft SQL Server (JDBC Driver 13.2) |
| **Front-end** | JSP + JSTL + Bootstrap 5.3 + Custom CSS + Vanilla JS |
| **Font** | Google Fonts Inter |
| **Cấu hình** | ConnectDB.properties (classpath resource) |
| **Build** | Apache Ant (via NetBeans) |
