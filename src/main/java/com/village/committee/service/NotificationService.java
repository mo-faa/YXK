package com.village.committee.service;

import com.village.committee.domain.Notification;
import com.village.committee.mapper.NotificationMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    private final NotificationMapper notificationMapper;

    public NotificationService(NotificationMapper notificationMapper) {
        this.notificationMapper = notificationMapper;
    }

    public List<Notification> getNotifications(Long userId, int limit) {
        return notificationMapper.findLatestByUserId(userId, limit);
    }

    public List<Notification> getUnreadNotifications(Long userId) {
        return notificationMapper.findUnreadByUserId(userId);
    }

    public int getUnreadCount(Long userId) {
        return notificationMapper.countUnread(userId);
    }

    public Notification createNotification(Long userId, String title, String content,
                                           String type, Long relatedId, String relatedType) {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setType(type != null ? type : "system");
        notification.setRelatedId(relatedId);
        notification.setRelatedType(relatedType);
        notification.setIsRead(false);
        notificationMapper.insert(notification);

        return notification;
    }

    public void markAsRead(Long notificationId) {
        notificationMapper.markAsRead(notificationId);
    }

    public void markAllAsRead(Long userId) {
        notificationMapper.markAllAsRead(userId);
    }

    public void deleteNotification(Long notificationId) {
        notificationMapper.deleteById(notificationId);
    }

    public void sendAnnouncementNotification(Long userId, Long announcementId, String title) {
        createNotification(
                userId,
                "新公告发布",
                "系统发布了新公告：" + title,
                "announcement",
                announcementId,
                "announcement"
        );
    }

    public void sendSystemNotification(Long userId, String title, String content) {
        createNotification(userId, title, content, "system", null, null);
    }
}
