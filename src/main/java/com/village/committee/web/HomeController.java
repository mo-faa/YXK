package com.village.committee.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", "Hello! 这是最小可运行 SSM（Spring 7 + Tomcat 11 + MyBatis）骨架。");
        return "home";
    }
}
