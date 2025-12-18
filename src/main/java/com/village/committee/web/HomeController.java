package com.village.committee.web;

import com.village.committee.service.AnnouncementService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    private final AnnouncementService announcementService;

    public HomeController(AnnouncementService announcementService) {
        this.announcementService = announcementService;
    }

    @GetMapping(value = {"/", "/home"})
    public String home(Model model) {
        model.addAttribute("message", "欢迎使用网上村委会业务办理系统");
        model.addAttribute("announcements", announcementService.list());
        return "home"; // 直接返回home.jsp
    }
}
