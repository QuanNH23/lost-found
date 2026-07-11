package model;

import java.util.Date;

public class Claims {

    private int claimId;
    private int itemId;
    private int claimerId;
    private String status;
    private String proofDescription;
    private String responseMessage;
    private int respondedBy;
    private Date createdAt;
    private Date updatedAt;

    public Claims() {
    }

    public Claims(int claimId, int itemId, int claimerId, String status, String proofDescription, String responseMessage, Integer respondedBy, Date createdAt, Date updatedAt) {
        this.claimId = claimId;
        this.itemId = itemId;
        this.claimerId = claimerId;
        this.status = status;
        this.proofDescription = proofDescription;
        this.responseMessage = responseMessage;
        this.respondedBy = respondedBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getClaimId() {
        return claimId;
    }

    public void setClaimId(int claimId) {
        this.claimId = claimId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getClaimerId() {
        return claimerId;
    }

    public void setClaimerId(int claimerId) {
        this.claimerId = claimerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProofDescription() {
        return proofDescription;
    }

    public void setProofDescription(String proofDescription) {
        this.proofDescription = proofDescription;
    }

    public String getResponseMessage() {
        return responseMessage;
    }

    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }

    public Integer getRespondedBy() {
        return respondedBy;
    }

    public void setRespondedBy(Integer respondedBy) {
        this.respondedBy = respondedBy;
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
        return "Claims{" + "claimId=" + claimId + ", itemId=" + itemId + ", claimerId=" + claimerId + ", status=" + status + ", proofDescription=" + proofDescription + ", responseMessage=" + responseMessage + ", respondedBy=" + respondedBy + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
}