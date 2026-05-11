package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.domain.*;
import com.village.committee.mapper.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AuthService {

    private final UserMapper userMapper;
    private final UserRoleMapper userRoleMapper;
    private final RoleMapper roleMapper;
    private final PermissionMapper permissionMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UserMapper userMapper, UserRoleMapper userRoleMapper,
                        RoleMapper roleMapper, PermissionMapper permissionMapper) {
        this.userMapper = userMapper;
        this.userRoleMapper = userRoleMapper;
        this.roleMapper = roleMapper;
        this.permissionMapper = permissionMapper;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public User authenticate(String username, String password) {
        User user = userMapper.findEnabledByUsername(username);
        if (user == null) return null;
        if (!passwordEncoder.matches(password, user.getPasswordHash())) return null;
        userMapper.updateLoginInfo(user.getId());
        return user;
    }

    @Transactional
    public User register(String username, String password, String nickname, String realName) {
        if (userMapper.findByUsername(username) != null) {
            throw new RuntimeException("用户名已存在");
        }
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setNickname(nickname != null ? nickname : username);
        user.setRealName(realName);
        user.setEnabled(true);
        user.setLoginCount(0);
        userMapper.insert(user);

        Role defaultRole = roleMapper.findByCode("USER");
        if (defaultRole != null) {
            UserRole ur = new UserRole();
            ur.setUserId(user.getId());
            ur.setRoleId(defaultRole.getId());
            userRoleMapper.insert(ur);
        }
        return user;
    }

    public boolean hasPermission(Long userId, String permissionCode) {
        List<Permission> permissions = permissionMapper.findByUserId(userId);
        return permissions.stream().anyMatch(p -> p.getCode().equals(permissionCode));
    }

    public boolean hasAnyRole(Long userId, String... roleCodes) {
        List<Role> roles = roleMapper.findByUserId(userId);
        List<String> userRoleCodes = roles.stream().map(Role::getCode).collect(Collectors.toList());
        for (String code : roleCodes) {
            if (userRoleCodes.contains(code)) return true;
        }
        return false;
    }

    public List<String> getPermissionCodes(Long userId) {
        return permissionMapper.findByUserId(userId).stream()
                .map(Permission::getCode)
                .collect(Collectors.toList());
    }

    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userMapper.findById(userId);
        if (user == null) throw new RuntimeException("用户不存在");
        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new RuntimeException("原密码错误");
        }
        userMapper.updatePassword(userId, passwordEncoder.encode(newPassword));
    }

    public PageResult<User> findUsers(int page, int pageSize, String keyword) {
        int offset = Paging.offset(page, pageSize);
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", pageSize);
        if (keyword != null && !keyword.trim().isEmpty()) {
            params.put("keyword", "%" + keyword.trim() + "%");
        }
        List<User> users = userMapper.findWithPaging(params);
        int total = userMapper.countWithKeyword(keyword);
        return new PageResult<>(users, page, pageSize, total);
    }

    public User findById(Long id) {
        return userMapper.findById(id);
    }

    public List<Role> findAllRoles() {
        return roleMapper.findAll();
    }

    public List<Role> getUserRoles(Long userId) {
        return roleMapper.findByUserId(userId);
    }

    public List<Long> getUserRoleIds(Long userId) {
        return getUserRoles(userId).stream().map(Role::getId).collect(Collectors.toList());
    }

    @Transactional
    public void createUser(User user, List<Long> roleIds, String operator) {
        if (userMapper.findByUsername(user.getUsername()) != null) {
            throw new RuntimeException("用户名已存在");
        }
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        user.setEnabled(true);
        user.setLoginCount(0);
        userMapper.insert(user);

        if (roleIds != null && !roleIds.isEmpty()) {
            for (Long roleId : roleIds) {
                UserRole ur = new UserRole();
                ur.setUserId(user.getId());
                ur.setRoleId(roleId);
                userRoleMapper.insert(ur);
            }
        }
    }

    @Transactional
    public void updateUser(Long id, User user, List<Long> roleIds, String operator) {
        User existing = userMapper.findById(id);
        if (existing == null) throw new RuntimeException("用户不存在");

        existing.setNickname(user.getNickname());
        existing.setRealName(user.getRealName());
        existing.setPhone(user.getPhone());
        existing.setEmail(user.getEmail());
        userMapper.update(existing);

        userRoleMapper.deleteByUserId(id);
        if (roleIds != null && !roleIds.isEmpty()) {
            for (Long roleId : roleIds) {
                UserRole ur = new UserRole();
                ur.setUserId(id);
                ur.setRoleId(roleId);
                userRoleMapper.insert(ur);
            }
        }
    }

    @Transactional
    public void toggleUserStatus(Long id, String operator) {
        User user = userMapper.findById(id);
        if (user == null) throw new RuntimeException("用户不存在");
        Boolean currentStatus = user.isEnabled();
        user.setEnabled(!currentStatus);
        userMapper.updateStatus(user.getId(), user.isEnabled());
    }

    @Transactional
    public void deleteUser(Long id, String operator) {
        userRoleMapper.deleteByUserId(id);
        userMapper.deleteById(id);
    }

    public void resetPassword(Long id, String newPassword, String operator) {
        userMapper.updatePassword(id, passwordEncoder.encode(newPassword));
    }

    public int getTotalUserCount() {
        return userMapper.countAll();
    }

    public int getTodayLoginCount() {
        return userMapper.countTodayLogins();
    }
}
