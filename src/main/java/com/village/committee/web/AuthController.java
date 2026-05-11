package com.village.committee.web;

import com.village.committee.domain.User;
import com.village.committee.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String error, Model model) {
        if (error != null) model.addAttribute("loginError", "用户名或密码错误");
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password,
                       HttpServletRequest request) {
        try {
            User user = authService.authenticate(username, password);
            if (user == null) return "redirect:/login?error=1";
            request.getSession().setAttribute("currentUser", user);
            request.getSession().setAttribute("userId", user.getId());
            request.getSession().setAttribute("username", user.getUsername());
            request.getSession().setAttribute("permissions", authService.getPermissionCodes(user.getId()));
            return "redirect:/";
        } catch (Exception e) {
            return "redirect:/login?error=1";
        }
    }

    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username, @RequestParam String password,
                          @RequestParam String confirmPassword,
                          @RequestParam(required = false) String nickname,
                          @RequestParam(required = false) String realName) {
        if (!password.equals(confirmPassword)) return "redirect:/register?error=密码不一致";
        try {
            authService.register(username, password, nickname, realName);
            return "redirect:/login?registered=1";
        } catch (RuntimeException e) {
            return "redirect:/register?error=" + java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8);
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:/login";
    }
}
