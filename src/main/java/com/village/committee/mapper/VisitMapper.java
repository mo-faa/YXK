
package com.village.committee.mapper;

import com.village.committee.domain.VisitDailyCount;
import java.util.List;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface VisitMapper {

    @Insert("""
            INSERT INTO visit_events (path, method, status, took_ms, request_id)
            VALUES (#{path}, #{method}, #{status}, #{tookMs}, #{requestId})
            """)
    int insert(@Param("path") String path,
               @Param("method") String method,
               @Param("status") int status,
               @Param("tookMs") long tookMs,
               @Param("requestId") String requestId);

    /**
     * 最近 N 天（含今天）的访问量，按天聚合。
     * daysMinus1 例如：7天 -> 6
     */
    @Select("""
            SELECT DATE(visited_at) AS date, COUNT(*) AS count
            FROM visit_events
            WHERE visited_at >= DATE_SUB(CURDATE(), INTERVAL #{daysMinus1} DAY)
            GROUP BY DATE(visited_at)
            ORDER BY date
            """)
    List<VisitDailyCount> countDaily(@Param("daysMinus1") int daysMinus1);
}
