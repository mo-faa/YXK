package com.village.committee.web.api;

import com.village.committee.mapper.HealthMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("HealthApiController健康检查API")
class HealthApiControllerTest {

    @Mock private HealthMapper healthMapper;

    @InjectMocks private HealthApiController healthApiController;

    @Nested
    @DisplayName("health - 健康检查")
    class Health {

        @Test
        @DisplayName("数据库正常应返回ok=true和dbOk=true")
        void 数据库正常应返回正常() {
            when(healthMapper.ping()).thenReturn("1");

            Map<String, Object> result = healthApiController.health();

            assertEquals(true, result.get("ok"));
            assertEquals(true, result.get("dbOk"));
            assertEquals("1", result.get("dbPing"));
            assertNotNull(result.get("time"));
            assertNotNull(result.get("version"));
        }

        @Test
        @DisplayName("数据库异常应返回ok=true和dbOk=false")
        void 数据库异常应返回DbOkFalse() {
            when(healthMapper.ping()).thenThrow(new RuntimeException("Connection refused"));

            Map<String, Object> result = healthApiController.health();

            assertEquals(true, result.get("ok"));
            assertEquals(false, result.get("dbOk"));
            assertNotNull(result.get("dbError"));
            assertTrue(result.get("dbError").toString().contains("Connection refused"));
        }

        @Test
        @DisplayName("应包含版本信息")
        void 应包含版本信息() {
            when(healthMapper.ping()).thenReturn("1");

            Map<String, Object> result = healthApiController.health();

            assertEquals("1.0.0", result.get("version"));
        }

        @Test
        @DisplayName("应包含运行状态")
        void 应包含运行状态() {
            when(healthMapper.ping()).thenReturn("1");

            Map<String, Object> result = healthApiController.health();

            assertEquals("运行中", result.get("uptime"));
        }
    }
}
