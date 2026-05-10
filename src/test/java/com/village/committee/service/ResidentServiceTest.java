package com.village.committee.service;

import com.village.committee.domain.Resident;
import com.village.committee.mapper.ResidentMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ResidentService")
class ResidentServiceTest {

    @Mock
    private ResidentMapper residentMapper;

    @InjectMocks
    private ResidentService residentService;

    @Nested
    @DisplayName("validate")
    class Validate {

        @Test
        @DisplayName("null\u6751\u6c11\u5e94\u629b\u5f02\u5e38")
        void nullResident() {
            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> residentService.validate(null));
            assertEquals(HttpStatus.BAD_REQUEST, ex.getStatusCode());
        }

        @Test
        @DisplayName("\u59d3\u540d\u4e3a\u7a7a\u5e94\u629b\u5f02\u5e38")
        void blankName() {
            Resident r = new Resident();
            r.setName("");
            assertThrows(ResponseStatusException.class, () -> residentService.validate(r));
        }

        @Test
        @DisplayName("\u65e0\u6548\u8eab\u4efd\u8bc1\u53f7\u5e94\u629b\u5f02\u5e38")
        void invalidIdCard() {
            Resident r = new Resident();
            r.setName("\u5f20\u4e09");
            r.setIdCard("123456789012345678");
            assertThrows(ResponseStatusException.class, () -> residentService.validate(r));
        }

        @Test
        @DisplayName("\u6b63\u5e38\u6751\u6c11\u5e94\u4e0d\u629b\u5f02\u5e38")
        void validResident() {
            Resident r = new Resident();
            r.setName("\u5f20\u4e09");
            assertDoesNotThrow(() -> residentService.validate(r));
        }
    }

    @Nested
    @DisplayName("validateAndGetError")
    class ValidateAndGetError {

        @Test
        @DisplayName("null\u6751\u6c11\u5e94\u8fd4\u56de\u9519\u8bef\u6d88\u606f")
        void nullResident() {
            assertNotNull(residentService.validateAndGetError(null));
        }

        @Test
        @DisplayName("\u6b63\u5e38\u6751\u6c11\u5e94\u8fd4\u56denull")
        void validResident() {
            Resident r = new Resident();
            r.setName("\u5f20\u4e09");
            assertNull(residentService.validateAndGetError(r));
        }
    }

    @Nested
    @DisplayName("create")
    class Create {

        @Test
        @DisplayName("\u521b\u5efa\u6751\u6c11\u5e94\u8c03\u7528mapper.insert")
        void createSuccess() {
            Resident r = new Resident();
            r.setName("\u5f20\u4e09");

            when(residentMapper.insert(any())).thenReturn(1);
            Resident result = residentService.create(r);
            assertNotNull(result);
            verify(residentMapper).insert(r);
        }
    }

    @Nested
    @DisplayName("update\u548cdelete")
    class UpdateAndDelete {

        @Test
        @DisplayName("\u66f4\u65b0\u6210\u529f\u5e94\u8fd4\u56detrue")
        void updateSuccess() {
            Resident r = new Resident();
            r.setName("\u5f20\u4e09");
            when(residentMapper.update(any())).thenReturn(1);
            assertTrue(residentService.update(1L, r));
        }

        @Test
        @DisplayName("\u5220\u9664\u6210\u529f\u5e94\u8fd4\u56detrue")
        void deleteSuccess() {
            when(residentMapper.deleteById(1L)).thenReturn(1);
            assertTrue(residentService.delete(1L));
        }

        @Test
        @DisplayName("\u5220\u9664\u4e0d\u5b58\u5728\u5e94\u8fd4\u56defalse")
        void deleteNotFound() {
            when(residentMapper.deleteById(999L)).thenReturn(0);
            assertFalse(residentService.delete(999L));
        }
    }

    @Nested
    @DisplayName("countAll\u548clist")
    class CountAndList {

        @Test
        @DisplayName("countAll\u5e94\u8fd4\u56de\u603b\u6570")
        void countAll() {
            when(residentMapper.count(null)).thenReturn(5L);
            assertEquals(5L, residentService.countAll());
        }

        @Test
        @DisplayName("list\u5e94\u8fd4\u56de\u6240\u6709\u6751\u6c11")
        void listAll() {
            when(residentMapper.findAll()).thenReturn(List.of(new Resident()));
            assertEquals(1, residentService.list().size());
        }
    }
}
