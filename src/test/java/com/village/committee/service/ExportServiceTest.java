package com.village.committee.service;

import com.village.committee.domain.Announcement;
import com.village.committee.domain.OperationLog;
import com.village.committee.domain.Resident;
import com.village.committee.mapper.*;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.ByteArrayInputStream;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ExportService导出服务")
class ExportServiceTest {

    @Mock private ResidentMapper residentMapper;
    @Mock private AnnouncementMapper announcementMapper;
    @Mock private OperationLogMapper operationLogMapper;

    @InjectMocks private ExportService exportService;

    @Nested
    @DisplayName("exportResidentsToExcel - 导出村民Excel")
    class ExportResidentsToExcel {

        @Test
        @DisplayName("空数据应生成仅含表头的Excel")
        void 空数据应生成表头Excel() throws Exception {
            when(residentMapper.findAll()).thenReturn(Collections.emptyList());

            byte[] result = exportService.exportResidentsToExcel();

            assertNotNull(result);
            assertTrue(result.length > 0);

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("村民信息", sheet.getSheetName());
                assertEquals(1, sheet.getPhysicalNumberOfRows());
                assertEquals("ID", sheet.getRow(0).getCell(0).getStringCellValue());
                assertEquals("姓名", sheet.getRow(0).getCell(1).getStringCellValue());
            }
        }

        @Test
        @DisplayName("有数据应生成包含数据的Excel")
        void 有数据应生成包含数据的Excel() throws Exception {
            Resident r = new Resident();
            r.setId(1L);
            r.setName("张三");
            r.setIdCard("110101199003077758");
            r.setPhone("13800138000");
            r.setAddress("北京市朝阳区");
            r.setCreatedAt(LocalDateTime.of(2026, 1, 1, 12, 0));

            when(residentMapper.findAll()).thenReturn(List.of(r));

            byte[] result = exportService.exportResidentsToExcel();

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals(2, sheet.getPhysicalNumberOfRows());
                assertEquals("张三", sheet.getRow(1).getCell(1).getStringCellValue());
            }
        }

        @Test
        @DisplayName("null字段应显示为空字符串")
        void null字段应显示为空() throws Exception {
            Resident r = new Resident();
            r.setId(1L);
            r.setName("李四");
            r.setIdCard(null);
            r.setPhone(null);
            r.setAddress(null);
            r.setCreatedAt(null);

            when(residentMapper.findAll()).thenReturn(List.of(r));

            byte[] result = exportService.exportResidentsToExcel();

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("", sheet.getRow(1).getCell(2).getStringCellValue());
                assertEquals("", sheet.getRow(1).getCell(3).getStringCellValue());
            }
        }
    }

    @Nested
    @DisplayName("exportAnnouncementsToExcel - 导出公告Excel")
    class ExportAnnouncementsToExcel {

        @Test
        @DisplayName("空数据应生成仅含表头的Excel")
        void 空数据应生成表头Excel() throws Exception {
            when(announcementMapper.findAll()).thenReturn(Collections.emptyList());

            byte[] result = exportService.exportAnnouncementsToExcel();

            assertNotNull(result);
            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("公告列表", sheet.getSheetName());
                assertEquals(1, sheet.getPhysicalNumberOfRows());
            }
        }

        @Test
        @DisplayName("已发布公告状态应显示已发布")
        void 已发布公告状态应显示已发布() throws Exception {
            Announcement a = new Announcement();
            a.setId(1L);
            a.setTitle("测试公告");
            a.setPublisher("管理员");
            a.setPublishTime(LocalDateTime.of(2026, 5, 1, 10, 0));
            a.setIsTop(true);
            a.setStatus(1);

            when(announcementMapper.findAll()).thenReturn(List.of(a));

            byte[] result = exportService.exportAnnouncementsToExcel();

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("是", sheet.getRow(1).getCell(4).getStringCellValue());
                assertEquals("已发布", sheet.getRow(1).getCell(5).getStringCellValue());
            }
        }

        @Test
        @DisplayName("草稿公告状态应显示草稿")
        void 草稿公告状态应显示草稿() throws Exception {
            Announcement a = new Announcement();
            a.setId(2L);
            a.setTitle("草稿公告");
            a.setPublisher("管理员");
            a.setPublishTime(null);
            a.setIsTop(false);
            a.setStatus(0);

            when(announcementMapper.findAll()).thenReturn(List.of(a));

            byte[] result = exportService.exportAnnouncementsToExcel();

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("否", sheet.getRow(1).getCell(4).getStringCellValue());
                assertEquals("草稿", sheet.getRow(1).getCell(5).getStringCellValue());
            }
        }
    }

    @Nested
    @DisplayName("exportOperationLogsToExcel - 导出操作日志Excel")
    class ExportOperationLogsToExcel {

        @Test
        @DisplayName("空数据应生成仅含表头的Excel")
        void 空数据应生成表头Excel() throws Exception {
            when(operationLogMapper.findAll()).thenReturn(Collections.emptyList());

            byte[] result = exportService.exportOperationLogsToExcel();

            assertNotNull(result);
            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("操作日志", sheet.getSheetName());
                assertEquals(1, sheet.getPhysicalNumberOfRows());
            }
        }

        @Test
        @DisplayName("有数据应生成包含数据的Excel")
        void 有数据应生成包含数据的Excel() throws Exception {
            OperationLog log = new OperationLog();
            log.setId(1L);
            log.setOperator("admin");
            log.setOperationType("CREATE");
            log.setTargetType("RESIDENT");
            log.setTargetId(1L);
            log.setDescription("新增村民");
            log.setIpAddress("127.0.0.1");
            log.setUserAgent("Mozilla/5.0");
            log.setCreatedAt(LocalDateTime.of(2026, 5, 10, 14, 30));

            when(operationLogMapper.findAll()).thenReturn(List.of(log));

            byte[] result = exportService.exportOperationLogsToExcel();

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals(2, sheet.getPhysicalNumberOfRows());
                assertEquals("admin", sheet.getRow(1).getCell(1).getStringCellValue());
            }
        }

        @Test
        @DisplayName("null描述和IP应显示为空字符串")
        void null字段应显示为空() throws Exception {
            OperationLog log = new OperationLog();
            log.setId(1L);
            log.setOperator("admin");
            log.setOperationType("DELETE");
            log.setTargetType("ANNOUNCEMENT");
            log.setTargetId(2L);
            log.setDescription(null);
            log.setIpAddress(null);
            log.setUserAgent(null);
            log.setCreatedAt(null);

            when(operationLogMapper.findAll()).thenReturn(List.of(log));

            byte[] result = exportService.exportOperationLogsToExcel();

            try (Workbook wb = WorkbookFactory.create(new ByteArrayInputStream(result))) {
                Sheet sheet = wb.getSheetAt(0);
                assertEquals("", sheet.getRow(1).getCell(5).getStringCellValue());
                assertEquals("", sheet.getRow(1).getCell(6).getStringCellValue());
            }
        }
    }
}
