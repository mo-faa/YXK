package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.common.ValidationUtils;
import com.village.committee.domain.CommitteeMember;
import com.village.committee.mapper.CommitteeMemberMapper;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

/**
 * 村委会成员服务类
 */
@Service
public class CommitteeMemberService {

    private final CommitteeMemberMapper committeeMemberMapper;

    public CommitteeMemberService(CommitteeMemberMapper committeeMemberMapper) {
        this.committeeMemberMapper = committeeMemberMapper;
    }

    @Transactional(readOnly = true)
    public List<CommitteeMember> list() {
        return committeeMemberMapper.findAll();
    }

    @Transactional(readOnly = true)
    public List<CommitteeMember> listActive() {
        return committeeMemberMapper.findActive();
    }

    @Transactional(readOnly = true)
    public long countAll() {
        return committeeMemberMapper.count(null);
    }

    @Transactional(readOnly = true)
    public long countSince(LocalDateTime from) {
        return committeeMemberMapper.countSince(from);
    }

    @Transactional(readOnly = true)
    public PageResult<CommitteeMember> page(String q, Integer page, Integer size) {
        String query = Paging.normalizeQuery(q);
        int p = Paging.normalizePage(page);
        int s = Paging.normalizeSize(size, 10, 100);

        long total = committeeMemberMapper.count(query);
        int offset = Paging.offset(p, s);

        // 超出页码时，返回空列表（不抛异常）
        if (total > 0 && offset >= total) {
            return new PageResult<>(List.of(), p, s, total);
        }

        List<CommitteeMember> items = committeeMemberMapper.findPage(query, offset, s);
        return new PageResult<>(items, p, s, total);
    }

    @Transactional(readOnly = true)
    public CommitteeMember get(Long id) {
        return committeeMemberMapper.findById(id);
    }

    /**
     * 验证村委会成员数据（抛异常）
     */
    public void validate(CommitteeMember member) {
        if (member == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "成员信息不能为空");
        }

        // 姓名必填且必须是中文
        if (ValidationUtils.isBlank(member.getName())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "姓名不能为空");
        }

        String nameError = ValidationUtils.getChineseNameErrorMessage(member.getName());
        if (nameError != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, nameError);
        }

        // 职务必填
        if (ValidationUtils.isBlank(member.getPosition())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "职务不能为空");
        }

        String position = member.getPosition().trim();
        if (position.length() > 50) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "职务不能超过50个字符");
        }

        // 职务安全校验
        String positionSafetyError = ValidationUtils.getContentSafetyErrorMessage(position);
        if (positionSafetyError != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "职务" + positionSafetyError);
        }

        // 电话号码校验（可选，但填了就必须正确）
        String phoneError = ValidationUtils.getPhoneErrorMessage(member.getPhone());
        if (phoneError != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, phoneError);
        }

        // 职责描述校验（可选）
        if (member.getDuties() != null && !member.getDuties().trim().isEmpty()) {
            if (member.getDuties().length() > 500) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "职责描述不能超过500个字符");
            }

            // 职责描述安全校验
            String dutiesSafetyError = ValidationUtils.getContentSafetyErrorMessage(member.getDuties());
            if (dutiesSafetyError != null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "职责描述" + dutiesSafetyError);
            }

            // 职责描述HTML校验 - 允许基本HTML标签
            String dutiesHtmlError = ValidationUtils.getHtmlSafetyErrorMessage(
                member.getDuties(), true, "p", "br", "div", "span", "strong", "em", "ul", "ol", "li");
            if (dutiesHtmlError != null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "职责描述" + dutiesHtmlError);
            }
        }

        // 任职时间校验
        if (member.getJoinTime() != null && member.getJoinTime().isAfter(LocalDateTime.now().plusDays(1))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "任职时间不能是未来时间");
        }
    }

    /**
     * 验证并返回错误消息（用于MVC控制器）
     * @return 错误消息，null表示验证通过
     */
    public String validateAndGetError(CommitteeMember member) {
        if (member == null) {
            return "成员信息不能为空";
        }

        // 姓名必填且必须是中文
        if (ValidationUtils.isBlank(member.getName())) {
            return "姓名不能为空";
        }

        String nameError = ValidationUtils.getChineseNameErrorMessage(member.getName());
        if (nameError != null) {
            return nameError;
        }

        // 职务必填
        if (ValidationUtils.isBlank(member.getPosition())) {
            return "职务不能为空";
        }

        String position = member.getPosition().trim();
        if (position.length() > 50) {
            return "职务不能超过50个字符";
        }

        // 职务安全校验
        String positionSafetyError = ValidationUtils.getContentSafetyErrorMessage(position);
        if (positionSafetyError != null) {
            return "职务" + positionSafetyError;
        }

        // 电话号码校验（可选，但填了就必须正确）
        String phoneError = ValidationUtils.getPhoneErrorMessage(member.getPhone());
        if (phoneError != null) {
            return phoneError;
        }

        // 职责描述校验（可选）
        if (member.getDuties() != null && !member.getDuties().trim().isEmpty()) {
            if (member.getDuties().length() > 500) {
                return "职责描述不能超过500个字符";
            }

            // 职责描述安全校验
            String dutiesSafetyError = ValidationUtils.getContentSafetyErrorMessage(member.getDuties());
            if (dutiesSafetyError != null) {
                return "职责描述" + dutiesSafetyError;
            }

            // 职责描述HTML校验 - 允许基本HTML标签
            String dutiesHtmlError = ValidationUtils.getHtmlSafetyErrorMessage(
                member.getDuties(), true, "p", "br", "div", "span", "strong", "em", "ul", "ol", "li");
            if (dutiesHtmlError != null) {
                return "职责描述" + dutiesHtmlError;
            }
        }

        // 任职时间校验
        if (member.getJoinTime() != null && member.getJoinTime().isAfter(LocalDateTime.now().plusDays(1))) {
            return "任职时间不能是未来时间";
        }

        return null;
    }

    /**
     * 规范化数据
     */
    private void normalize(CommitteeMember member) {
        if (member.getName() != null) {
            member.setName(member.getName().trim());
        }
        if (member.getPosition() != null) {
            member.setPosition(member.getPosition().trim());
        }
        if (member.getPhone() != null) {
            // 电话号码去除空格和横线
            member.setPhone(member.getPhone().trim().replaceAll("[\s-]", ""));
        }
        if (member.getDuties() != null) {
            member.setDuties(member.getDuties().trim());
        }
        if (member.getIsActive() == null) {
            member.setIsActive(true); // 默认在职
        }
        if (member.getJoinTime() == null) {
            member.setJoinTime(LocalDateTime.now());
        }
    }

    @Transactional
    public CommitteeMember create(CommitteeMember member) {
        validate(member);
        normalize(member);
        committeeMemberMapper.insert(member);
        return member;
    }

    @Transactional
    public boolean update(Long id, CommitteeMember member) {
        validate(member);
        normalize(member);
        member.setId(id);
        return committeeMemberMapper.update(member) > 0;
    }

    @Transactional
    public boolean delete(Long id) {
        return committeeMemberMapper.deleteById(id) > 0;
    }
}
