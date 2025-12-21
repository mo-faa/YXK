package com.village.committee.web.admin;

import com.village.committee.service.AnnouncementService;
import com.village.committee.service.ResidentService;
import java.time.LocalDate;
import java.time.LocalDateTime;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    private final ResidentService residentService;
    private final AnnouncementService announcementService;

    public AdminDashboardController(ResidentService residentService, AnnouncementService announcementService) {
        this.residentService = residentService;
        this.announcementService = announcementService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("residentTotal", residentService.countAll());
        model.addAttribute("announcementTotal", announcementService.countAll());
        model.addAttribute("announcementNewThisMonth", announcementService.countThisMonth());

        LocalDateTime monthStart = LocalDate.now().withDayOfMonth(1).atStartOfDay();
        model.addAttribute("residentNewThisMonth", residentService.countSince(monthStart));

        model.addAttribute("announcements", announcementService.latest(5));
        return "admin/dashboard";
    }
}
