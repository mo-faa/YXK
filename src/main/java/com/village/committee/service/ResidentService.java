// FILE: src/main/java/com/village/committee/service/ResidentService.java

package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.common.ValidationUtils;
import com.village.committee.domain.Resident;
import com.village.committee.mapper.ResidentMapper;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

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

    /**
     * 验证村民数据
     * @throws ResponseStatusException 如果验证失败
     */
    public void validate(Resident resident) {
        if (resident == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "村民信息不能为空");
        }

        // 姓名必填
        if (ValidationUtils.isBlank(resident.getName())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "姓名不能为空");
        }

        String name = resident.getName().trim();
        if (name.length() > 50) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "姓名不能超过50个字符");
        }

        // 身份证号校验（可选，但填了就必须正确）
        String idCardError = ValidationUtils.getIdCardErrorMessage(resident.getIdCard());
        if (idCardError != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, idCardError);
        }

        // 电话号码校验（可选，但填了就必须正确）
        String phoneError = ValidationUtils.getPhoneErrorMessage(resident.getPhone());
        if (phoneError != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, phoneError);
        }

        // 地址长度校验
        if (resident.getAddress() != null && resident.getAddress().length() > 255) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "地址不能超过255个字符");
        }
    }

    /**
     * 验证并返回错误消息（用于MVC控制器）
     * @return 错误消息，null表示验证通过
     */
    public String validateAndGetError(Resident resident) {
        if (resident == null) {
            return "村民信息不能为空";
        }

        if (ValidationUtils.isBlank(resident.getName())) {
            return "姓名不能为空";
        }

        String name = resident.getName().trim();
        if (name.length() > 50) {
            return "姓名不能超过50个字符";
        }

        String idCardError = ValidationUtils.getIdCardErrorMessage(resident.getIdCard());
        if (idCardError != null) {
            return idCardError;
        }

        String phoneError = ValidationUtils.getPhoneErrorMessage(resident.getPhone());
        if (phoneError != null) {
            return phoneError;
        }

        if (resident.getAddress() != null && resident.getAddress().length() > 255) {
            return "地址不能超过255个字符";
        }

        return null;
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
