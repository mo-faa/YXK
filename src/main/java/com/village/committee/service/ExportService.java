package com.village.committee.service;

import com.village.committee.domain.Announcement;
import com.village.committee.domain.Resident;
import com.village.committee.domain.OperationLog;
import com.village.committee.mapper.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ExportService {

    private final ResidentMapper residentMapper;
    private final AnnouncementMapper announcementMapper;
    private final OperationLogMapper operationLogMapper;

    public ExportService(ResidentMapper residentMapper,
                         AnnouncementMapper announcementMapper,
                         OperationLogMapper operationLogMapper) {
        this.residentMapper = residentMapper;
        this.announcementMapper = announcementMapper;
        this.operationLogMapper = operationLogMapper;
    }

    public byte[] exportResidentsToExcel() throws IOException {
        List<Resident> residents = residentMapper.findAll();

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("村民信息");

            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle dateStyle = createDateStyle(workbook);

            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "姓名", "身份证号", "手机号", "地址", "注册时间"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            int rowNum = 1;
            for (Resident resident : residents) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(resident.getId());
                row.createCell(1).setCellValue(resident.getName());
                row.createCell(2).setCellValue(resident.getIdCard() != null ? resident.getIdCard() : "");
                row.createCell(3).setCellValue(resident.getPhone() != null ? resident.getPhone() : "");
                row.createCell(4).setCellValue(resident.getAddress() != null ? resident.getAddress() : "");
                Cell dateCell = row.createCell(5);
                if (resident.getCreatedAt() != null) {
                    dateCell.setCellValue(resident.getCreatedAt().format(formatter));
                    dateCell.setCellStyle(dateStyle);
                }
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            return out.toByteArray();
        }
    }

    public byte[] exportAnnouncementsToExcel() throws IOException {
        List<Announcement> announcements = announcementMapper.findAll();

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("公告列表");

            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle dateStyle = createDateStyle(workbook);

            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "标题", "发布人", "发布时间", "是否置顶", "状态"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            int rowNum = 1;
            for (Announcement ann : announcements) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(ann.getId());
                row.createCell(1).setCellValue(ann.getTitle());
                row.createCell(2).setCellValue(ann.getPublisher());
                Cell dateCell = row.createCell(3);
                if (ann.getPublishTime() != null) {
                    dateCell.setCellValue(ann.getPublishTime().format(formatter));
                    dateCell.setCellStyle(dateStyle);
                }
                row.createCell(4).setCellValue(ann.getIsTop() ? "是" : "否");
                row.createCell(5).setCellValue(ann.getStatus() == 1 ? "已发布" : "草稿");
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            return out.toByteArray();
        }
    }

    public byte[] exportOperationLogsToExcel() throws IOException {
        List<OperationLog> logs = operationLogMapper.findAll();

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("操作日志");

            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle dateStyle = createDateStyle(workbook);

            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "操作人", "操作类型", "目标类型", "目标ID", "描述", "IP地址", "操作时间"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            int rowNum = 1;
            for (OperationLog log : logs) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(log.getId());
                row.createCell(1).setCellValue(log.getOperator());
                row.createCell(2).setCellValue(log.getOperationType());
                row.createCell(3).setCellValue(log.getTargetType());
                row.createCell(4).setCellValue(log.getTargetId());
                row.createCell(5).setCellValue(log.getDescription() != null ? log.getDescription() : "");
                row.createCell(6).setCellValue(log.getIpAddress() != null ? log.getIpAddress() : "");
                Cell dateCell = row.createCell(7);
                if (log.getCreatedAt() != null) {
                    dateCell.setCellValue(log.getCreatedAt().format(formatter));
                    dateCell.setCellStyle(dateStyle);
                }
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            workbook.write(out);
            return out.toByteArray();
        }
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.DARK_GREEN.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private CellStyle createDateStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        CreationHelper creationHelper = workbook.getCreationHelper();
        style.setDataFormat(creationHelper.createDataFormat().getFormat("yyyy-mm-dd hh:mm:ss"));
        return style;
    }
}
