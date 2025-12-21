package com.village.committee.web;

import com.village.committee.common.PageResult;
import com.village.committee.domain.OperationLog;
import com.village.committee.service.OperationLogService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@Controller
@RequestMapping("/logs")
public class OperationLogController {

    private final OperationLogService operationLogService;

    public OperationLogController(OperationLogService operationLogService) {
        this.operationLogService = operationLogService;
    }

    @GetMapping
    public String list(Model model,
                       @RequestParam(value = "q", required = false) String q,
                       @RequestParam(value = "operationType", required = false) String operationType,
                       @RequestParam(value = "targetType", required = false) String targetType,
                       @RequestParam(value = "page", required = false) Integer page,
                       @RequestParam(value = "size", required = false) Integer size) {

        PageResult<OperationLog> result = operationLogService.page(q, operationType, targetType, page, size);

        model.addAttribute("page", result);
        model.addAttribute("q", q);
        model.addAttribute("operationType", operationType);
        model.addAttribute("targetType", targetType);
        model.addAttribute("operationTypes", operationLogService.getOperationTypes());
        model.addAttribute("targetTypes", operationLogService.getTargetTypes());

        return "logs/list";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Long id, Model model) {
        OperationLog log = operationLogService.get(id);
        if (log == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Operation log not found: " + id);
        }
        model.addAttribute("log", log);
        return "logs/detail";
    }
}
