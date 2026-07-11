package model;

import java.util.Date;

public class Items {

    private int itemId;
    private int userId;
    private int categoryId;
    private int locationId;
    private String title;
    private String description;
    private String type;
    private String status;
    private String imagesJSON;
    private String categoryName;
    private String locationName;
    private String ownerFullName;
    private Date dateIncident;
    private Date createdAt;
    private Date updatedAt;

    public Items() {
    }

    public Items(int itemId, int userId, int categoryId, int locationId, String title, String description, String type, String status, String imagesJSON, Date dateIncident, Date createdAt, Date updatedAt) {
        this.itemId = itemId;
        this.userId = userId;
        this.categoryId = categoryId;
        this.locationId = locationId;
        this.title = title;
        this.description = description;
        this.type = type;
        this.status = status;
        this.imagesJSON = imagesJSON;
        this.dateIncident = dateIncident;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getLocationId() {
        return locationId;
    }

    public void setLocationId(int locationId) {
        this.locationId = locationId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImagesJSON() {
        return imagesJSON;
    }

    public void setImagesJSON(String imagesJSON) {
        this.imagesJSON = imagesJSON;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public String getOwnerFullName() {
        return ownerFullName;
    }

    public void setOwnerFullName(String ownerFullName) {
        this.ownerFullName = ownerFullName;
    }

    public Date getDateIncident() {
        return dateIncident;
    }

    public void setDateIncident(Date dateIncident) {
        this.dateIncident = dateIncident;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Items{" + "itemId=" + itemId + ", userId=" + userId + ", categoryId=" + categoryId + ", locationId=" + locationId + ", title=" + title + ", description=" + description + ", type=" + type + ", status=" + status + ", imagesJSON=" + imagesJSON + ", dateIncident=" + dateIncident + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }

   
}
