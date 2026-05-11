package com.village.committee.mapper;

import com.village.committee.domain.Notification;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface NotificationMapper {

    @Select("SELECT * FROM notifications WHERE user_id = #{userId} ORDER BY is_read ASC, created_at DESC LIMIT #{limit}")
    List<Notification> findLatestByUserId(@Param("userId") Long userId, @Param("limit") int limit);

    @Select("SELECT * FROM notifications WHERE user_id = #{userId} AND is_read = 0")
    List<Notification> findUnreadByUserId(@Param("userId") Long userId);

    @Select("SELECT COUNT(*) FROM notifications WHERE user_id = #{userId} AND is_read = 0")
    int countUnread(@Param("userId") Long userId);

    @Insert("INSERT INTO notifications (user_id, title, content, type, related_id, related_type) " +
            "VALUES (#{userId}, #{title}, #{content}, #{type}, #{relatedId}, #{relatedType})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Notification notification);

    @Update("UPDATE notifications SET is_read = 1, read_at = NOW() WHERE id = #{id}")
    int markAsRead(@Param("id") Long id);

    @Update("UPDATE notifications SET is_read = 1, read_at = NOW() WHERE user_id = #{userId} AND is_read = 0")
    int markAllAsRead(@Param("userId") Long userId);

    @Delete("DELETE FROM notifications WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
}
