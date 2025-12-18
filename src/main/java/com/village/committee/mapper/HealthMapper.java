package com.village.committee.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface HealthMapper {

    @Select("SELECT 'OK'")
    String ping();
}
