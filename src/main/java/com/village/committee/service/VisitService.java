
package com.village.committee.service;

import com.village.committee.domain.VisitDailyCount;
import com.village.committee.mapper.VisitMapper;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

/**
 * 访问统计（用于管理控制台图表）
 *
 * 设计目标：
 * - 插入失败不影响正常业务（统计是“尽力而为”）
 * - 查询最近 N 天数据时补齐缺失日期（图表连续）
 */
@Service
public class VisitService {

    private final VisitMapper visitMapper;

    public VisitService(VisitMapper visitMapper) {
        this.visitMapper = visitMapper;
    }

    public void record(String path, String method, int status, long tookMs, String requestId) {
        try {
            visitMapper.insert(path, method, status, tookMs, requestId);
        } catch (Exception ignored) {
            // 统计失败不应影响业务流程
        }
    }

    public List<VisitDailyCount> lastNDays(int days) {
        int d = Math.max(1, Math.min(days, 30)); // 保护：最多查 30 天
        List<VisitDailyCount> raw = visitMapper.countDaily(d - 1);

        Map<LocalDate, Long> map = new HashMap<>();
        for (VisitDailyCount r : raw) {
            map.put(r.date(), r.count());
        }

        LocalDate today = LocalDate.now();
        LocalDate start = today.minusDays(d - 1);

        List<VisitDailyCount> out = new ArrayList<>(d);
        for (int i = 0; i < d; i++) {
            LocalDate day = start.plusDays(i);
            out.add(new VisitDailyCount(day, map.getOrDefault(day, 0L)));
        }
        return out;
    }
}
