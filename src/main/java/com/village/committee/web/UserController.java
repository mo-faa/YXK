package com.village.committee.web;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.domain.User;
import com.village.committee.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/users")
public class UserController {

    private final AuthService authService;

    public UserController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(required = false) String keyword,
                       Model model) {
        page = Paging.normalizePage(page);
        int pageSize = 10;
        PageResult<User> result = authService.findUsers(page, pageSize, keyword);
        model.addAttribute("users", result.getItems());
        model.addAttribute("paging", result);
        model.addAttribute("keyword", keyword);
        return "users/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model, HttpServletRequest request) {
        User user = authService.findById(id);
        if (user == null) {
            return "redirect:/users";
        }
        model.addAttribute("user", user);
        model.addAttribute("roles", authService.getUserRoles(id));
        model.addAttribute("permissions", authService.getPermissionCodes(id));
        return "users/detail";
    }

    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", authService.findAllRoles());
        return "users/form";
    }

    @PostMapping("/create")
    public String create(@ModelAttribute User user,
                        @RequestParam(required = false) List<Long> roleIds,
                        RedirectAttributes redirectAttributes,
                        HttpServletRequest request) {
        try {
            String operator = (String) request.getSession().getAttribute("username");
            authService.createUser(user, roleIds, operator);
            redirectAttributes.addFlashAttribute("successMessage", "用户创建成功");
            return "redirect:/users";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/users/create";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        User user = authService.findById(id);
        if (user == null) {
            return "redirect:/users";
        }
        model.addAttribute("user", user);
        model.addAttribute("roles", authService.findAllRoles());
        model.addAttribute("userRoles", authService.getUserRoleIds(id));
        return "users/form";
    }

    @PostMapping("/{id}/edit")
    public String update(@PathVariable Long id,
                        @ModelAttribute User user,
                        @RequestParam(required = false) List<Long> roleIds,
                        RedirectAttributes redirectAttributes,
                        HttpServletRequest request) {
        try {
            String operator = (String) request.getSession().getAttribute("username");
            authService.updateUser(id, user, roleIds, operator);
            redirectAttributes.addFlashAttribute("successMessage", "用户更新成功");
            return "redirect:/users/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/users/" + id + "/edit";
        }
    }

    @PostMapping("/{id}/toggle")
    public String toggleStatus(@PathVariable Long id,
                              RedirectAttributes redirectAttributes,
                              HttpServletRequest request) {
        try {
            String operator = (String) request.getSession().getAttribute("username");
            authService.toggleUserStatus(id, operator);
            redirectAttributes.addFlashAttribute("successMessage", "状态更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/users";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id,
                       RedirectAttributes redirectAttributes,
                       HttpServletRequest request) {
        try {
            String operator = (String) request.getSession().getAttribute("username");
            authService.deleteUser(id, operator);
            redirectAttributes.addFlashAttribute("successMessage", "用户删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/users";
    }

    @GetMapping("/{id}/reset-password")
    public String resetPasswordForm(@PathVariable Long id, Model model) {
        User user = authService.findById(id);
        if (user == null) {
            return "redirect:/users";
        }
        model.addAttribute("user", user);
        return "users/reset-password";
    }

    @PostMapping("/{id}/reset-password")
    public String resetPassword(@PathVariable Long id,
                               @RequestParam String newPassword,
                               RedirectAttributes redirectAttributes,
                               HttpServletRequest request) {
        try {
            String operator = (String) request.getSession().getAttribute("username");
            authService.resetPassword(id, newPassword, operator);
            redirectAttributes.addFlashAttribute("successMessage", "密码重置成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/users/" + id;
    }
}
