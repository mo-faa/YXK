package com.village.committee.service;

import com.village.committee.domain.BackupRecord;
import com.village.committee.domain.SystemConfig;
import com.village.committee.mapper.SystemMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("BackupService备份服务")
class BackupServiceTest {

    @Mock private SystemMapper systemMapper;

    @InjectMocks private BackupService backupService;

    @Nested
    @DisplayName("getSystemInfo - 获取系统信息")
    class GetSystemInfo {

        @Test
        @DisplayName("应包含内存信息")
        void 应包含内存信息() {
            when(systemMapper.countResidents()).thenReturn(100);
            when(systemMapper.countAnnouncements()).thenReturn(50);
            when(systemMapper.countCommitteeMembers()).thenReturn(10);
            when(systemMapper.countOperationLogs()).thenReturn(200);
            when(systemMapper.countUsers()).thenReturn(5);

            Map<String, Object> info = backupService.getSystemInfo();

            assertTrue(info.containsKey("totalMemory"));
            assertTrue(info.containsKey("freeMemory"));
            assertTrue(info.containsKey("usedMemory"));
            assertTrue(info.containsKey("maxMemory"));
            assertTrue(info.containsKey("availableProcessors"));
            assertTrue(info.containsKey("javaVersion"));
            assertTrue(info.containsKey("osName"));
            assertTrue(info.containsKey("osVersion"));
        }

        @Test
        @DisplayName("应包含数据库统计信息")
        void 应包含数据库统计() {
            when(systemMapper.countResidents()).thenReturn(100);
            when(systemMapper.countAnnouncements()).thenReturn(50);
            when(systemMapper.countCommitteeMembers()).thenReturn(10);
            when(systemMapper.countOperationLogs()).thenReturn(200);
            when(systemMapper.countUsers()).thenReturn(5);

            Map<String, Object> info = backupService.getSystemInfo();

            assertEquals(100, info.get("residentCount"));
            assertEquals(50, info.get("announcementCount"));
            assertEquals(10, info.get("committeeMemberCount"));
            assertEquals(200, info.get("operationLogCount"));
            assertEquals(5, info.get("userCount"));
        }

        @Test
        @DisplayName("内存值应为正数")
        void 内存值应为正数() {
            when(systemMapper.countResidents()).thenReturn(0);
            when(systemMapper.countAnnouncements()).thenReturn(0);
            when(systemMapper.countCommitteeMembers()).thenReturn(0);
            when(systemMapper.countOperationLogs()).thenReturn(0);
            when(systemMapper.countUsers()).thenReturn(0);

            Map<String, Object> info = backupService.getSystemInfo();

            assertTrue((Long) info.get("totalMemory") > 0);
            assertTrue((Long) info.get("maxMemory") > 0);
            assertTrue((Integer) info.get("availableProcessors") > 0);
        }
    }

    @Nested
    @DisplayName("getRecentBackups - 获取最近备份")
    class GetRecentBackups {

        @Test
        @DisplayName("应调用mapper并返回结果")
        void 应调用mapper() {
            when(systemMapper.findRecentBackups(5)).thenReturn(List.of());

            List<BackupRecord> result = backupService.getRecentBackups(5);

            assertNotNull(result);
            verify(systemMapper).findRecentBackups(5);
        }
    }

    @Nested
    @DisplayName("getAllBackups - 获取所有备份")
    class GetAllBackups {

        @Test
        @DisplayName("应调用mapper并返回结果")
        void 应调用mapper() {
            when(systemMapper.findAllBackups()).thenReturn(List.of());

            List<BackupRecord> result = backupService.getAllBackups();

            assertNotNull(result);
            verify(systemMapper).findAllBackups();
        }
    }

    @Nested
    @DisplayName("getAllConfigs - 获取所有配置")
    class GetAllConfigs {

        @Test
        @DisplayName("应调用mapper并返回结果")
        void 应调用mapper() {
            SystemConfig config = new SystemConfig();
            config.setId(1L);
            config.setConfigKey("site.name");
            config.setConfigValue("网上村委会");
            when(systemMapper.findAllConfigs()).thenReturn(List.of(config));

            List<SystemConfig> result = backupService.getAllConfigs();

            assertEquals(1, result.size());
            assertEquals("site.name", result.get(0).getConfigKey());
        }
    }

    @Nested
    @DisplayName("updateConfig - 更新配置")
    class UpdateConfig {

        @Test
        @DisplayName("配置项存在应更新成功")
        void 配置项存在应更新成功() {
            when(systemMapper.updateConfig("site.name", "新名称")).thenReturn(1);

            assertDoesNotThrow(() -> backupService.updateConfig("site.name", "新名称"));
            verify(systemMapper).updateConfig("site.name", "新名称");
        }

        @Test
        @DisplayName("配置项不存在应抛出异常")
        void 配置项不存在应抛出异常() {
            when(systemMapper.updateConfig("nonexistent", "value")).thenReturn(0);

            RuntimeException ex = assertThrows(RuntimeException.class,
                () -> backupService.updateConfig("nonexistent", "value"));
            assertTrue(ex.getMessage().contains("配置项不存在"));
        }
    }

    @Nested
    @DisplayName("getConfigValue - 获取配置值")
    class GetConfigValue {

        @Test
        @DisplayName("配置项存在应返回值")
        void 配置项存在应返回值() {
            SystemConfig config = new SystemConfig();
            config.setConfigValue("网上村委会");
            when(systemMapper.findByKey("site.name")).thenReturn(config);

            String value = backupService.getConfigValue("site.name");
            assertEquals("网上村委会", value);
        }

        @Test
        @DisplayName("配置项不存在应返回null")
        void 配置项不存在应返回null() {
            when(systemMapper.findByKey("nonexistent")).thenReturn(null);

            String value = backupService.getConfigValue("nonexistent");
            assertNull(value);
        }
    }

    @Nested
    @DisplayName("deleteBackup - 删除备份")
    class DeleteBackup {

        @Test
        @DisplayName("应调用mapper删除备份")
        void 应调用mapper删除() {
            BackupRecord record = new BackupRecord();
            record.setId(1L);
            record.setFilePath("/nonexistent/path/backup.sql");
            when(systemMapper.findRecentBackups(1)).thenReturn(List.of(record));

            backupService.deleteBackup(1L);

            verify(systemMapper).deleteBackup(1L);
        }

        @Test
        @DisplayName("备份记录不存在也应调用mapper删除")
        void 备份记录不存在也应删除() {
            when(systemMapper.findRecentBackups(1)).thenReturn(List.of());

            backupService.deleteBackup(999L);

            verify(systemMapper).deleteBackup(999L);
        }
    }
}
