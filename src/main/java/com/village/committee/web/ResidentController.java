package com.village.committee.web;

import com.village.committee.common.PageResult;
import com.village.committee.domain.Resident;
import com.village.committee.service.ResidentService;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;
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
    public String list(Model model,
                       @RequestParam(value = "q", required = false) String q,
                       @RequestParam(value = "page", required = false) Integer page,
                       @RequestParam(value = "size", required = false) Integer size,
                       @ModelAttribute("flash") String flash) {

        PageResult<Resident> result = residentService.page(q, page, size);
        model.addAttribute("page", result);
        model.addAttribute("q", q);
        return "residents/list";
    }

    @GetMapping(value = "/export.csv")
    public void exportCsv(@RequestParam(value = "q", required = false) String q,
                          HttpServletResponse resp) {
        try {
            List<Resident> rows = residentService.export(q);

            resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
            resp.setContentType("text/csv; charset=UTF-8");
            resp.setHeader("Content-Disposition", "attachment; filename=\"residents.csv\"");

            try (PrintWriter w = resp.getWriter()) {
                // UTF-8 BOM (Excel 兼容)
                w.write('\uFEFF');

                w.println("id,name,idCard,phone,address,createdAt");
                for (Resident r : rows) {
                    w.print(csv(r.getId()));
                    w.print(",");
                    w.print(csv(r.getName()));
                    w.print(",");
                    w.print(csv(r.getIdCard()));
                    w.print(",");
                    w.print(csv(r.getPhone()));
                    w.print(",");
                    w.print(csv(r.getAddress()));
                    w.print(",");
                    w.println(csv(r.getCreatedAt()));
                }
                w.flush();
            }
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "CSV export failed: " + ex.getMessage(), ex);
        }
    }

    private String csv(Object v) {
        if (v == null) return "";
        String s = String.valueOf(v);
        boolean needQuote = s.contains(",") || s.contains("\"") || s.contains("\n") || s.contains("\r");
        if (!needQuote) return s;
        return "\"" + s.replace("\"", "\"\"") + "\"";
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
