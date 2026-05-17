package com.village.committee.mapper;

import com.village.committee.domain.BackupRecord;
import com.village.committee.domain.SystemConfig;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SystemMapper {

    @Select("SELECT * FROM backup_records ORDER BY created_at DESC LIMIT #{limit}")
    List<BackupRecord> findRecentBackups(@Param("limit") int limit);

    @Select("SELECT * FROM backup_records ORDER BY created_at DESC")
    List<BackupRecord> findAllBackups();

    @Insert("INSERT INTO backup_records (file_name, file_path, file_size, type, status, operator, created_at) " +
            "VALUES (#{fileName}, #{filePath}, #{fileSize}, #{type}, 'pending', #{operator}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertBackup(BackupRecord record);

    @Update("UPDATE backup_records SET status = #{status}, file_size = #{fileSize}, finished_at = NOW() WHERE id = #{id}")
    int updateBackupStatus(@Param("id") Long id, @Param("status") String status, @Param("fileSize") Long fileSize);

    @Delete("DELETE FROM backup_records WHERE id = #{id}")
    int deleteBackup(@Param("id") Long id);

    @Select("SELECT * FROM system_config ORDER BY config_group, config_key")
    List<SystemConfig> findAllConfigs();

    @Select("SELECT * FROM system_config WHERE config_key = #{configKey}")
    SystemConfig findByKey(@Param("configKey") String configKey);

    @Update("UPDATE system_config SET config_value = #{configValue}, updated_at = NOW() WHERE config_key = #{configKey}")
    int updateConfig(@Param("configKey") String configKey, @Param("configValue") String configValue);

    @Select("SELECT COUNT(*) FROM residents")
    int countResidents();

    @Select("SELECT COUNT(*) FROM announcements")
    int countAnnouncements();

    @Select("SELECT COUNT(*) FROM committee_members")
    int countCommitteeMembers();

    @Select("SELECT COUNT(*) FROM operation_logs")
    int countOperationLogs();

    @Select("SELECT COUNT(*) FROM sys_user")
    int countUsers();
}
