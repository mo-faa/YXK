package com.village.committee.web;

import com.village.committee.service.ExportService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
public class ExportController {

    private final ExportService exportService;

    public ExportController(ExportService exportService) {
        this.exportService = exportService;
    }

    @GetMapping("/export/residents")
    public void exportResidents(HttpServletResponse response) throws IOException {
        byte[] data = exportService.exportResidentsToExcel();
        String filename = "村民信息_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".xlsx";
        writeExcelResponse(response, data, filename);
    }

    @GetMapping("/export/announcements")
    public void exportAnnouncements(HttpServletResponse response) throws IOException {
        byte[] data = exportService.exportAnnouncementsToExcel();
        String filename = "公告列表_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".xlsx";
        writeExcelResponse(response, data, filename);
    }

    @GetMapping("/export/logs")
    public void exportLogs(HttpServletResponse response) throws IOException {
        byte[] data = exportService.exportOperationLogsToExcel();
        String filename = "操作日志_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".xlsx";
        writeExcelResponse(response, data, filename);
    }

    private void writeExcelResponse(HttpServletResponse response, byte[] data, String filename) throws IOException {
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=" + URLEncoder.encode(filename, StandardCharsets.UTF_8));
        response.setContentLength(data.length);
        response.getOutputStream().write(data);
        response.getOutputStream().flush();
    }
}
