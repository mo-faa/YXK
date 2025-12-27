package com.village.committee.web;

import com.village.committee.service.AnnouncementService;
import com.village.committee.service.CommitteeMemberService;
import com.village.committee.service.OperationLogService;
import com.village.committee.service.ResidentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统监控控制器
 */
@Controller
@RequestMapping("/system")
public class SystemController {

    private final ResidentService residentService;
    private final AnnouncementService announcementService;
    private final CommitteeMemberService committeeMemberService;
    private final OperationLogService operationLogService;

    public SystemController(ResidentService residentService,
                           AnnouncementService announcementService,
                           CommitteeMemberService committeeMemberService,
                           OperationLogService operationLogService) {
        this.residentService = residentService;
        this.announcementService = announcementService;
        this.committeeMemberService = committeeMemberService;
        this.operationLogService = operationLogService;
    }

    /**
     * 系统监控仪表盘
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        // 添加基本统计数据
        model.addAttribute("residentCount", residentService.countAll());
        model.addAttribute("announcementCount", announcementService.countAll());
        model.addAttribute("memberCount", committeeMemberService.countAll());
        model.addAttribute("logCount", operationLogService.countAll());

        return "system/dashboard";
    }

    /**
     * 获取系统统计数据（用于图表）
     */
    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Object> getSystemStats() {
        Map<String, Object> result = new HashMap<>();

        // 操作类型统计
        Map<String, Integer> operationTypes = new HashMap<>();
        operationTypes.put("CREATE", (int) operationLogService.countByOperationType("CREATE"));
        operationTypes.put("UPDATE", (int) operationLogService.countByOperationType("UPDATE"));
        operationTypes.put("DELETE", (int) operationLogService.countByOperationType("DELETE"));
        result.put("operationTypes", operationTypes);

        // 目标类型统计
        Map<String, Integer> targetTypes = new HashMap<>();
        targetTypes.put("RESIDENT", (int) operationLogService.countByTargetType("RESIDENT"));
        targetTypes.put("ANNOUNCEMENT", (int) operationLogService.countByTargetType("ANNOUNCEMENT"));
        targetTypes.put("COMMITTEE_MEMBER", (int) operationLogService.countByTargetType("COMMITTEE_MEMBER"));
        result.put("targetTypes", targetTypes);

        // 最近7天操作统计
        List<Map<String, Object>> recentOperations = operationLogService.getRecentOperationStats(7);
        result.put("recentOperations", recentOperations);

        // 系统信息
        Map<String, Object> systemInfo = new HashMap<>();
        systemInfo.put("currentTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        systemInfo.put("uptime", "5天12小时34分钟"); // 示例数据，实际应从系统获取
        systemInfo.put("memoryUsage", "256MB / 1GB"); // 示例数据，实际应从系统获取
        result.put("systemInfo", systemInfo);

        return result;
    }
}
