package com.village.committee.web.api;

import com.village.committee.common.PageResult;
import com.village.committee.domain.Resident;
import com.village.committee.service.ResidentService;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ResidentApiController村民API")
class ResidentApiControllerTest {

    @Mock private ResidentService residentService;

    @InjectMocks private ResidentApiController residentApiController;

    @Nested
    @DisplayName("list - 获取所有村民")
    class ListResidents {

        @Test
        @DisplayName("应返回所有村民列表")
        void 应返回所有村民() {
            when(residentService.list()).thenReturn(List.of(new Resident()));

            List<Resident> result = residentApiController.list();

            assertEquals(1, result.size());
        }
    }

    @Nested
    @DisplayName("page - 分页查询")
    class PageResidents {

        @Test
        @DisplayName("应返回分页结果")
        void 应返回分页结果() {
            PageResult<Resident> pageResult = new PageResult<>(List.of(), 1, 10, 0);
            when(residentService.page(null, null, null)).thenReturn(pageResult);

            PageResult<Resident> result = residentApiController.page(null, null, null);

            assertEquals(0, result.getTotal());
        }
    }

    @Nested
    @DisplayName("get - 获取单个村民")
    class GetResident {

        @Test
        @DisplayName("存在的村民应返回村民对象")
        void 存在的村民应返回() {
            Resident r = new Resident();
            r.setId(1L);
            r.setName("张三");
            when(residentService.get(1L)).thenReturn(r);

            Resident result = residentApiController.get(1L);

            assertEquals(1L, result.getId());
            assertEquals("张三", result.getName());
        }

        @Test
        @DisplayName("不存在的村民应抛出404异常")
        void 不存在的村民应抛出四零四() {
            when(residentService.get(999L)).thenReturn(null);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> residentApiController.get(999L));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }

    @Nested
    @DisplayName("create - 创建村民")
    class CreateResident {

        @Test
        @DisplayName("创建成功应返回201状态码")
        void 创建成功应返回二零一() {
            Resident r = new Resident();
            r.setName("张三");
            when(residentService.create(any(Resident.class))).thenReturn(r);

            ResponseEntity<Resident> result = residentApiController.create(r);

            assertEquals(HttpStatus.CREATED, result.getStatusCode());
            assertNotNull(result.getBody());
        }
    }

    @Nested
    @DisplayName("update - 更新村民")
    class UpdateResident {

        @Test
        @DisplayName("更新成功应返回更新后的村民")
        void 更新成功应返回村民() {
            Resident r = new Resident();
            r.setName("李四");
            when(residentService.update(1L, r)).thenReturn(true);
            when(residentService.get(1L)).thenReturn(r);

            Resident result = residentApiController.update(1L, r);

            assertEquals("李四", result.getName());
        }

        @Test
        @DisplayName("更新不存在的村民应抛出404异常")
        void 更新不存在应抛出四零四() {
            Resident r = new Resident();
            when(residentService.update(999L, r)).thenReturn(false);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> residentApiController.update(999L, r));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }

    @Nested
    @DisplayName("delete - 删除村民")
    class DeleteResident {

        @Test
        @DisplayName("删除成功应返回204状态码")
        void 删除成功应返回二零四() {
            when(residentService.delete(1L)).thenReturn(true);

            ResponseEntity<Void> result = residentApiController.delete(1L);

            assertEquals(HttpStatus.NO_CONTENT, result.getStatusCode());
        }

        @Test
        @DisplayName("删除不存在的村民应抛出404异常")
        void 删除不存在应抛出四零四() {
            when(residentService.delete(999L)).thenReturn(false);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> residentApiController.delete(999L));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }
}
