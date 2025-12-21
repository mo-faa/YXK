package com.village.committee.mapper;

import com.village.committee.domain.OperationLog;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface OperationLogMapper {

    @Insert("""
            INSERT INTO operation_logs (operator, operation_type, target_type, target_id, description, ip_address, user_agent, created_at)
            VALUES (#{operator}, #{operationType}, #{targetType}, #{targetId}, #{description}, #{ipAddress}, #{userAgent}, #{createdAt})
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(OperationLog operationLog);

    @Select("SELECT * FROM operation_logs ORDER BY created_at DESC")
    List<OperationLog> findAll();

    @Select("SELECT * FROM operation_logs WHERE id = #{id}")
    OperationLog findById(@Param("id") Long id);

    @Select("""
            <script>
            SELECT * FROM operation_logs
            <where>
                <if test="q != null and q != ''">
                    AND (operator LIKE CONCAT('%', #{q}, '%')
                         OR operation_type LIKE CONCAT('%', #{q}, '%')
                         OR target_type LIKE CONCAT('%', #{q}, '%')
                         OR description LIKE CONCAT('%', #{q}, '%'))
                </if>
                <if test="operationType != null and operationType != ''">
                    AND operation_type = #{operationType}
                </if>
                <if test="targetType != null and targetType != ''">
                    AND target_type = #{targetType}
                </if>
            </where>
            ORDER BY created_at DESC
            LIMIT #{offset}, #{limit}
            </script>
            """)
    List<OperationLog> findPage(@Param("q") String q,
                                 @Param("operationType") String operationType,
                                 @Param("targetType") String targetType,
                                 @Param("offset") int offset,
                                 @Param("limit") int limit);

    @Select("""
            <script>
            SELECT COUNT(*) FROM operation_logs
            <where>
                <if test="q != null and q != ''">
                    AND (operator LIKE CONCAT('%', #{q}, '%')
                         OR operation_type LIKE CONCAT('%', #{q}, '%')
                         OR target_type LIKE CONCAT('%', #{q}, '%')
                         OR description LIKE CONCAT('%', #{q}, '%'))
                </if>
                <if test="operationType != null and operationType != ''">
                    AND operation_type = #{operationType}
                </if>
                <if test="targetType != null and targetType != ''">
                    AND target_type = #{targetType}
                </if>
            </where>
            </script>
            """)
    long count(@Param("q") String q,
               @Param("operationType") String operationType,
               @Param("targetType") String targetType);

    @Select("SELECT * FROM operation_logs ORDER BY created_at DESC LIMIT #{limit}")
    List<OperationLog> findLatest(@Param("limit") int limit);

    @Select("SELECT COUNT(*) FROM operation_logs WHERE created_at >= #{from}")
    long countSince(@Param("from") LocalDateTime from);

    @Select("SELECT DISTINCT operation_type FROM operation_logs ORDER BY operation_type")
    List<String> findDistinctOperationTypes();

    @Select("SELECT DISTINCT target_type FROM operation_logs ORDER BY target_type")
    List<String> findDistinctTargetTypes();
}
