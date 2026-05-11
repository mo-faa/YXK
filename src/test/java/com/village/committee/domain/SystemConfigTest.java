package com.village.committee.domain;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("SystemConfig实体类")
class SystemConfigTest {

    @Test
    @DisplayName("创建系统配置应包含所有字段")
    void 创建系统配置应包含所有字段() {
        SystemConfig c = new SystemConfig();
        c.setId(1L);
        c.setConfigKey("site.name");
        c.setConfigValue("网上村委会");
        c.setConfigGroup("basic");
        c.setDescription("站点名称");

        assertEquals(1L, c.getId());
        assertEquals("site.name", c.getConfigKey());
        assertEquals("网上村委会", c.getConfigValue());
        assertEquals("basic", c.getConfigGroup());
        assertEquals("站点名称", c.getDescription());
    }

    @Test
    @DisplayName("所有字段为null时应正常")
    void 所有字段为null时应正常() {
        SystemConfig c = new SystemConfig();
        assertNull(c.getId());
        assertNull(c.getConfigKey());
        assertNull(c.getConfigValue());
        assertNull(c.getConfigGroup());
        assertNull(c.getDescription());
    }
}
