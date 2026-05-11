package com.village.committee.domain;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class User {
    private Long id;
    private String username;
    private String passwordHash;
    private String nickname;
    private String realName;
    private String phone;
    private String email;
    private String avatar;
    private Boolean enabled;
    private Integer loginCount;
    private LocalDateTime lastLoginAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public User() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getRealName() { return realName; }
    public void setRealName(String realName) { this.realName = realName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public Boolean isEnabled() { return enabled != null ? enabled : true; }
    public void setEnabled(Boolean enabled) { this.enabled = enabled; }

    public String getStatusText() { return (enabled != null && enabled) ? "启用" : "禁用"; }
    public String getEnabledClass() { return (enabled != null && enabled) ? "bg-success" : "bg-secondary"; }

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final DateTimeFormatter DATETIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public String getLastLoginAtFormatted() { return lastLoginAt != null ? lastLoginAt.format(DATE_FORMAT) : ""; }
    public String getCreatedAtFormatted() { return createdAt != null ? createdAt.format(DATETIME_FORMAT) : ""; }

    public Integer getLoginCount() { return loginCount != null ? loginCount : 0; }
    public void setLoginCount(Integer loginCount) { this.loginCount = loginCount; }

    public LocalDateTime getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(LocalDateTime lastLoginAt) { this.lastLoginAt = lastLoginAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
