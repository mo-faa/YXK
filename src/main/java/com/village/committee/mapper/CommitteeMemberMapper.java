package com.village.committee.mapper;

import com.village.committee.domain.CommitteeMember;
import org.apache.ibatis.annotations.*;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 村委会成员数据访问接口
 */
@Mapper
public interface CommitteeMemberMapper {

    /**
     * 查询所有成员
     */
    @Select("SELECT * FROM village_committee.committee_members ORDER BY join_time DESC")
    List<CommitteeMember> findAll();

    /**
     * 根据ID查询成员
     */
    @Select("SELECT * FROM village_committee.committee_members WHERE id = #{id}")
    CommitteeMember findById(Long id);

    /**
     * 查询在职成员
     */
    @Select("SELECT * FROM village_committee.committee_members WHERE is_active = 1 ORDER BY join_time DESC")
    List<CommitteeMember> findActive();

    /**
     * 分页查询成员
     */
    @Select("SELECT * FROM village_committee.committee_members " +
            "WHERE (#{query} IS NULL OR #{query} = '' OR " +
            "name LIKE CONCAT('%', #{query}, '%') OR " +
            "position LIKE CONCAT('%', #{query}, '%') OR " +
            "duties LIKE CONCAT('%', #{query}, '%')) " +
            "ORDER BY join_time DESC " +
            "LIMIT #{offset}, #{limit}")
    List<CommitteeMember> findPage(@Param("query") String query, 
                                   @Param("offset") int offset, 
                                   @Param("limit") int limit);

    /**
     * 统计成员总数
     */
    @Select("SELECT COUNT(*) FROM village_committee.committee_members " +
            "WHERE (#{query} IS NULL OR #{query} = '' OR " +
            "name LIKE CONCAT('%', #{query}, '%') OR " +
            "position LIKE CONCAT('%', #{query}, '%') OR " +
            "duties LIKE CONCAT('%', #{query}, '%'))")
    long count(@Param("query") String query);

    /**
     * 统计指定时间之后的成员数量
     */
    @Select("SELECT COUNT(*) FROM village_committee.committee_members WHERE created_at >= #{from}")
    long countSince(@Param("from") LocalDateTime from);

    /**
     * 插入新成员
     */
    @Insert("INSERT INTO village_committee.committee_members (name, position, phone, duties, join_time, is_active, created_at, updated_at) " +
            "VALUES (#{name}, #{position}, #{phone}, #{duties}, #{joinTime}, #{isActive}, NOW(), NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(CommitteeMember member);

    /**
     * 更新成员信息
     */
    @Update("UPDATE village_committee.committee_members SET " +
            "name = #{name}, " +
            "position = #{position}, " +
            "phone = #{phone}, " +
            "duties = #{duties}, " +
            "join_time = #{joinTime}, " +
            "is_active = #{isActive}, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
    int update(CommitteeMember member);

    /**
     * 删除成员
     */
    @Delete("DELETE FROM village_committee.committee_members WHERE id = #{id}")
    int deleteById(Long id);
}
