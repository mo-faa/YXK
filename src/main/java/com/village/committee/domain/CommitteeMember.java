package com.village.committee.domain;

import java.time.LocalDateTime;

/**
 * 村委会成员实体类
 */
public class CommitteeMember {
    private Long id;
    private String name;
    private String position;  // 职务
    private String phone;     // 联系电话
    private String duties;    // 职责描述
    private LocalDateTime joinTime;  // 任职时间
    private Boolean isActive; // 是否在职
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDuties() {
        return duties;
    }

    public void setDuties(String duties) {
        this.duties = duties;
    }

    public LocalDateTime getJoinTime() {
        return joinTime;
    }

    public void setJoinTime(LocalDateTime joinTime) {
        this.joinTime = joinTime;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * 是否在职
     */
    public boolean isActiveMember() {
        return isActive != null && isActive;
    }

    /**
     * 状态文本
     */
    public String getStatusText() {
        if (isActive == null || !isActive) {
            return "离职";
        }
        return "在职";
    }
}
