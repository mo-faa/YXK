package com.village.committee.service;

import com.village.committee.domain.BackupRecord;
import com.village.committee.domain.SystemConfig;
import com.village.committee.mapper.SystemMapper;
import org.springframework.stereotype.Service;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BackupService {

    private final SystemMapper systemMapper;

    public BackupService(SystemMapper systemMapper) {
        this.systemMapper = systemMapper;
    }

    public Map<String, Object> getSystemInfo() {
        Map<String, Object> info = new HashMap<>();
        Runtime runtime = Runtime.getRuntime();
        info.put("totalMemory", runtime.totalMemory());
        info.put("freeMemory", runtime.freeMemory());
        info.put("usedMemory", runtime.totalMemory() - runtime.freeMemory());
        info.put("maxMemory", runtime.maxMemory());
        info.put("availableProcessors", runtime.availableProcessors());
        info.put("javaVersion", System.getProperty("java.version"));
        info.put("osName", System.getProperty("os.name"));
        info.put("osVersion", System.getProperty("os.version"));
        info.put("residentCount", systemMapper.countResidents());
        info.put("announcementCount", systemMapper.countAnnouncements());
        info.put("committeeMemberCount", systemMapper.countCommitteeMembers());
        info.put("operationLogCount", systemMapper.countOperationLogs());
        info.put("userCount", systemMapper.countUsers());
        return info;
    }

    public List<BackupRecord> getRecentBackups(int limit) {
        return systemMapper.findRecentBackups(limit);
    }

    public List<BackupRecord> getAllBackups() {
        return systemMapper.findAllBackups();
    }

    public List<SystemConfig> getAllConfigs() {
        return systemMapper.findAllConfigs();
    }

    public void createBackup(String type, String operator) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
        String timestamp = LocalDateTime.now().format(formatter);
        String fileName = "backup_" + timestamp + (type.equals("incremental") ? "_inc" : "") + ".sql";

        String backupDir = System.getProperty("user.dir") + "/backups/";
        File dir = new File(backupDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        BackupRecord record = new BackupRecord();
        record.setFileName(fileName);
        record.setFilePath(backupDir + fileName);
        record.setType(type);
        record.setOperator(operator);

        try {
            systemMapper.insertBackup(record);

            ProcessBuilder pb = new ProcessBuilder(
                    "mysqldump",
                    "-u", "root",
                    "-proot",
                    "--databases", "village_committee",
                    "--routines",
                    "--triggers",
                    "--single-transaction",
                    "--result-file", backupDir + fileName
            );
            Process process = pb.start();
            int exitCode = process.waitFor();

            if (exitCode == 0) {
                File file = new File(backupDir + fileName);
                systemMapper.updateBackupStatus(record.getId(), "success", file.length());
            } else {
                systemMapper.updateBackupStatus(record.getId(), "failed", 0L);
                throw new RuntimeException("mysqldump执行失败，退出码: " + exitCode);
            }
        } catch (Exception e) {
            systemMapper.updateBackupStatus(record.getId(), "failed", 0L);
            throw new RuntimeException("备份失败: " + e.getMessage(), e);
        }
    }

    public void deleteBackup(Long id) {
        BackupRecord record = systemMapper.findRecentBackups(1).stream()
                .filter(r -> r.getId().equals(id))
                .findFirst()
                .orElse(null);

        if (record != null && record.getFilePath() != null) {
            File file = new File(record.getFilePath());
            if (file.exists()) {
                file.delete();
            }
        }
        systemMapper.deleteBackup(id);
    }

    public void updateConfig(String configKey, String configValue) {
        int updated = systemMapper.updateConfig(configKey, configValue);
        if (updated == 0) {
            throw new RuntimeException("配置项不存在: " + configKey);
        }
    }

    public String getConfigValue(String configKey) {
        SystemConfig config = systemMapper.findByKey(configKey);
        return config != null ? config.getConfigValue() : null;
    }
}
