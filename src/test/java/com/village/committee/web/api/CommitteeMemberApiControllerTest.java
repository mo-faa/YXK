package com.village.committee.web.api;

import com.village.committee.common.PageResult;
import com.village.committee.domain.CommitteeMember;
import com.village.committee.service.CommitteeMemberService;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CommitteeMemberApiController村委会成员API")
class CommitteeMemberApiControllerTest {

    @Mock private CommitteeMemberService committeeMemberService;

    @InjectMocks private CommitteeMemberApiController committeeMemberApiController;

    @Nested
    @DisplayName("list - 分页查询成员")
    class ListMembers {

        @Test
        @DisplayName("应返回分页结果")
        void 应返回分页结果() {
            PageResult<CommitteeMember> pageResult = new PageResult<>(List.of(), 1, 10, 0);
            when(committeeMemberService.page(null, null, null, null)).thenReturn(pageResult);

            ResponseEntity<PageResult<CommitteeMember>> result = committeeMemberApiController.list(null, null, null, null);

            assertEquals(HttpStatus.OK, result.getStatusCode());
            assertEquals(0, result.getBody().getTotal());
        }
    }

    @Nested
    @DisplayName("listActive - 获取在职成员")
    class ListActiveMembers {

        @Test
        @DisplayName("应返回在职成员列表")
        void 应返回在职成员() {
            CommitteeMember m = new CommitteeMember();
            m.setName("王五");
            m.setIsActive(true);
            when(committeeMemberService.listActive()).thenReturn(List.of(m));

            ResponseEntity<List<CommitteeMember>> result = committeeMemberApiController.listActive();

            assertEquals(HttpStatus.OK, result.getStatusCode());
            assertEquals(1, result.getBody().size());
        }
    }

    @Nested
    @DisplayName("get - 获取单个成员")
    class GetMember {

        @Test
        @DisplayName("存在的成员应返回成员对象")
        void 存在的成员应返回() {
            CommitteeMember m = new CommitteeMember();
            m.setId(1L);
            m.setName("王五");
            when(committeeMemberService.get(1L)).thenReturn(m);

            ResponseEntity<CommitteeMember> result = committeeMemberApiController.get(1L);

            assertEquals(HttpStatus.OK, result.getStatusCode());
            assertEquals(1L, result.getBody().getId());
        }

        @Test
        @DisplayName("不存在的成员应抛出404异常")
        void 不存在的成员应抛出四零四() {
            when(committeeMemberService.get(999L)).thenReturn(null);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> committeeMemberApiController.get(999L));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }

    @Nested
    @DisplayName("create - 创建成员")
    class CreateMember {

        @Test
        @DisplayName("创建成功应返回201状态码")
        void 创建成功应返回二零一() {
            CommitteeMember m = new CommitteeMember();
            m.setName("王五");
            m.setPosition("村主任");
            when(committeeMemberService.create(any(CommitteeMember.class))).thenReturn(m);

            ResponseEntity<CommitteeMember> result = committeeMemberApiController.create(m, null);

            assertEquals(HttpStatus.CREATED, result.getStatusCode());
        }
    }

    @Nested
    @DisplayName("update - 更新成员")
    class UpdateMember {

        @Test
        @DisplayName("更新成功应返回成员对象")
        void 更新成功应返回成员() {
            CommitteeMember m = new CommitteeMember();
            m.setName("王五");
            m.setPosition("村主任");
            when(committeeMemberService.update(1L, m)).thenReturn(true);

            ResponseEntity<CommitteeMember> result = committeeMemberApiController.update(1L, m);

            assertEquals(HttpStatus.OK, result.getStatusCode());
        }

        @Test
        @DisplayName("更新不存在的成员应抛出404异常")
        void 更新不存在应抛出四零四() {
            CommitteeMember m = new CommitteeMember();
            m.setName("王五");
            m.setPosition("村主任");
            when(committeeMemberService.update(999L, m)).thenReturn(false);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> committeeMemberApiController.update(999L, m));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }

    @Nested
    @DisplayName("delete - 删除成员")
    class DeleteMember {

        @Test
        @DisplayName("删除成功应返回204状态码")
        void 删除成功应返回二零四() {
            when(committeeMemberService.delete(1L)).thenReturn(true);

            ResponseEntity<Void> result = committeeMemberApiController.delete(1L);

            assertEquals(HttpStatus.NO_CONTENT, result.getStatusCode());
        }

        @Test
        @DisplayName("删除不存在的成员应抛出404异常")
        void 删除不存在应抛出四零四() {
            when(committeeMemberService.delete(999L)).thenReturn(false);

            ResponseStatusException ex = assertThrows(ResponseStatusException.class,
                () -> committeeMemberApiController.delete(999L));
            assertEquals(HttpStatus.NOT_FOUND, ex.getStatusCode());
        }
    }
}
