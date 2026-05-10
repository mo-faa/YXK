package com.village.committee.service;

import com.village.committee.domain.CommitteeMember;
import com.village.committee.mapper.CommitteeMemberMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CommitteeMemberService")
class CommitteeMemberServiceTest {

    @Mock
    private CommitteeMemberMapper committeeMemberMapper;

    @InjectMocks
    private CommitteeMemberService committeeMemberService;

    @Nested
    @DisplayName("validate")
    class Validate {

        @Test
        @DisplayName("null\u6210\u5458\u5e94\u629b\u5f02\u5e38")
        void nullMember() {
            assertThrows(ResponseStatusException.class, () -> committeeMemberService.validate(null));
        }

        @Test
        @DisplayName("\u59d3\u540d\u4e3a\u7a7a\u5e94\u629b\u5f02\u5e38")
        void blankName() {
            CommitteeMember m = new CommitteeMember();
            m.setName("");
            m.setPosition("\u6751\u4e3b\u4efb");
            assertThrows(ResponseStatusException.class, () -> committeeMemberService.validate(m));
        }

        @Test
        @DisplayName("\u804c\u52a1\u4e3a\u7a7a\u5e94\u629b\u5f02\u5e38")
        void blankPosition() {
            CommitteeMember m = new CommitteeMember();
            m.setName("\u738b\u4e94");
            m.setPosition("");
            assertThrows(ResponseStatusException.class, () -> committeeMemberService.validate(m));
        }

        @Test
        @DisplayName("\u6b63\u5e38\u6210\u5458\u5e94\u4e0d\u629b\u5f02\u5e38")
        void validMember() {
            CommitteeMember m = new CommitteeMember();
            m.setName("\u738b\u4e94");
            m.setPosition("\u6751\u4e3b\u4efb");
            assertDoesNotThrow(() -> committeeMemberService.validate(m));
        }
    }

    @Nested
    @DisplayName("create")
    class Create {

        @Test
        @DisplayName("\u521b\u5efa\u6210\u5458\u5e94\u8c03\u7528mapper.insert")
        void createSuccess() {
            CommitteeMember m = new CommitteeMember();
            m.setName("\u738b\u4e94");
            m.setPosition("\u6751\u4e3b\u4efb");
            m.setIsActive(null);
            m.setJoinTime(null);

            when(committeeMemberMapper.insert(any())).thenReturn(1);
            var result = committeeMemberService.create(m);
            assertNotNull(result);
            assertTrue(m.getIsActive());
            assertNotNull(m.getJoinTime());
            verify(committeeMemberMapper).insert(m);
        }
    }

    @Nested
    @DisplayName("countAll\u548clist")
    class CountAndList {

        @Test
        @DisplayName("countAll\u5e94\u8fd4\u56de\u603b\u6570")
        void countAll() {
            when(committeeMemberMapper.count(null, null)).thenReturn(4L);
            assertEquals(4L, committeeMemberService.countAll());
        }

        @Test
        @DisplayName("listActive\u5e94\u8fd4\u56de\u5728\u804c\u6210\u5458")
        void listActive() {
            when(committeeMemberMapper.findActive()).thenReturn(List.of());
            assertEquals(0, committeeMemberService.listActive().size());
        }
    }
}
