package com.village.committee.mapper;

import com.village.committee.domain.Announcement;
import java.time.LocalDateTime;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface AnnouncementMapper {

    @Select("SELECT * FROM announcements ORDER BY is_top DESC, publish_time DESC")
    List<Announcement> findAll();

    @Select("SELECT COUNT(*) FROM announcements")
    long count();

    /**
     * 统计指定时间之后的公告数量
     * 说明：表结构没有 created_at，这里使用 publish_time 作为时间字段
     */
    @Select("SELECT COUNT(*) FROM announcements WHERE publish_time >= #{from}")
    long countSince(@Param("from") LocalDateTime from);

    /**
     * 获取最新的N条公告（已发布）
     */
    @Select("SELECT * FROM announcements WHERE status = 1 ORDER BY is_top DESC, publish_time DESC LIMIT #{limit}")
    List<Announcement> findLatest(@Param("limit") int limit);

    @Select("SELECT * FROM announcements WHERE id = #{id}")
    Announcement findById(@Param("id") Long id);

    @Select("""
        <script>
        SELECT * FROM announcements
        <where>
            <if test="q != null and q != ''">
                AND (title LIKE CONCAT('%', #{q}, '%') OR content LIKE CONCAT('%', #{q}, '%'))
            </if>
        </where>
        ORDER BY is_top DESC, publish_time DESC
        LIMIT #{offset}, #{limit}
        </script>
        """)
    List<Announcement> findPage(@Param("q") String q, @Param("offset") int offset, @Param("limit") int limit);

    @Select("""
        <script>
        SELECT COUNT(*) FROM announcements
        <where>
            <if test="q != null and q != ''">
                AND (title LIKE CONCAT('%', #{q}, '%') OR content LIKE CONCAT('%', #{q}, '%'))
            </if>
        </where>
        </script>
        """)
    long countByQuery(@Param("q") String q);

    /**
     * 新增公告
     * 修复：announcements 表无 created_at 字段，INSERT 去掉 created_at
     * 同时：publishTime 允许为空时用 NOW()（和“留空则使用当前时间”一致）
     */
    @Insert("""
        INSERT INTO announcements (title, content, publisher, publish_time, is_top, status)
        VALUES (#{title}, #{content}, #{publisher}, IFNULL(#{publishTime}, NOW()), #{isTop}, #{status})
        """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Announcement announcement);

    @Update("""
        UPDATE announcements
        SET title = #{title}, content = #{content}, publisher = #{publisher},
            publish_time = #{publishTime}, is_top = #{isTop}, status = #{status}
        WHERE id = #{id}
        """)
    int update(Announcement announcement);

    @Delete("DELETE FROM announcements WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
}
