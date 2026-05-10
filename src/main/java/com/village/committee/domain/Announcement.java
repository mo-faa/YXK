package com.village.committee.domain;

import java.time.LocalDateTime;

public class Announcement {

    private Long id;
    private String title;
    private String content;
    private String publisher;
    private LocalDateTime publishTime;
    private Boolean isTop;
    private Integer status; // 0-草稿, 1-发布

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public LocalDateTime getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(LocalDateTime publishTime) {
        this.publishTime = publishTime;
    }

    public Boolean getIsTop() {
        return isTop;
    }

    public void setIsTop(Boolean isTop) {
        this.isTop = isTop;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    /**
     * 是否已发布
     */
    public boolean isPublished() {
        return status != null && status == 1;
    }

    /**
     * 状态文本
     */
    public String getStatusText() {
        if (status == null || status == 0) {
            return "草稿";
        }
        return "已发布";
    }
}
