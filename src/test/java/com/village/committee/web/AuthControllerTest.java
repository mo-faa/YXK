package com.village.committee.web;

import com.village.committee.domain.User;
import com.village.committee.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.ui.Model;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AuthController认证控制器")
class AuthControllerTest {

    @Mock private AuthService authService;
    @Mock private HttpServletRequest request;
    @Mock private HttpSession session;
    @Mock private Model model;

    @InjectMocks private AuthController authController;

    @Nested
    @DisplayName("loginPage - 登录页面")
    class LoginPage {

        @Test
        @DisplayName("无error参数应返回登录页面")
        void 无error参数应返回登录页() {
            String view = authController.loginPage(null, model);
            assertEquals("auth/login", view);
            verify(model, never()).addAttribute(eq("loginError"), any());
        }

        @Test
        @DisplayName("有error参数应设置错误消息")
        void 有error参数应设置错误消息() {
            String view = authController.loginPage("1", model);
            assertEquals("auth/login", view);
            verify(model).addAttribute("loginError", "用户名或密码错误");
        }
    }

    @Nested
    @DisplayName("login - 登录处理")
    class Login {

        @Test
        @DisplayName("认证成功应重定向到首页并设置session")
        void 认证成功应重定向首页() {
            User user = new User();
            user.setId(1L);
            user.setUsername("admin");
            when(authService.authenticate("admin", "password")).thenReturn(user);
            when(request.getSession()).thenReturn(session);
            when(authService.getPermissionCodes(1L)).thenReturn(List.of("user:view"));

            String view = authController.login("admin", "password", request);

            assertEquals("redirect:/", view);
            verify(session).setAttribute("currentUser", user);
            verify(session).setAttribute("userId", 1L);
            verify(session).setAttribute("username", "admin");
            verify(session).setAttribute("permissions", List.of("user:view"));
        }

        @Test
        @DisplayName("认证失败应重定向到登录页带error参数")
        void 认证失败应重定向登录页() {
            when(authService.authenticate("admin", "wrong")).thenReturn(null);

            String view = authController.login("admin", "wrong", request);

            assertEquals("redirect:/login?error=1", view);
        }

        @Test
        @DisplayName("认证异常应重定向到登录页带error参数")
        void 认证异常应重定向登录页() {
            when(authService.authenticate("admin", "password")).thenThrow(new RuntimeException("DB error"));

            String view = authController.login("admin", "password", request);

            assertEquals("redirect:/login?error=1", view);
        }
    }

    @Nested
    @DisplayName("registerPage - 注册页面")
    class RegisterPage {

        @Test
        @DisplayName("应返回注册页面")
        void 应返回注册页面() {
            String view = authController.registerPage();
            assertEquals("auth/register", view);
        }
    }

    @Nested
    @DisplayName("register - 注册处理")
    class Register {

        @Test
        @DisplayName("密码不一致应重定向到注册页")
        void 密码不一致应重定向() {
            String view = authController.register("user", "pass1", "pass2", null, null);
            assertTrue(view.contains("register"));
        }

        @Test
        @DisplayName("注册成功应重定向到登录页")
        void 注册成功应重定向登录页() {
            User newUser = new User();
            newUser.setUsername("newuser");
            when(authService.register("newuser", "password", null, null)).thenReturn(newUser);

            String view = authController.register("newuser", "password", "password", null, null);
            assertTrue(view.contains("login"));
            assertTrue(view.contains("registered"));
        }

        @Test
        @DisplayName("用户名已存在应重定向到注册页带错误信息")
        void 用户名已存在应重定向() {
            when(authService.register("existing", "password", null, null))
                .thenThrow(new RuntimeException("用户名已存在"));

            String view = authController.register("existing", "password", "password", null, null);
            assertTrue(view.contains("register"));
            assertTrue(view.contains("error"));
        }
    }

    @Nested
    @DisplayName("logout - 登出")
    class Logout {

        @Test
        @DisplayName("登出应销毁session并重定向到登录页")
        void 登出应销毁Session() {
            when(request.getSession()).thenReturn(session);

            String view = authController.logout(request);

            assertEquals("redirect:/login", view);
            verify(session).invalidate();
        }
    }
}
