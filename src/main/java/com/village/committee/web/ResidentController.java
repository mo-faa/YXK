package com.village.committee.web;

import com.village.committee.domain.Resident;
import com.village.committee.service.ResidentService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/residents")
public class ResidentController {

    private final ResidentService residentService;

    public ResidentController(ResidentService residentService) {
        this.residentService = residentService;
    }

    @GetMapping
    public String list(Model model, @ModelAttribute("flash") String flash) {
        model.addAttribute("residents", residentService.list());
        return "residents/list";
    }

    @GetMapping("/new")
    public String createForm(Model model) {
        model.addAttribute("resident", new Resident());
        model.addAttribute("mode", "create");
        return "residents/form";
    }

    @PostMapping
    public String create(@ModelAttribute Resident resident, RedirectAttributes ra) {
        if (resident.getName() == null || resident.getName().trim().isEmpty()) {
            ra.addFlashAttribute("flash", "姓名不能为空");
            return "redirect:/residents/new";
        }
        residentService.create(resident);
        ra.addFlashAttribute("flash", "新增成功，ID=" + resident.getId());
        return "redirect:/residents";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable("id") Long id, Model model) {
        Resident r = residentService.get(id);
        if (r == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }
        model.addAttribute("resident", r);
        model.addAttribute("mode", "edit");
        return "residents/form";
    }

    @PostMapping("/{id}")
    public String update(@PathVariable("id") Long id, @ModelAttribute Resident resident, RedirectAttributes ra) {
        if (resident.getName() == null || resident.getName().trim().isEmpty()) {
            ra.addFlashAttribute("flash", "姓名不能为空");
            return "redirect:/residents/" + id + "/edit";
        }
        boolean ok = residentService.update(id, resident);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }
        ra.addFlashAttribute("flash", "修改成功，ID=" + id);
        return "redirect:/residents";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable("id") Long id, RedirectAttributes ra) {
        boolean ok = residentService.delete(id);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }
        ra.addFlashAttribute("flash", "删除成功，ID=" + id);
        return "redirect:/residents";
    }
}
