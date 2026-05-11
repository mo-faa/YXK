package com.village.committee.mapper;

import com.village.committee.domain.User;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserMapper {

    @Select("SELECT * FROM sys_user WHERE id = #{id}")
    User findById(@Param("id") Long id);

    @Select("SELECT * FROM sys_user WHERE username = #{username}")
    User findByUsername(@Param("username") String username);

    @Select("SELECT * FROM sys_user WHERE username = #{username} AND enabled = 1")
    User findEnabledByUsername(@Param("username") String username);

    @Select("SELECT COUNT(*) FROM sys_user")
    long count();

    @Select("SELECT COUNT(*) FROM sys_user")
    int countAll();

    @Select("SELECT COUNT(*) FROM sys_user WHERE DATE(last_login_at) = CURDATE()")
    int countTodayLogins();

    @Select("SELECT * FROM sys_user ORDER BY id LIMIT #{limit}")
    List<User> findLatest(@Param("limit") int limit);

    @Select("<script>" +
            "SELECT * FROM sys_user " +
            "<where>" +
            "  <if test='keyword != null'>" +
            "    AND (username LIKE #{keyword} OR nickname LIKE #{keyword} OR real_name LIKE #{keyword})" +
            "  </if>" +
            "</where>" +
            " ORDER BY id DESC LIMIT #{offset}, #{limit}" +
            "</script>")
    List<User> findWithPaging(Map<String, Object> params);

    @Select("<script>" +
            "SELECT COUNT(*) FROM sys_user " +
            "<where>" +
            "  <if test='keyword != null and keyword != \"\"'>" +
            "    AND (username LIKE #{keyword} OR nickname LIKE #{keyword} OR real_name LIKE #{keyword})" +
            "  </if>" +
            "</where>" +
            "</script>")
    int countWithKeyword(@Param("keyword") String keyword);

    @Insert("INSERT INTO sys_user (username, password_hash, nickname, real_name, phone, email, avatar, enabled, created_at) " +
            "VALUES (#{username}, #{passwordHash}, #{nickname}, #{realName}, #{phone}, #{email}, #{avatar}, #{enabled}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);

    @Update("UPDATE sys_user SET nickname = #{nickname}, real_name = #{realName}, phone = #{phone}, email = #{email}, " +
            "avatar = #{avatar}, updated_at = NOW() WHERE id = #{id}")
    int update(User user);

    @Update("UPDATE sys_user SET login_count = login_count + 1, last_login_at = NOW() WHERE id = #{id}")
    int updateLoginInfo(@Param("id") Long id);

    @Update("UPDATE sys_user SET password_hash = #{passwordHash}, updated_at = NOW() WHERE id = #{id}")
    int updatePassword(@Param("id") Long id, @Param("passwordHash") String passwordHash);

    @Update("UPDATE sys_user SET enabled = #{enabled} WHERE id = #{id}")
    int updateEnabled(@Param("id") Long id, @Param("enabled") Boolean enabled);

    @Update("UPDATE sys_user SET enabled = #{enabled} WHERE id = #{id}")
    int updateStatus(@Param("id") Long id, @Param("enabled") Boolean enabled);

    @Delete("DELETE FROM sys_user WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
}
