package com.village.committee.mapper;

import com.village.committee.domain.Role;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface RoleMapper {

    @Select("SELECT * FROM sys_role WHERE id = #{id}")
    Role findById(@Param("id") Long id);

    @Select("SELECT * FROM sys_role WHERE code = #{code}")
    Role findByCode(@Param("code") String code);

    @Select("SELECT r.* FROM sys_role r " +
            "INNER JOIN sys_user_role ur ON r.id = ur.role_id " +
            "WHERE ur.user_id = #{userId} ORDER BY r.sort_order")
    List<Role> findByUserId(@Param("userId") Long userId);

    @Select("SELECT * FROM sys_role ORDER BY sort_order")
    List<Role> findAll();

    @Insert("INSERT INTO sys_role (code, name, description, sort_order) VALUES (#{code}, #{name}, #{description}, #{sortOrder})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Role role);
}
