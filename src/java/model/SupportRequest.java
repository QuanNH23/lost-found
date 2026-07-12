package model;

import java.util.Date;

public class SupportRequest {
    private int supportId;
    private int userId;
    private String reason;
    private String email;
    private String phone;
    private String imageUrl;
    private String description;
    private String status;
    private String adminFeedback;
    private Date createdAt;
    private boolean isReadByUser;

    public SupportRequest() {
    }

    public SupportRequest(int supportId, int userId, String reason, String email, String phone, String imageUrl, String description, String status, String adminFeedback, Date createdAt, boolean isReadByUser) {
        this.supportId = supportId;
        this.userId = userId;
        this.reason = reason;
        this.email = email;
        this.phone = phone;
        this.imageUrl = imageUrl;
        this.description = description;
        this.status = status;
        this.adminFeedback = adminFeedback;
        this.createdAt = createdAt;
        this.isReadByUser = isReadByUser;
    }

    public int getSupportId() {
        return supportId;
    }

    public void setSupportId(int supportId) {
        this.supportId = supportId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminFeedback() {
        return adminFeedback;
    }

    public void setAdminFeedback(String adminFeedback) {
        this.adminFeedback = adminFeedback;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isIsReadByUser() {
        return isReadByUser;
    }

    public void setIsReadByUser(boolean isReadByUser) {
        this.isReadByUser = isReadByUser;
    }
}
