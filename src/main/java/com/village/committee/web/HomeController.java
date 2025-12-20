package com.village.committee.web;

import com.village.committee.service.AnnouncementService;
import com.village.committee.service.ResidentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final AnnouncementService announcementService;
    private final ResidentService residentService;

    public HomeController(AnnouncementService announcementService, ResidentService residentService) {
        this.announcementService = announcementService;
        this.residentService = residentService;
    }

    @GetMapping(value = {"/", "/home"})
    public String home(Model model) {
        model.addAttribute("message", "欢迎使用网上村委会业务办理系统");

        // 首页统计（动态）
        model.addAttribute("residentTotal", residentService.countAll());
        model.addAttribute("announcementTotal", announcementService.countAll());

        // 首页公告：只查最新 5 条，避免 announcements 表大了拖慢首页
        model.addAttribute("announcements", announcementService.latest(5));
        return "home";
    }
}
