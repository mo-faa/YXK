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

    @Select("""
            <script>
            SELECT id, name, id_card, phone, address, created_at
            FROM residents
            <where>
              <if test="q != null and q != ''">
                AND (
                    name LIKE CONCAT('%', #{q}, '%')
                    OR id_card LIKE CONCAT('%', #{q}, '%')
                    OR phone LIKE CONCAT('%', #{q}, '%')
                    OR address LIKE CONCAT('%', #{q}, '%')
                )
              </if>
            </where>
            ORDER BY id DESC
            LIMIT #{limit} OFFSET #{offset}
            </script>
            """)
    List<Resident> findPage(@Param("q") String q,
                           @Param("offset") int offset,
                           @Param("limit") int limit);

    @Select("""
            <script>
            SELECT COUNT(1)
            FROM residents
            <where>
              <if test="q != null and q != ''">
                AND (
                    name LIKE CONCAT('%', #{q}, '%')
                    OR id_card LIKE CONCAT('%', #{q}, '%')
                    OR phone LIKE CONCAT('%', #{q}, '%')
                    OR address LIKE CONCAT('%', #{q}, '%')
                )
              </if>
            </where>
            </script>
            """)
    long count(@Param("q") String q);

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
