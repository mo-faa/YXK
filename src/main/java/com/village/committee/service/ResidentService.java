package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.domain.Resident;
import com.village.committee.mapper.ResidentMapper;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ResidentService {

    private final ResidentMapper residentMapper;

    public ResidentService(ResidentMapper residentMapper) {
        this.residentMapper = residentMapper;
    }

    public List<Resident> list() {
        return residentMapper.findAll();
    }

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

    /**
     * 导出：最多导出 10000 行，避免一次性拉爆内存/响应过大（可按需调大）
     */
    public List<Resident> export(String q) {
        String query = Paging.normalizeQuery(q);
        return residentMapper.findPage(query, 0, 10_000);
    }

    public Resident get(Long id) {
        return residentMapper.findById(id);
    }

    @Transactional
    public Resident create(Resident resident) {
        residentMapper.insert(resident);
        return resident;
    }

    @Transactional
    public boolean update(Long id, Resident resident) {
        resident.setId(id);
        return residentMapper.update(resident) > 0;
    }

    @Transactional
    public boolean delete(Long id) {
        return residentMapper.deleteById(id) > 0;
    }
}
