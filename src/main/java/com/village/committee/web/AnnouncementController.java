package com.village.committee.web;

import com.village.committee.common.PageResult;
import com.village.committee.domain.Announcement;
import com.village.committee.service.AnnouncementService;
import com.village.committee.service.OperationLogService;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/announcements")
public class AnnouncementController {

    private final AnnouncementService announcementService;
    private final OperationLogService operationLogService;

    public AnnouncementController(AnnouncementService announcementService,
                                  OperationLogService operationLogService) {
        this.announcementService = announcementService;
        this.operationLogService = operationLogService;
    }

    @GetMapping
    public String list(Model model,
                       @RequestParam(value = "q", required = false) String q,
                       @RequestParam(value = "page", required = false) Integer page,
                       @RequestParam(value = "size", required = false) Integer size,
                       @ModelAttribute("flash") String flash) {

        PageResult<Announcement> result = announcementService.page(q, page, size);

        // 兼容 list.jsp 里使用 ${announcements}
        model.addAttribute("announcements", result.getItems());

        model.addAttribute("page", result);
        model.addAttribute("q", q);
        return "announcements/list";
    }

    @GetMapping("/new")
    public String createForm(ModelMap model) {
        // 支持 redirect 后的 flash 回填（若之前校验失败带回 announcement）
        if (!model.containsAttribute("announcement")) {
            Announcement announcement = new Announcement();
            announcement.setPublishTime(LocalDateTime.now());
            announcement.setStatus(1); // 默认发布状态
            announcement.setIsTop(false);
            model.addAttribute("announcement", announcement);
        } else {
            Object obj = model.get("announcement");
            if (obj instanceof Announcement a) {
                if (a.getPublishTime() == null) a.setPublishTime(LocalDateTime.now());
                if (a.getStatus() == null) a.setStatus(1);
                if (a.getIsTop() == null) a.setIsTop(false);
            }
        }

        model.addAttribute("mode", "create");
        return "announcements/form";
    }

    /**
     * ✅ 关键修复：补上详情页 GET 映射
     * 这样 /announcements/1 不会再 405，也不会再返回 JSON
     */
    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Long id, Model model) {
        Announcement a = announcementService.get(id);
        if (a == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Announcement not found: " + id);
        }
        model.addAttribute("announcement", a);
        return "announcements/detail";
    }

    @PostMapping
    public String create(@ModelAttribute Announcement announcement,
                         @RequestParam(value = "publishTime", required = false) String publishTimeStr,
                         RedirectAttributes ra,
                         HttpServletRequest request) {

        parsePublishTime(announcement, publishTimeStr);

        String error = announcementService.validateAndGetError(announcement);
        if (error != null) {
            ra.addFlashAttribute("flash", error);
            ra.addFlashAttribute("flashType", "danger");
            ra.addFlashAttribute("announcement", announcement);
            return "redirect:/announcements/new";
        }

        try {
            Announcement created = announcementService.create(announcement);
            operationLogService.log(request, "CREATE", "ANNOUNCEMENT", created.getId(),
                    "新增公告: " + created.getTitle());
            ra.addFlashAttribute("flash", "发布成功，ID=" + created.getId());
            ra.addFlashAttribute("flashType", "success");
        } catch (ResponseStatusException e) {
            ra.addFlashAttribute("flash", e.getReason());
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/announcements/new";
        }

        return "redirect:/announcements";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable("id") Long id, Model model) {
        Announcement a = announcementService.get(id);
        if (a == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Announcement not found: " + id);
        }
        model.addAttribute("announcement", a);
        model.addAttribute("mode", "edit");
        return "announcements/form";
    }

    @PostMapping("/{id}")
    public String update(@PathVariable("id") Long id,
                         @ModelAttribute Announcement announcement,
                         @RequestParam(value = "publishTime", required = false) String publishTimeStr,
                         RedirectAttributes ra,
                         HttpServletRequest request) {

        parsePublishTime(announcement, publishTimeStr);

        String error = announcementService.validateAndGetError(announcement);
        if (error != null) {
            ra.addFlashAttribute("flash", error);
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/announcements/" + id + "/edit";
        }

        try {
            boolean ok = announcementService.update(id, announcement);
            if (!ok) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Announcement not found: " + id);
            }
            operationLogService.log(request, "UPDATE", "ANNOUNCEMENT", id,
                    "更新公告: " + announcement.getTitle());
            ra.addFlashAttribute("flash", "修改成功，ID=" + id);
            ra.addFlashAttribute("flashType", "success");
        } catch (ResponseStatusException e) {
            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
                throw e;
            }
            ra.addFlashAttribute("flash", e.getReason());
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/announcements/" + id + "/edit";
        }

        return "redirect:/announcements";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable("id") Long id,
                         RedirectAttributes ra,
                         HttpServletRequest request) {
        Announcement a = announcementService.get(id);
        if (a == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Announcement not found: " + id);
        }

        boolean ok = announcementService.delete(id);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Announcement not found: " + id);
        }

        operationLogService.log(request, "DELETE", "ANNOUNCEMENT", id,
                "删除公告: " + a.getTitle());
        ra.addFlashAttribute("flash", "删除成功，ID=" + id);
        ra.addFlashAttribute("flashType", "success");
        return "redirect:/announcements";
    }

    /**
     * 解析发布时间字符串
     */
    private void parsePublishTime(Announcement announcement, String publishTimeStr) {
        if (publishTimeStr != null && !publishTimeStr.trim().isEmpty()) {
            try {
                // HTML datetime-local 格式: yyyy-MM-ddTHH:mm
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                announcement.setPublishTime(LocalDateTime.parse(publishTimeStr.trim(), formatter));
            } catch (DateTimeParseException e) {
                try {
                    DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    announcement.setPublishTime(LocalDateTime.parse(publishTimeStr.trim(), formatter2));
                } catch (DateTimeParseException e2) {
                    announcement.setPublishTime(LocalDateTime.now());
                }
            }
        } else {
            announcement.setPublishTime(LocalDateTime.now());
        }
    }
}
