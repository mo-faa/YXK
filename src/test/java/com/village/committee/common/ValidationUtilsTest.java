package com.village.committee.common;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ValidationUtils工具类")
class ValidationUtilsTest {

    @Nested
    @DisplayName("isValidIdCard - 身份证验证")
    class IsValidIdCard {

        @Test
        @DisplayName("null应返回true（允许为空）")
        void null应返回true() {
            assertTrue(ValidationUtils.isValidIdCard(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void 空字符串应返回true() {
            assertTrue(ValidationUtils.isValidIdCard(""));
            assertTrue(ValidationUtils.isValidIdCard("   "));
        }

        @Test
        @DisplayName("有效18位身份证应返回true")
        void 有效身份证应返回true() {
            assertTrue(ValidationUtils.isValidIdCard("110101199003077758"));
        }

        @Test
        @DisplayName("末位为X的身份证应返回true")
        void 末位为X应返回true() {
            assertTrue(ValidationUtils.isValidIdCard("11010519491231002X"));
            assertTrue(ValidationUtils.isValidIdCard("11010519491231002x"));
        }

        @Test
        @DisplayName("15位身份证应返回false")
        void 十五位身份证应返回false() {
            assertFalse(ValidationUtils.isValidIdCard("110101900307775"));
        }

        @Test
        @DisplayName("17位身份证应返回false")
        void 十七位身份证应返回false() {
            assertFalse(ValidationUtils.isValidIdCard("11010119900307775"));
        }

        @Test
        @DisplayName("19位身份证应返回false")
        void 十九位身份证应返回false() {
            assertFalse(ValidationUtils.isValidIdCard("1101011990030777580"));
        }

        @Test
        @DisplayName("全数字身份证应返回false（校验码错误）")
        void 校验码错误应返回false() {
            assertFalse(ValidationUtils.isValidIdCard("110101199003077759"));
        }

        @Test
        @DisplayName("包含字母的身份证应返回false")
        void 包含字母应返回false() {
            assertFalse(ValidationUtils.isValidIdCard("11010119900307ABCD"));
        }

        @Test
        @DisplayName("地区码0开头应返回false")
        void 地区码0开头应返回false() {
            assertFalse(ValidationUtils.isValidIdCard("010101199003077758"));
        }
    }

    @Nested
    @DisplayName("getIdCardErrorMessage - 身份证错误消息")
    class GetIdCardErrorMessage {

        @Test
        @DisplayName("null应返回null")
        void null应返回null() {
            assertNull(ValidationUtils.getIdCardErrorMessage(null));
        }

        @Test
        @DisplayName("空字符串应返回null")
        void 空字符串应返回null() {
            assertNull(ValidationUtils.getIdCardErrorMessage(""));
        }

        @Test
        @DisplayName("非18位应返回长度错误消息")
        void 非十八位应返回长度错误() {
            String msg = ValidationUtils.getIdCardErrorMessage("123");
            assertEquals("身份证号必须为18位", msg);
        }

        @Test
        @DisplayName("校验码错误应返回校验码错误消息")
        void 校验码错误应返回校验码错误() {
            String msg = ValidationUtils.getIdCardErrorMessage("110101199003077759");
            assertNotNull(msg);
            assertTrue(msg.contains("校验码错误"));
        }
    }

    @Nested
    @DisplayName("isValidPhone - 手机号验证")
    class IsValidPhone {

        @Test
        @DisplayName("null应返回true")
        void null应返回true() {
            assertTrue(ValidationUtils.isValidPhone(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void 空字符串应返回true() {
            assertTrue(ValidationUtils.isValidPhone(""));
        }

        @ParameterizedTest(name = "手机号{0}应返回{1}")
        @CsvSource({
            "13800138000, true",
            "15912345678, true",
            "18612345678, true",
            "19912345678, true",
            "12012345678, false",
            "1380013800, false",
            "138001380000, false",
            "abc12345678, false"
        })
        void 不同手机号验证(String phone, boolean expected) {
            assertEquals(expected, ValidationUtils.isValidPhone(phone));
        }

        @Test
        @DisplayName("座机号应返回true")
        void 座机号应返回true() {
            assertTrue(ValidationUtils.isValidPhone("010-12345678"));
            assertTrue(ValidationUtils.isValidPhone("075512345678"));
        }
    }

    @Nested
    @DisplayName("isValidMobilePhone - 严格手机号验证")
    class IsValidMobilePhone {

        @Test
        @DisplayName("座机号应返回false（严格模式）")
        void 座机号应返回false() {
            assertFalse(ValidationUtils.isValidMobilePhone("010-12345678"));
        }

        @Test
        @DisplayName("手机号应返回true")
        void 手机号应返回true() {
            assertTrue(ValidationUtils.isValidMobilePhone("13800138000"));
        }
    }

    @Nested
    @DisplayName("isValidChineseName - 中文名验证")
    class IsValidChineseName {

        @Test
        @DisplayName("null应返回true")
        void null应返回true() {
            assertTrue(ValidationUtils.isValidChineseName(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void 空字符串应返回true() {
            assertTrue(ValidationUtils.isValidChineseName(""));
        }

        @ParameterizedTest(name = "名字{0}应返回{1}")
        @CsvSource({
            "张三, true",
            "李四五, true",
            "欧阳修, true",
            "a, false",
            "张, false",
            "张三李四王五赵六, false",
            "123, false"
        })
        void 不同名字验证(String name, boolean expected) {
            assertEquals(expected, ValidationUtils.isValidChineseName(name));
        }

        @Test
        @DisplayName("包含间隔号的名字应返回true")
        void 包含间隔号应返回true() {
            assertTrue(ValidationUtils.isValidChineseName("古丽·阿依"));
        }
    }

    @Nested
    @DisplayName("isValidChineseAddress - 地址验证")
    class IsValidChineseAddress {

        @Test
        @DisplayName("null应返回true")
        void null应返回true() {
            assertTrue(ValidationUtils.isValidChineseAddress(null));
        }

        @Test
        @DisplayName("有效地址应返回true")
        void 有效地址应返回true() {
            assertTrue(ValidationUtils.isValidChineseAddress("北京市东城区某村1号"));
            assertTrue(ValidationUtils.isValidChineseAddress("湖南省长沙市岳麓区"));
        }

        @Test
        @DisplayName("纯数字地址应返回false")
        void 纯数字地址应返回false() {
            assertFalse(ValidationUtils.isValidChineseAddress("12345"));
        }

        @Test
        @DisplayName("纯英文地址应返回false")
        void 纯英文地址应返回false() {
            assertFalse(ValidationUtils.isValidChineseAddress("Beijing Road"));
        }
    }

    @Nested
    @DisplayName("isContentSafe - 内容安全验证")
    class IsContentSafe {

        @Test
        @DisplayName("null应返回true")
        void null应返回true() {
            assertTrue(ValidationUtils.isContentSafe(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void 空字符串应返回true() {
            assertTrue(ValidationUtils.isContentSafe(""));
        }

        @Test
        @DisplayName("正常内容应返回true")
        void 正常内容应返回true() {
            assertTrue(ValidationUtils.isContentSafe("今天天气很好"));
        }

        @Test
        @DisplayName("包含敏感词应返回false")
        void 包含敏感词应返回false() {
            assertFalse(ValidationUtils.isContentSafe("这是一个敏感词1的内容"));
        }
    }

    @Nested
    @DisplayName("isHtmlSafe - HTML安全验证")
    class IsHtmlSafe {

        @Test
        @DisplayName("null应返回true")
        void null应返回true() {
            assertTrue(ValidationUtils.isHtmlSafe(null, false));
        }

        @Test
        @DisplayName("纯文本应返回true")
        void 纯文本应返回true() {
            assertTrue(ValidationUtils.isHtmlSafe("Hello World", false));
        }

        @Test
        @DisplayName("包含script标签应返回false")
        void 包含script应返回false() {
            assertFalse(ValidationUtils.isHtmlSafe("<script>alert(1)</script>", false));
        }

        @Test
        @DisplayName("白名单标签允许时应返回true")
        void 白名单标签允许时应返回true() {
            assertTrue(ValidationUtils.isHtmlSafe("<b>粗体</b>", true, "b"));
        }

        @Test
        @DisplayName("白名单外标签应返回false")
        void 白名单外标签应返回false() {
            assertFalse(ValidationUtils.isHtmlSafe("<script>alert(1)</script>", true, "b"));
        }
    }

    @Nested
    @DisplayName("maskIdCard - 身份证脱敏")
    class MaskIdCard {

        @Test
        @DisplayName("null应返回空字符串")
        void null应返回空字符串() {
            assertEquals("", ValidationUtils.maskIdCard(null));
        }

        @Test
        @DisplayName("空字符串应返回空字符串")
        void 空字符串应返回空字符串() {
            assertEquals("", ValidationUtils.maskIdCard(""));
        }

        @Test
        @DisplayName("18位身份证应脱敏中间10位")
        void 十八位身份证应脱敏() {
            String result = ValidationUtils.maskIdCard("110101199003077758");
            assertEquals("1101**********7758", result);
        }

        @Test
        @DisplayName("8位以下应原样返回")
        void 八位以下应原样返回() {
            assertEquals("12345678", ValidationUtils.maskIdCard("12345678"));
        }
    }

    @Nested
    @DisplayName("maskPhone - 手机号脱敏")
    class MaskPhone {

        @Test
        @DisplayName("null应返回空字符串")
        void null应返回空字符串() {
            assertEquals("", ValidationUtils.maskPhone(null));
        }

        @Test
        @DisplayName("11位手机号应脱敏中间4位")
        void 十一位手机号应脱敏() {
            assertEquals("138****8000", ValidationUtils.maskPhone("13800138000"));
        }

        @Test
        @DisplayName("7位以下应原样返回")
        void 七位以下应原样返回() {
            assertEquals("1234567", ValidationUtils.maskPhone("1234567"));
        }
    }

    @Nested
    @DisplayName("字符串工具方法")
    class 字符串工具方法 {

        @Test
        @DisplayName("isBlank - null和空白应返回true")
        void isBlank测试() {
            assertTrue(ValidationUtils.isBlank(null));
            assertTrue(ValidationUtils.isBlank(""));
            assertTrue(ValidationUtils.isBlank("   "));
            assertFalse(ValidationUtils.isBlank("abc"));
        }

        @Test
        @DisplayName("isNotBlank - 非空白应返回true")
        void isNotBlank测试() {
            assertFalse(ValidationUtils.isNotBlank(null));
            assertFalse(ValidationUtils.isNotBlank(""));
            assertTrue(ValidationUtils.isNotBlank("abc"));
        }

        @Test
        @DisplayName("trimToNull - 空白应返回null")
        void trimToNull测试() {
            assertNull(ValidationUtils.trimToNull(null));
            assertNull(ValidationUtils.trimToNull(""));
            assertNull(ValidationUtils.trimToNull("   "));
            assertEquals("abc", ValidationUtils.trimToNull("  abc  "));
        }

        @Test
        @DisplayName("trimToEmpty - null应返回空字符串")
        void trimToEmpty测试() {
            assertEquals("", ValidationUtils.trimToEmpty(null));
            assertEquals("", ValidationUtils.trimToEmpty(""));
            assertEquals("abc", ValidationUtils.trimToEmpty("  abc  "));
        }
    }

    @Nested
    @DisplayName("calculateAgeFromIdCard - 从身份证计算年龄")
    class CalculateAgeFromIdCard {

        @Test
        @DisplayName("无效身份证应返回null")
        void 无效身份证应返回null() {
            assertNull(ValidationUtils.calculateAgeFromIdCard("invalid"));
        }

        @Test
        @DisplayName("null应返回null")
        void null应返回null() {
            assertNull(ValidationUtils.calculateAgeFromIdCard(null));
        }

        @Test
        @DisplayName("有效身份证应返回合理年龄")
        void 有效身份证应返回合理年龄() {
            Integer age = ValidationUtils.calculateAgeFromIdCard("110101199003077758");
            assertNotNull(age);
            assertTrue(age >= 30 && age <= 150, "年龄应在合理范围内，实际为" + age);
        }
    }

    @Nested
    @DisplayName("isValidAge - 年龄验证")
    class IsValidAge {

        @Test
        @DisplayName("null应返回true")
        void null应返回true() {
            assertTrue(ValidationUtils.isValidAge(null));
        }

        @ParameterizedTest(name = "年龄{0}应返回{1}")
        @CsvSource({
            "0, true",
            "1, true",
            "100, true",
            "150, true",
            "-1, false",
            "151, false",
            "200, false"
        })
        void 不同年龄验证(Integer age, boolean expected) {
            assertEquals(expected, ValidationUtils.isValidAge(age));
        }
    }

    @Nested
    @DisplayName("getAgeErrorMessage - 年龄错误消息")
    class GetAgeErrorMessage {

        @Test
        @DisplayName("null应返回null")
        void null应返回null() {
            assertNull(ValidationUtils.getAgeErrorMessage(null));
        }

        @Test
        @DisplayName("负数应返回不能为负数")
        void 负数应返回错误消息() {
            assertEquals("年龄不能为负数", ValidationUtils.getAgeErrorMessage(-1));
        }

        @Test
        @DisplayName("超过150应返回超过150岁")
        void 超过150应返回错误消息() {
            assertEquals("年龄不能超过150岁", ValidationUtils.getAgeErrorMessage(200));
        }

        @Test
        @DisplayName("合理年龄应返回null")
        void 合理年龄应返回null() {
            assertNull(ValidationUtils.getAgeErrorMessage(25));
        }
    }
}
