package com.village.committee.web;

import com.village.committee.service.BackupService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/system")
public class SystemController {

    private final BackupService backupService;

    public SystemController(BackupService backupService) {
        this.backupService = backupService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpServletRequest request) {
        model.addAttribute("systemInfo", backupService.getSystemInfo());
        model.addAttribute("backupRecords", backupService.getRecentBackups(10));
        return "system/dashboard";
    }

    @GetMapping("/backup")
    public String backupList(Model model) {
        model.addAttribute("records", backupService.getAllBackups());
        return "system/backup";
    }

    @PostMapping("/backup/create")
    public String createBackup(@RequestParam(defaultValue = "full") String type,
                              HttpServletRequest request,
                              RedirectAttributes redirectAttributes) {
        try {
            String operator = (String) request.getSession().getAttribute("username");
            backupService.createBackup(type, operator);
            redirectAttributes.addFlashAttribute("successMessage", "备份创建成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "备份失败: " + e.getMessage());
        }
        return "redirect:/system/backup";
    }

    @PostMapping("/backup/{id}/delete")
    public String deleteBackup(@PathVariable Long id,
                              RedirectAttributes redirectAttributes) {
        try {
            backupService.deleteBackup(id);
            redirectAttributes.addFlashAttribute("successMessage", "备份记录删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "删除失败: " + e.getMessage());
        }
        return "redirect:/system/backup";
    }

    @GetMapping("/config")
    public String config(Model model) {
        model.addAttribute("configs", backupService.getAllConfigs());
        return "system/config";
    }

    @PostMapping("/config/update")
    public String updateConfig(@RequestParam String configKey,
                              @RequestParam String configValue,
                              RedirectAttributes redirectAttributes) {
        try {
            backupService.updateConfig(configKey, configValue);
            redirectAttributes.addFlashAttribute("successMessage", "配置更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "更新失败: " + e.getMessage());
        }
        return "redirect:/system/config";
    }
}
