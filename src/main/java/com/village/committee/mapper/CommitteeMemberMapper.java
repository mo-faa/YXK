package com.village.committee.mapper;

import com.village.committee.domain.CommitteeMember;
import org.apache.ibatis.annotations.*;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CommitteeMemberMapper {

    @Select("SELECT * FROM committee_members ORDER BY join_time DESC")
    List<CommitteeMember> findAll();

    @Select("SELECT * FROM committee_members WHERE id = #{id}")
    CommitteeMember findById(Long id);

    @Select("SELECT * FROM committee_members WHERE is_active = 1 ORDER BY join_time DESC")
    List<CommitteeMember> findActive();

    @Select("""
    <script>
    SELECT * FROM committee_members
    <where>
        <if test="query != null and query != ''">
            AND (name LIKE CONCAT('%', #{query}, '%') OR position LIKE CONCAT('%', #{query}, '%') OR duties LIKE CONCAT('%', #{query}, '%'))
        </if>
        <if test="isActive != null">
            AND is_active = #{isActive}
        </if>
    </where>
    ORDER BY join_time DESC
    LIMIT #{offset}, #{limit}
    </script>
    """)
    List<CommitteeMember> findPage(@Param("query") String query,
                                   @Param("isActive") Boolean isActive,
                                   @Param("offset") int offset,
                                   @Param("limit") int limit);

    @Select("""
    <script>
    SELECT COUNT(*) FROM committee_members
    <where>
        <if test="query != null and query != ''">
            AND (name LIKE CONCAT('%', #{query}, '%') OR position LIKE CONCAT('%', #{query}, '%') OR duties LIKE CONCAT('%', #{query}, '%'))
        </if>
        <if test="isActive != null">
            AND is_active = #{isActive}
        </if>
    </where>
    </script>
    """)
    long count(@Param("query") String query, @Param("isActive") Boolean isActive);

    @Select("SELECT COUNT(*) FROM committee_members WHERE created_at >= #{from}")
    long countSince(@Param("from") LocalDateTime from);

    @Insert("INSERT INTO committee_members (name, position, phone, duties, join_time, is_active, created_at, updated_at) " +
            "VALUES (#{name}, #{position}, #{phone}, #{duties}, #{joinTime}, #{isActive}, NOW(), NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(CommitteeMember member);

    @Update("UPDATE committee_members SET " +
            "name = #{name}, " +
            "position = #{position}, " +
            "phone = #{phone}, " +
            "duties = #{duties}, " +
            "join_time = #{joinTime}, " +
            "is_active = #{isActive}, " +
            "updated_at = NOW() " +
            "WHERE id = #{id}")
    int update(CommitteeMember member);

    @Delete("DELETE FROM committee_members WHERE id = #{id}")
    int deleteById(Long id);
}
