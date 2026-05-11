package com.village.committee.mapper;

import com.village.committee.domain.Permission;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface PermissionMapper {

    @Select("SELECT DISTINCT p.* FROM sys_permission p " +
            "INNER JOIN sys_role_permission rp ON p.id = rp.permission_id " +
            "INNER JOIN sys_user_role ur ON rp.role_id = ur.role_id " +
            "WHERE ur.user_id = #{userId} ORDER BY p.module, p.code")
    List<Permission> findByUserId(@Param("userId") Long userId);

    @Select("SELECT * FROM sys_permission WHERE module = #{module} ORDER BY code")
    List<Permission> findByModule(@Param("module") String module);

    @Select("SELECT * FROM sys_permission ORDER BY module, code")
    List<Permission> findAll();
}
