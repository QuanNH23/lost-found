/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HungKNHE194779
 */
import java.util.Date;

public class Message {

    private int messageId;
    private int userId;
    private String title;
    private String message;
    private boolean isRead;
    private int relatedItemId;
    private Date createdAt;

    public Message() {
    }

    public Message(int messageId, int userId, String title, String message, boolean isRead, int relatedItemId, Date createdAt) {
        this.messageId = messageId;
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.isRead = isRead;
        this.relatedItemId = relatedItemId;
        this.createdAt = createdAt;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    public int getRelatedItemId() {
        return relatedItemId;
    }

    public void setRelatedItemId(int relatedItemId) {
        this.relatedItemId = relatedItemId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Message{" + "messageId=" + messageId + ", userId=" + userId + ", title=" + title + ", message=" + message + ", isRead=" + isRead + ", relatedItemId=" + relatedItemId + ", createdAt=" + createdAt + '}';
    }

    
}

