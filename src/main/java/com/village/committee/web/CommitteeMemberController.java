package com.village.committee.web;

import com.village.committee.common.PageResult;
import com.village.committee.domain.CommitteeMember;
import com.village.committee.service.CommitteeMemberService;
import com.village.committee.service.OperationLogService;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 村委会成员控制器
 */
@Controller
@RequestMapping("/committee-members")
public class CommitteeMemberController {

    private final CommitteeMemberService committeeMemberService;
    private final OperationLogService operationLogService;

    public CommitteeMemberController(CommitteeMemberService committeeMemberService,
                                     OperationLogService operationLogService) {
        this.committeeMemberService = committeeMemberService;
        this.operationLogService = operationLogService;
    }

    @GetMapping
    public String list(Model model,
                      @RequestParam(value = "q", required = false) String q,
                      @RequestParam(value = "page", required = false) Integer page,
                      @RequestParam(value = "size", required = false) Integer size,
                      @ModelAttribute("flash") String flash) {

        PageResult<CommitteeMember> result = committeeMemberService.page(q, page, size);
        model.addAttribute("page", result);
        model.addAttribute("q", q);
        return "committee-members/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("member", new CommitteeMember());
        model.addAttribute("mode", "create");
        return "committee-members/form";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Long id, Model model) {
        CommitteeMember member = committeeMemberService.get(id);
        if (member == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }
        model.addAttribute("member", member);
        return "committee-members/detail";
    }

    @PostMapping
    public String create(@ModelAttribute CommitteeMember member,
                        @RequestParam(value = "joinTime", required = false) String joinTimeStr,
                        RedirectAttributes ra,
                        HttpServletRequest request) {

        parseJoinTime(member, joinTimeStr);

        String error = committeeMemberService.validateAndGetError(member);
        if (error != null) {
            ra.addFlashAttribute("flash", error);
            ra.addFlashAttribute("flashType", "danger");
            ra.addFlashAttribute("member", member);
            return "redirect:/committee-members/new";
        }

        try {
            CommitteeMember created = committeeMemberService.create(member);
            operationLogService.log(request, "CREATE", "COMMITTEE_MEMBER", created.getId(),
                    "新增村委会成员: " + created.getName() + " (" + created.getPosition() + ")");
            ra.addFlashAttribute("flash", "新增成功，ID=" + created.getId());
            ra.addFlashAttribute("flashType", "success");
        } catch (ResponseStatusException e) {
            ra.addFlashAttribute("flash", e.getReason());
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/committee-members/new";
        }

        return "redirect:/committee-members";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable("id") Long id, Model model) {
        CommitteeMember member = committeeMemberService.get(id);
        if (member == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }
        model.addAttribute("member", member);
        model.addAttribute("mode", "edit");
        return "committee-members/form";
    }

    @PostMapping("/{id}")
    public String update(@PathVariable("id") Long id,
                         @ModelAttribute CommitteeMember member,
                         @RequestParam(value = "joinTime", required = false) String joinTimeStr,
                         RedirectAttributes ra,
                         HttpServletRequest request) {

        parseJoinTime(member, joinTimeStr);

        String error = committeeMemberService.validateAndGetError(member);
        if (error != null) {
            ra.addFlashAttribute("flash", error);
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/committee-members/" + id + "/edit";
        }

        try {
            boolean ok = committeeMemberService.update(id, member);
            if (!ok) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
            }
            operationLogService.log(request, "UPDATE", "COMMITTEE_MEMBER", id,
                    "更新村委会成员: " + member.getName() + " (" + member.getPosition() + ")");
            ra.addFlashAttribute("flash", "修改成功，ID=" + id);
            ra.addFlashAttribute("flashType", "success");
        } catch (ResponseStatusException e) {
            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
                throw e;
            }
            ra.addFlashAttribute("flash", e.getReason());
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/committee-members/" + id + "/edit";
        }

        return "redirect:/committee-members";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable("id") Long id,
                         RedirectAttributes ra,
                         HttpServletRequest request) {
        CommitteeMember member = committeeMemberService.get(id);
        if (member == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }

        boolean ok = committeeMemberService.delete(id);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }

        operationLogService.log(request, "DELETE", "COMMITTEE_MEMBER", id,
                "删除村委会成员: " + member.getName() + " (" + member.getPosition() + ")");
        ra.addFlashAttribute("flash", "删除成功，ID=" + id);
        ra.addFlashAttribute("flashType", "success");
        return "redirect:/committee-members";
    }

    /**
     * 解析任职时间字符串
     */
    private void parseJoinTime(CommitteeMember member, String joinTimeStr) {
        if (joinTimeStr != null && !joinTimeStr.trim().isEmpty()) {
            try {
                // HTML datetime-local 格式: yyyy-MM-ddTHH:mm
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                member.setJoinTime(LocalDateTime.parse(joinTimeStr.trim(), formatter));
            } catch (DateTimeParseException e) {
                try {
                    DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    member.setJoinTime(LocalDateTime.parse(joinTimeStr.trim(), formatter2));
                } catch (DateTimeParseException e2) {
                    member.setJoinTime(LocalDateTime.now());
                }
            }
        } else {
            member.setJoinTime(LocalDateTime.now());
        }
    }
}
