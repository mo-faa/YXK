package com.village.committee.service;

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
