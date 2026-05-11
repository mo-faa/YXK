package com.village.committee.service;

import com.village.committee.domain.*;
import com.village.committee.mapper.*;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.*;
import org.mockito.*;
import org.mockito.junit.jupiter.*;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AuthService认证服务")
class AuthServiceTest {

    @Mock private UserMapper userMapper;
    @Mock private UserRoleMapper userRoleMapper;
    @Mock private RoleMapper roleMapper;
    @Mock private PermissionMapper permissionMapper;

    @InjectMocks private AuthService authService;

    @Nested
    @DisplayName("authenticate - 用户认证")
    class Authenticate {

        @Test
        @DisplayName("用户不存在应返回null")
        void 用户不存在应返回null() {
            when(userMapper.findEnabledByUsername("unknown")).thenReturn(null);
            assertNull(authService.authenticate("unknown", "password"));
        }

        @Test
        @DisplayName("密码错误应返回null")
        void 密码错误应返回null() {
            User user = new User();
            user.setId(1L);
            user.setUsername("admin");
            user.setPasswordHash("$2b$12$ndhZsY0Loz6GwBI4IP0GfueTBP3gD0ZclRnlScqT9wnL4v7.w6IEO");
            when(userMapper.findEnabledByUsername("admin")).thenReturn(user);

            assertNull(authService.authenticate("admin", "wrongpassword"));
        }

        @Test
        @DisplayName("正确密码应返回用户对象")
        void 正确密码应返回用户() {
            User user = new User();
            user.setId(1L);
            user.setUsername("admin");
            user.setPasswordHash("$2b$12$ndhZsY0Loz6GwBI4IP0GfueTBP3gD0ZclRnlScqT9wnL4v7.w6IEO");
            when(userMapper.findEnabledByUsername("admin")).thenReturn(user);

            User result = authService.authenticate("admin", "admin123");
            assertNotNull(result);
            assertEquals("admin", result.getUsername());
            verify(userMapper).updateLoginInfo(1L);
        }
    }

    @Nested
    @DisplayName("register - 用户注册")
    class Register {

        @Test
        @DisplayName("用户名已存在应抛出异常")
        void 用户名已存在应抛出异常() {
            when(userMapper.findByUsername("existing")).thenReturn(new User());
            assertThrows(RuntimeException.class, () -> authService.register("existing", "pass", null, null));
        }

        @Test
        @DisplayName("新用户注册应成功并分配默认角色")
        void 新用户注册应成功() {
            when(userMapper.findByUsername("newuser")).thenReturn(null);

            Role userRole = new Role();
            userRole.setId(3L);
            userRole.setCode("USER");
            when(roleMapper.findByCode("USER")).thenReturn(userRole);

            User result = authService.register("newuser", "password123", "新用户", "张三");

            assertNotNull(result);
            assertEquals("newuser", result.getUsername());
            assertEquals("新用户", result.getNickname());
            assertEquals("张三", result.getRealName());
            assertTrue(result.isEnabled());
            verify(userMapper).insert(any(User.class));
            verify(userRoleMapper).insert(any(UserRole.class));
        }

        @Test
        @DisplayName("昵称为null时应使用用户名作为昵称")
        void 昵称为null时使用用户名() {
            when(userMapper.findByUsername("testuser")).thenReturn(null);
            when(roleMapper.findByCode("USER")).thenReturn(null);

            User result = authService.register("testuser", "pass", null, null);
            assertEquals("testuser", result.getNickname());
        }
    }

    @Nested
    @DisplayName("hasPermission - 权限检查")
    class HasPermission {

        @Test
        @DisplayName("有权限应返回true")
        void 有权限应返回true() {
            Permission p = new Permission();
            p.setCode("user:view");
            when(permissionMapper.findByUserId(1L)).thenReturn(List.of(p));

            assertTrue(authService.hasPermission(1L, "user:view"));
        }

        @Test
        @DisplayName("无权限应返回false")
        void 无权限应返回false() {
            Permission p = new Permission();
            p.setCode("user:view");
            when(permissionMapper.findByUserId(1L)).thenReturn(List.of(p));

            assertFalse(authService.hasPermission(1L, "user:delete"));
        }

        @Test
        @DisplayName("空权限列表应返回false")
        void 空权限列表应返回false() {
            when(permissionMapper.findByUserId(1L)).thenReturn(Collections.emptyList());
            assertFalse(authService.hasPermission(1L, "user:view"));
        }
    }

    @Nested
    @DisplayName("hasAnyRole - 角色检查")
    class HasAnyRole {

        @Test
        @DisplayName("拥有指定角色应返回true")
        void 拥有指定角色应返回true() {
            Role adminRole = new Role();
            adminRole.setCode("ADMIN");
            when(roleMapper.findByUserId(1L)).thenReturn(List.of(adminRole));

            assertTrue(authService.hasAnyRole(1L, "ADMIN", "MANAGER"));
        }

        @Test
        @DisplayName("不拥有指定角色应返回false")
        void 不拥有指定角色应返回false() {
            Role userRole = new Role();
            userRole.setCode("USER");
            when(roleMapper.findByUserId(1L)).thenReturn(List.of(userRole));

            assertFalse(authService.hasAnyRole(1L, "ADMIN", "MANAGER"));
        }
    }

    @Nested
    @DisplayName("changePassword - 修改密码")
    class ChangePassword {

        @Test
        @DisplayName("用户不存在应抛出异常")
        void 用户不存在应抛出异常() {
            when(userMapper.findById(999L)).thenReturn(null);
            assertThrows(RuntimeException.class, () -> authService.changePassword(999L, "old", "new"));
        }

        @Test
        @DisplayName("原密码错误应抛出异常")
        void 原密码错误应抛出异常() {
            User user = new User();
            user.setId(1L);
            user.setPasswordHash("$2b$12$ndhZsY0Loz6GwBI4IP0GfueTBP3gD0ZclRnlScqT9wnL4v7.w6IEO");
            when(userMapper.findById(1L)).thenReturn(user);

            assertThrows(RuntimeException.class, () -> authService.changePassword(1L, "wrongold", "newpass"));
        }
    }

    @Nested
    @DisplayName("deleteUser - 删除用户")
    class DeleteUser {

        @Test
        @DisplayName("删除用户应先删除角色关联再删除用户")
        void 删除用户应先删除角色() {
            authService.deleteUser(1L, "admin");
            InOrder inOrder = inOrder(userRoleMapper, userMapper);
            inOrder.verify(userRoleMapper).deleteByUserId(1L);
            inOrder.verify(userMapper).deleteById(1L);
        }
    }

    @Nested
    @DisplayName("toggleUserStatus - 切换用户状态")
    class ToggleUserStatus {

        @Test
        @DisplayName("启用用户应变为禁用")
        void 启用变禁用() {
            User user = new User();
            user.setId(1L);
            user.setEnabled(true);
            when(userMapper.findById(1L)).thenReturn(user);

            authService.toggleUserStatus(1L, "admin");
            verify(userMapper).updateStatus(1L, false);
        }

        @Test
        @DisplayName("用户不存在应抛出异常")
        void 用户不存在应抛出异常() {
            when(userMapper.findById(999L)).thenReturn(null);
            assertThrows(RuntimeException.class, () -> authService.toggleUserStatus(999L, "admin"));
        }
    }

    @Nested
    @DisplayName("updateUser - 更新用户")
    class UpdateUser {

        @Test
        @DisplayName("用户不存在应抛出异常")
        void 用户不存在应抛出异常() {
            when(userMapper.findById(999L)).thenReturn(null);
            assertThrows(RuntimeException.class, () -> authService.updateUser(999L, new User(), null, "admin"));
        }

        @Test
        @DisplayName("更新用户应先删除旧角色再添加新角色")
        void 更新用户应更新角色() {
            User existing = new User();
            existing.setId(1L);
            when(userMapper.findById(1L)).thenReturn(existing);

            User updateData = new User();
            updateData.setNickname("新昵称");
            updateData.setRealName("新名字");
            updateData.setPhone("13800138000");
            updateData.setEmail("new@example.com");

            authService.updateUser(1L, updateData, List.of(1L, 2L), "admin");

            verify(userMapper).update(existing);
            verify(userRoleMapper).deleteByUserId(1L);
            verify(userRoleMapper, times(2)).insert(any(UserRole.class));
        }
    }
}
