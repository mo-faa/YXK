package com.village.committee.mapper;

import org.apache.ibatis.annotations.*;

@Mapper
public interface UserRoleMapper {

    @Insert("INSERT INTO sys_user_role (user_id, role_id) VALUES (#{userId}, #{roleId})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(com.village.committee.domain.UserRole userRole);

    @Delete("DELETE FROM sys_user_role WHERE user_id = #{userId}")
    int deleteByUserId(@Param("userId") Long userId);

    @Delete("DELETE FROM sys_user_role WHERE role_id = #{roleId}")
    int deleteByRoleId(@Param("roleId") Long roleId);
}
