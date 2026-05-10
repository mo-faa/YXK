package com.village.committee.web;

import com.village.committee.service.AnnouncementService;
import com.village.committee.service.CommitteeMemberService;
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
    private final CommitteeMemberService committeeMemberService;

    public HomeController(AnnouncementService announcementService,
                          ResidentService residentService,
                          OperationLogService operationLogService,
                          CommitteeMemberService committeeMemberService) {
        this.announcementService = announcementService;
        this.residentService = residentService;
        this.operationLogService = operationLogService;
        this.committeeMemberService = committeeMemberService;
    }

    @GetMapping(value = {"/", "/home"})
    public String home(Model model) {
        model.addAttribute("message", "欢迎使用网上村委会业务办理系统");

        model.addAttribute("residentTotal", residentService.countAll());
        model.addAttribute("announcementTotal", announcementService.countAll());
        model.addAttribute("memberTotal", committeeMemberService.countAll());
        model.addAttribute("logTotal", operationLogService.countAll());

        model.addAttribute("recentAnnouncements", announcementService.latest(5));
        model.addAttribute("recentLogs", operationLogService.latest(5));

        return "home";
    }
}
