
package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.common.ValidationResult;
import com.village.committee.common.ValidationUtils;
import com.village.committee.domain.Resident;
import com.village.committee.mapper.ResidentMapper;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ResidentService {

    private final ResidentMapper residentMapper;

    public ResidentService(ResidentMapper residentMapper) {
        this.residentMapper = residentMapper;
    }

    @Transactional(readOnly = true)
    public List<Resident> list() {
        return residentMapper.findAll();
    }

    @Transactional(readOnly = true)
    public long countAll() {
        return residentMapper.count(null);
    }

    @Transactional(readOnly = true)
    public long countSince(LocalDateTime from) {
        return residentMapper.countSince(from);
    }

    @Transactional(readOnly = true)
    public PageResult<Resident> page(String q, Integer page, Integer size) {
        String query = Paging.normalizeQuery(q);
        int p = Paging.normalizePage(page);
        int s = Paging.normalizeSize(size, 10, 100);

        long total = residentMapper.count(query);
        int offset = Paging.offset(p, s);

        // 超出页码时，返回空列表（不抛异常）
        if (total > 0 && offset >= total) {
            return new PageResult<>(List.of(), p, s, total);
        }

        List<Resident> items = residentMapper.findPage(query, offset, s);
        return new PageResult<>(items, p, s, total);
    }

    @Transactional(readOnly = true)
    public List<Resident> findPage(String q, int offset, int limit) {
        return residentMapper.findPage(q, offset, limit);
    }

    @Transactional(readOnly = true)
    public List<Resident> export(String q) {
        String query = Paging.normalizeQuery(q);
        return residentMapper.findPage(query, 0, 10_000);
    }

    @Transactional(readOnly = true)
    public Resident get(Long id) {
        return residentMapper.findById(id);
    }

    private ValidationResult doValidate(Resident resident) {
        if (resident == null) {
            return ValidationResult.error("村民信息不能为空");
        }

        if (ValidationUtils.isBlank(resident.getName())) {
            return ValidationResult.error("姓名不能为空");
        }

        String idCardError = ValidationUtils.getIdCardErrorMessage(resident.getIdCard());
        if (idCardError != null) {
            return ValidationResult.error(idCardError);
        }

        if (resident.getIdCard() != null && !resident.getIdCard().trim().isEmpty() && ValidationUtils.isValidIdCard(resident.getIdCard())) {
            Integer age = ValidationUtils.calculateAgeFromIdCard(resident.getIdCard());
            String ageError = ValidationUtils.getAgeErrorMessage(age);
            if (ageError != null) {
                return ValidationResult.error("根据身份证计算的年龄" + ageError);
            }
        }

        if (resident.getAddress() != null && !resident.getAddress().trim().isEmpty()) {
            if (resident.getAddress().length() > 255) {
                return ValidationResult.error("地址不能超过255个字符");
            }
        }

        return ValidationResult.ok();
    }

    public void validate(Resident resident) {
        doValidate(resident).orThrow();
    }

    public String validateAndGetError(Resident resident) {
        return doValidate(resident).orNull();
    }

    /**
     * 规范化村民数据（去除首尾空格、统一大小写等）
     */
    private void normalize(Resident resident) {
        if (resident.getName() != null) {
            resident.setName(resident.getName().trim());
        }
        if (resident.getIdCard() != null) {
            // 身份证号统一大写，去除空格
            resident.setIdCard(resident.getIdCard().trim().toUpperCase());
        }
        if (resident.getPhone() != null) {
            // 电话号码去除空格和横线
            resident.setPhone(resident.getPhone().trim().replaceAll("[\\s-]", ""));
        }
        if (resident.getAddress() != null) {
            resident.setAddress(resident.getAddress().trim());
        }
    }

    @Transactional
    public Resident create(Resident resident) {
        validate(resident);
        normalize(resident);
        residentMapper.insert(resident);
        return resident;
    }

    @Transactional
    public boolean update(Long id, Resident resident) {
        validate(resident);
        normalize(resident);
        resident.setId(id);
        return residentMapper.update(resident) > 0;
    }

    @Transactional
    public boolean delete(Long id) {
        return residentMapper.deleteById(id) > 0;
    }
}
