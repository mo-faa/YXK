package com.village.committee.service;

import com.village.committee.domain.OperationLog;
import com.village.committee.mapper.OperationLogMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OperationLogService操作日志服务")
class OperationLogServiceTest {

    @Mock private OperationLogMapper operationLogMapper;
    @Mock private HttpServletRequest request;
    @Mock private HttpSession session;

    @InjectMocks private OperationLogService operationLogService;

    @Nested
    @DisplayName("log - 记录操作日志")
    class Log {

        @Test
        @DisplayName("正常请求应记录操作日志")
        void 正常请求应记录日志() {
            when(request.getRemoteUser()).thenReturn(null);
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("username")).thenReturn("admin");
            when(request.getHeader("X-Forwarded-For")).thenReturn(null);
            when(request.getHeader("X-Real-IP")).thenReturn(null);
            when(request.getRemoteAddr()).thenReturn("192.168.1.1");
            when(request.getHeader("User-Agent")).thenReturn("Mozilla/5.0");

            operationLogService.log(request, "CREATE", "RESIDENT", 1L, "新增村民");

            verify(operationLogMapper).insert(any(OperationLog.class));
        }

        @Test
        @DisplayName("request为null应使用SYSTEM作为操作人")
        void request为null应使用SYSTEM() {
            operationLogService.log(null, "SYSTEM", "CONFIG", null, "系统初始化");

            ArgumentCaptor<OperationLog> captor = ArgumentCaptor.forClass(OperationLog.class);
            verify(operationLogMapper).insert(captor.capture());
            assertEquals("SYSTEM", captor.getValue().getOperator());
        }

        @Test
        @DisplayName("session中有username应使用username")
        void session中有username应使用() {
            when(request.getRemoteUser()).thenReturn(null);
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("username")).thenReturn("testuser");
            when(request.getHeader("X-Forwarded-For")).thenReturn(null);
            when(request.getHeader("X-Real-IP")).thenReturn(null);
            when(request.getRemoteAddr()).thenReturn("127.0.0.1");
            when(request.getHeader("User-Agent")).thenReturn("Chrome");

            operationLogService.log(request, "UPDATE", "RESIDENT", 2L, "更新村民");

            ArgumentCaptor<OperationLog> captor = ArgumentCaptor.forClass(OperationLog.class);
            verify(operationLogMapper).insert(captor.capture());
            assertEquals("testuser", captor.getValue().getOperator());
        }

        @Test
        @DisplayName("X-Forwarded-For头应优先作为IP")
        void xForwardedFor应优先() {
            when(request.getRemoteUser()).thenReturn(null);
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("username")).thenReturn(null);
            when(session.getAttribute("user")).thenReturn(null);
            when(request.getHeader("X-Operator")).thenReturn("admin");
            when(request.getHeader("X-Forwarded-For")).thenReturn("10.0.0.1, 192.168.1.1");
            when(request.getHeader("User-Agent")).thenReturn("");

            operationLogService.log(request, "DELETE", "ANNOUNCEMENT", 3L, "删除公告");

            ArgumentCaptor<OperationLog> captor = ArgumentCaptor.forClass(OperationLog.class);
            verify(operationLogMapper).insert(captor.capture());
            assertEquals("10.0.0.1", captor.getValue().getIpAddress());
        }

        @Test
        @DisplayName("X-Real-IP头应作为IP备选")
        void xRealIp应作为备选() {
            when(request.getRemoteUser()).thenReturn(null);
            when(request.getSession(false)).thenReturn(session);
            when(session.getAttribute("username")).thenReturn(null);
            when(session.getAttribute("user")).thenReturn(null);
            when(request.getHeader("X-Operator")).thenReturn(null);
            when(request.getHeader("X-Forwarded-For")).thenReturn(null);
            when(request.getHeader("X-Real-IP")).thenReturn("172.16.0.1");
            when(request.getHeader("User-Agent")).thenReturn("");

            operationLogService.log(request, "READ", "RESIDENT", 4L, "查看村民");

            ArgumentCaptor<OperationLog> captor = ArgumentCaptor.forClass(OperationLog.class);
            verify(operationLogMapper).insert(captor.capture());
            assertEquals("172.16.0.1", captor.getValue().getIpAddress());
        }
    }

    @Nested
    @DisplayName("list和get")
    class ListAndGet {

        @Test
        @DisplayName("list应返回所有日志")
        void list应返回所有日志() {
            when(operationLogMapper.findAll()).thenReturn(List.of(new OperationLog()));
            assertEquals(1, operationLogService.list().size());
        }

        @Test
        @DisplayName("get应返回指定日志")
        void get应返回指定日志() {
            OperationLog log = new OperationLog();
            log.setId(1L);
            when(operationLogMapper.findById(1L)).thenReturn(log);
            assertEquals(1L, operationLogService.get(1L).getId());
        }
    }

    @Nested
    @DisplayName("latest - 获取最新日志")
    class Latest {

        @Test
        @DisplayName("limit为0应使用默认10")
        void limit为0应使用默认() {
            when(operationLogMapper.findLatest(10)).thenReturn(List.of());
            operationLogService.latest(0);
            verify(operationLogMapper).findLatest(10);
        }

        @Test
        @DisplayName("limit为负数应使用默认10")
        void limit为负数应使用默认() {
            when(operationLogMapper.findLatest(10)).thenReturn(List.of());
            operationLogService.latest(-5);
            verify(operationLogMapper).findLatest(10);
        }

        @Test
        @DisplayName("limit超过100应限制为100")
        void limit超过100应限制() {
            when(operationLogMapper.findLatest(100)).thenReturn(List.of());
            operationLogService.latest(200);
            verify(operationLogMapper).findLatest(100);
        }

        @Test
        @DisplayName("正常limit应直接使用")
        void 正常limit应直接使用() {
            when(operationLogMapper.findLatest(20)).thenReturn(List.of());
            operationLogService.latest(20);
            verify(operationLogMapper).findLatest(20);
        }
    }

    @Nested
    @DisplayName("countAll和countSince")
    class CountOperations {

        @Test
        @DisplayName("countAll应返回总数")
        void countAll应返回总数() {
            when(operationLogMapper.countAll()).thenReturn(100L);
            assertEquals(100L, operationLogService.countAll());
        }

        @Test
        @DisplayName("countSince应返回指定时间后的数量")
        void countSince应返回数量() {
            LocalDateTime from = LocalDateTime.of(2026, 5, 1, 0, 0);
            when(operationLogMapper.countSince(from)).thenReturn(50L);
            assertEquals(50L, operationLogService.countSince(from));
        }
    }

    @Nested
    @DisplayName("countToday - 今日操作数")
    class CountToday {

        @Test
        @DisplayName("应返回今日操作数")
        void 应返回今日操作数() {
            when(operationLogMapper.countSince(any(LocalDateTime.class))).thenReturn(10L);
            assertEquals(10L, operationLogService.countToday());
        }
    }

    @Nested
    @DisplayName("getOperationTypes和getTargetTypes")
    class GetTypes {

        @Test
        @DisplayName("getOperationTypes应返回操作类型列表")
        void getOperationTypes应返回列表() {
            when(operationLogMapper.findDistinctOperationTypes()).thenReturn(List.of("CREATE", "UPDATE", "DELETE"));
            List<String> types = operationLogService.getOperationTypes();
            assertEquals(3, types.size());
        }

        @Test
        @DisplayName("getTargetTypes应返回目标类型列表")
        void getTargetTypes应返回列表() {
            when(operationLogMapper.findDistinctTargetTypes()).thenReturn(List.of("RESIDENT", "ANNOUNCEMENT"));
            List<String> types = operationLogService.getTargetTypes();
            assertEquals(2, types.size());
        }
    }

    @Nested
    @DisplayName("countByOperationType和countByTargetType")
    class CountByType {

        @Test
        @DisplayName("countByOperationType应返回对应数量")
        void countByOperationType应返回数量() {
            when(operationLogMapper.countByOperationType("CREATE")).thenReturn(30L);
            assertEquals(30L, operationLogService.countByOperationType("CREATE"));
        }

        @Test
        @DisplayName("countByTargetType应返回对应数量")
        void countByTargetType应返回数量() {
            when(operationLogMapper.countByTargetType("RESIDENT")).thenReturn(20L);
            assertEquals(20L, operationLogService.countByTargetType("RESIDENT"));
        }
    }

    @Nested
    @DisplayName("getRecentOperationStats - 最近操作统计")
    class GetRecentOperationStats {

        @Test
        @DisplayName("应返回统计数据")
        void 应返回统计数据() {
            when(operationLogMapper.getRecentOperationStats(7)).thenReturn(List.of(Map.of("date", "2026-05-10", "count", 5)));
            List<Map<String, Object>> stats = operationLogService.getRecentOperationStats(7);
            assertEquals(1, stats.size());
        }
    }
}
