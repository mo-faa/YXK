// FILE: src/main/java/com/village/committee/web/ResidentController.java

package com.village.committee.web;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.domain.Resident;
import com.village.committee.service.OperationLogService;
import com.village.committee.service.ResidentService;
import jakarta.servlet.http.HttpServletRequest;
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
    private final OperationLogService operationLogService;

    public ResidentController(ResidentService residentService, OperationLogService operationLogService) {
        this.residentService = residentService;
        this.operationLogService = operationLogService;
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
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("text/csv; charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"residents.csv\"");

        try (PrintWriter w = resp.getWriter()) {
            // UTF-8 BOM (Excel 兼容)
            w.write('\uFEFF');
            w.println("id,name,idCard,phone,address,createdAt");

            // 流式查询
            String query = Paging.normalizeQuery(q);
            int batchSize = 1000;
            int offset = 0;

            while (true) {
                List<Resident> batch = residentService.findPage(query, offset, batchSize);
                if (batch.isEmpty()) break;

                for (Resident r : batch) {
                    w.print(csvSafe(r.getId()));
                    w.print(",");
                    w.print(csvSafe(r.getName()));
                    w.print(",");
                    w.print(csvSafe(r.getIdCard()));
                    w.print(",");
                    w.print(csvSafe(r.getPhone()));
                    w.print(",");
                    w.print(csvSafe(r.getAddress()));
                    w.print(",");
                    w.println(csvSafe(r.getCreatedAt()));
                }
                w.flush();
                offset += batchSize;

                // 防止内存占用过大
                if (offset > 100000) break;
            }
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "CSV export failed: " + ex.getMessage(), ex);
        }
    }

    /**
     * CSV 安全转义（防止CSV注入攻击）
     * - 如果值以 =、+、-、@ 开头，添加单引号前缀
     * - 处理逗号、引号、换行
     */
    private String csvSafe(Object v) {
        if (v == null) return "";
        String s = String.valueOf(v);
        if (s.isEmpty()) return "";

        // 防止CSV注入：如果以危险字符开头，添加单引号
        char first = s.charAt(0);
        if (first == '=' || first == '+' || first == '-' || first == '@' || first == '\t' || first == '\r') {
            s = "'" + s;
        }

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
    public String create(@ModelAttribute Resident resident, RedirectAttributes ra, HttpServletRequest request) {
        // 使用Service层验证
        String error = residentService.validateAndGetError(resident);
        if (error != null) {
            ra.addFlashAttribute("flash", error);
            ra.addFlashAttribute("flashType", "danger");
            ra.addFlashAttribute("resident", resident); // 保留用户输入
            return "redirect:/residents/new";
        }

        try {
            Resident created = residentService.create(resident);
            operationLogService.log(request, "CREATE", "RESIDENT", created.getId(), "新增村民: " + created.getName());
            ra.addFlashAttribute("flash", "新增成功，ID=" + created.getId());
            ra.addFlashAttribute("flashType", "success");
        } catch (ResponseStatusException e) {
            ra.addFlashAttribute("flash", e.getReason());
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/residents/new";
        }

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
    public String update(@PathVariable("id") Long id, @ModelAttribute Resident resident, RedirectAttributes ra, HttpServletRequest request) {
        // 使用Service层验证
        String error = residentService.validateAndGetError(resident);
        if (error != null) {
            ra.addFlashAttribute("flash", error);
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/residents/" + id + "/edit";
        }

        try {
            boolean ok = residentService.update(id, resident);
            if (!ok) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
            }
            operationLogService.log(request, "UPDATE", "RESIDENT", id, "更新村民: " + resident.getName());
            ra.addFlashAttribute("flash", "修改成功，ID=" + id);
            ra.addFlashAttribute("flashType", "success");
        } catch (ResponseStatusException e) {
            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
                throw e;
            }
            ra.addFlashAttribute("flash", e.getReason());
            ra.addFlashAttribute("flashType", "danger");
            return "redirect:/residents/" + id + "/edit";
        }

        return "redirect:/residents";
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable("id") Long id, RedirectAttributes ra, HttpServletRequest request) {
        Resident r = residentService.get(id);
        if (r == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }

        boolean ok = residentService.delete(id);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }

        operationLogService.log(request, "DELETE", "RESIDENT", id, "删除村民: " + r.getName());
        ra.addFlashAttribute("flash", "删除成功，ID=" + id);
        ra.addFlashAttribute("flashType", "success");
        return "redirect:/residents";
    }
}
