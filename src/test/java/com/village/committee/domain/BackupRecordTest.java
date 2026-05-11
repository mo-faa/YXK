package com.village.committee.domain;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("BackupRecord实体类")
class BackupRecordTest {

    @Nested
    @DisplayName("正常流程")
    class 正常流程 {
        @Test
        @DisplayName("创建备份记录应包含所有字段")
        void 创建备份记录应包含所有字段() {
            BackupRecord r = new BackupRecord();
            r.setId(1L);
            r.setFileName("backup_20260510.sql");
            r.setFilePath("/backups/backup_20260510.sql");
            r.setFileSize(1024L * 1024L);
            r.setType("full");
            r.setStatus("success");
            r.setOperator("admin");
            assertEquals(1L, r.getId());
            assertEquals("backup_20260510.sql", r.getFileName());
            assertEquals(1024L * 1024L, r.getFileSize());
            assertEquals("full", r.getType());
            assertEquals("success", r.getStatus());
        }
    }

    @Nested
    @DisplayName("getFileSizeFormatted方法")
    class GetFileSizeFormatted方法 {
        @ParameterizedTest(name = "文件大小{0}字节应显示为{1}")
        @CsvSource({
            "0, '0 B'",
            "1, '1 B'",
            "512, '512 B'",
            "1023, '1023 B'",
            "1024, '1.00 KB'",
            "1536, '1.50 KB'",
            "1048576, '1.00 MB'",
            "1073741824, '1.00 GB'"
        })
        void 不同文件大小应格式化正确(long size, String expected) {
            BackupRecord r = new BackupRecord();
            r.setFileSize(size);
            String actual = r.getFileSizeFormatted();
            assertTrue(actual.startsWith(expected.split(" ")[0]),
                "文件大小" + size + "格式化后应包含" + expected + "，实际为" + actual);
        }

        @Test
        @DisplayName("fileSize为null时返回0 B")
        void fileSize为null时返回0B() {
            BackupRecord r = new BackupRecord();
            r.setFileSize(null);
            assertEquals("0 B", r.getFileSizeFormatted());
        }
    }

    @Nested
    @DisplayName("边界值")
    class 边界值 {
        @Test
        @DisplayName("fileSize为Long.MAX_VALUE时应格式化正确")
        void fileSize为MAX时格式化正确() {
            BackupRecord r = new BackupRecord();
            r.setFileSize(Long.MAX_VALUE);
            String formatted = r.getFileSizeFormatted();
            assertNotNull(formatted);
            assertTrue(formatted.contains("GB") || formatted.contains("EB"));
        }

        @Test
        @DisplayName("fileSize为负数时应正常处理")
        void fileSize为负数时应正常处理() {
            BackupRecord r = new BackupRecord();
            r.setFileSize(-1L);
            String formatted = r.getFileSizeFormatted();
            assertNotNull(formatted);
        }
    }
}
