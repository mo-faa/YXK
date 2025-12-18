package com.village.committee.mapper;

import com.village.committee.domain.Resident;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface ResidentMapper {

    @Select("""
            SELECT id, name, id_card, phone, address, created_at
            FROM residents
            ORDER BY id DESC
            """)
    List<Resident> findAll();

    @Select("""
            SELECT id, name, id_card, phone, address, created_at
            FROM residents
            WHERE id = #{id}
            """)
    Resident findById(@Param("id") Long id);

    @Insert("""
            INSERT INTO residents (name, id_card, phone, address)
            VALUES (#{name}, #{idCard}, #{phone}, #{address})
            """)
    @Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
    int insert(Resident resident);

    @Update("""
            UPDATE residents
            SET name = #{name},
                id_card = #{idCard},
                phone = #{phone},
                address = #{address}
            WHERE id = #{id}
            """)
    int update(Resident resident);

    @Delete("DELETE FROM residents WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
}
