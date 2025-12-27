package com.village.committee.web;

import com.village.committee.service.AnnouncementService;
import com.village.committee.service.OperationLogService;
import com.village.committee.service.ResidentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final AnnouncementService announcementService;
    private final ResidentService residentService;
    private final OperationLogService operationLogService;

    public HomeController(AnnouncementService announcementService,
                          ResidentService residentService,
                          OperationLogService operationLogService) {
        this.announcementService = announcementService;
        this.residentService = residentService;
        this.operationLogService = operationLogService;
    }

    @GetMapping(value = {"/", "/home"})
    public String home(Model model) {
        model.addAttribute("message", "欢迎使用网上村委会业务办理系统");

        model.addAttribute("residentTotal", residentService.countAll());
        model.addAttribute("announcementTotal", announcementService.countAll());

        // 最近公告（用于"最近公告"板块）
        model.addAttribute("recentAnnouncements", announcementService.latest(5));

        // 最近操作日志（用于"最近操作"板块）
        model.addAttribute("recentLogs", operationLogService.latest(5));

        return "home";
    }
}
