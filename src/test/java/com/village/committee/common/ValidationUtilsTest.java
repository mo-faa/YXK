package com.village.committee.common;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ValidationUtils")
class ValidationUtilsTest {

    @Nested
    @DisplayName("身份证号验证")
    class IdCardValidation {

        @Test
        @DisplayName("null应返回true")
        void nullIdCard() {
            assertTrue(ValidationUtils.isValidIdCard(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void emptyIdCard() {
            assertTrue(ValidationUtils.isValidIdCard(""));
            assertTrue(ValidationUtils.isValidIdCard("   "));
        }

        @Test
        @DisplayName("正确的18位身份证号应返回true")
        void validIdCard() {
            assertTrue(ValidationUtils.isValidIdCard("110101199001010015"));
        }

        @Test
        @DisplayName("末位为X的身份证号应返回true")
        void idCardEndingWithX() {
            assertTrue(ValidationUtils.isValidIdCard("11010519491231002X"));
            assertTrue(ValidationUtils.isValidIdCard("11010519491231002x"));
        }

        @Test
        @DisplayName("长度不为18位应返回false")
        void wrongLength() {
            assertFalse(ValidationUtils.isValidIdCard("1101011990030775"));
            assertFalse(ValidationUtils.isValidIdCard("1101011990030775361"));
        }

        @Test
        @DisplayName("校验码错误应返回false")
        void wrongCheckCode() {
            assertFalse(ValidationUtils.isValidIdCard("110101199001010016"));
        }

        @Test
        @DisplayName("包含字母应返回false（末位X除外）")
        void containsLetters() {
            assertFalse(ValidationUtils.isValidIdCard("11010119900307A536"));
        }

        @Test
        @DisplayName("地区码以0开头应返回false")
        void regionCodeStartsWithZero() {
            assertFalse(ValidationUtils.isValidIdCard("010101199003077536"));
        }
    }

    @Nested
    @DisplayName("身份证号错误消息")
    class IdCardErrorMessage {

        @Test
        @DisplayName("null应返回null")
        void nullInput() {
            assertNull(ValidationUtils.getIdCardErrorMessage(null));
        }

        @Test
        @DisplayName("空字符串应返回null")
        void emptyInput() {
            assertNull(ValidationUtils.getIdCardErrorMessage(""));
        }

        @Test
        @DisplayName("长度不为18应返回对应消息")
        void wrongLengthMessage() {
            assertEquals("身份证号必须为18位", ValidationUtils.getIdCardErrorMessage("12345"));
        }

        @Test
        @DisplayName("校验码错误应返回对应消息")
        void checkCodeErrorMessage() {
            String msg = ValidationUtils.getIdCardErrorMessage("110101199001010016");
            assertNotNull(msg);
            assertTrue(msg.contains("校验码错误"));
        }

        @Test
        @DisplayName("正确身份证号应返回null")
        void validIdCardReturnsNull() {
            assertNull(ValidationUtils.getIdCardErrorMessage("110101199001010015"));
        }
    }

    @Nested
    @DisplayName("手机号验证")
    class PhoneValidation {

        @Test
        @DisplayName("null应返回true")
        void nullPhone() {
            assertTrue(ValidationUtils.isValidPhone(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void emptyPhone() {
            assertTrue(ValidationUtils.isValidPhone(""));
        }

        @ParameterizedTest
        @DisplayName("有效手机号应返回true")
        @ValueSource(strings = {"13800138000", "15912345678", "18612345678", "19999999999"})
        void validMobilePhones(String phone) {
            assertTrue(ValidationUtils.isValidPhone(phone));
        }

        @Test
        @DisplayName("座机号应返回true")
        void landlinePhone() {
            assertTrue(ValidationUtils.isValidPhone("01012345678"));
            assertTrue(ValidationUtils.isValidPhone("07551234567"));
        }

        @ParameterizedTest
        @DisplayName("无效手机号应返回false")
        @ValueSource(strings = {"12345678901", "23456789012", "1380013800", "138001380001"})
        void invalidMobilePhones(String phone) {
            assertFalse(ValidationUtils.isValidMobilePhone(phone));
        }

        @Test
        @DisplayName("手机号包含横线空格应正确处理")
        void phoneWithDash() {
            assertTrue(ValidationUtils.isValidPhone("138-0013-8000"));
            assertTrue(ValidationUtils.isValidPhone("138 0013 8000"));
        }
    }

    @Nested
    @DisplayName("中文名字验证")
    class ChineseNameValidation {

        @Test
        @DisplayName("null应返回true")
        void nullName() {
            assertTrue(ValidationUtils.isValidChineseName(null));
        }

        @Test
        @DisplayName("空字符串应返回true")
        void emptyName() {
            assertTrue(ValidationUtils.isValidChineseName(""));
        }

        @ParameterizedTest
        @DisplayName("有效中文名字应返回true")
        @ValueSource(strings = {"张三", "李四四", "欧阳修", "古丽娜扎"})
        void validChineseNames(String name) {
            assertTrue(ValidationUtils.isValidChineseName(name));
        }

        @Test
        @DisplayName("包含间隔号的名字应返回true")
        void nameWithDot() {
            assertTrue(ValidationUtils.isValidChineseName("买买提·阿力"));
        }

        @ParameterizedTest
        @DisplayName("无效名字应返回false")
        @ValueSource(strings = {"A", "1", "张", "abc", "张三李四王五赵六"})
        void invalidChineseNames(String name) {
            assertFalse(ValidationUtils.isValidChineseName(name));
        }
    }

    @Nested
    @DisplayName("地址验证")
    class AddressValidation {

        @Test
        @DisplayName("null应返回true")
        void nullAddress() {
            assertTrue(ValidationUtils.isValidChineseAddress(null));
        }

        @Test
        @DisplayName("有效地址应返回true")
        void validAddress() {
            assertTrue(ValidationUtils.isValidChineseAddress("北京市朝阳区建国路1号"));
            assertTrue(ValidationUtils.isValidChineseAddress("湖南省长沙市岳麓区"));
        }

        @Test
        @DisplayName("不含中文地址关键词应返回false")
        void noAddressKeyword() {
            assertFalse(ValidationUtils.isValidChineseAddress("abcdefg"));
        }
    }

    @Nested
    @DisplayName("年龄验证")
    class AgeValidation {

        @Test
        @DisplayName("null应返回true")
        void nullAge() {
            assertTrue(ValidationUtils.isValidAge(null));
        }

        @ParameterizedTest
        @DisplayName("有效年龄应返回true")
        @ValueSource(ints = {0, 1, 50, 100, 150})
        void validAges(int age) {
            assertTrue(ValidationUtils.isValidAge(age));
        }

        @ParameterizedTest
        @DisplayName("无效年龄应返回false")
        @ValueSource(ints = {-1, 151, 200})
        void invalidAges(int age) {
            assertFalse(ValidationUtils.isValidAge(age));
        }

        @Test
        @DisplayName("负年龄错误消息")
        void negativeAgeError() {
            assertEquals("年龄不能为负数", ValidationUtils.getAgeErrorMessage(-1));
        }

        @Test
        @DisplayName("超龄错误消息")
        void tooOldAgeError() {
            assertEquals("年龄不能超过150岁", ValidationUtils.getAgeErrorMessage(200));
        }
    }

    @Nested
    @DisplayName("内容安全验证")
    class ContentSafety {

        @Test
        @DisplayName("null应返回true")
        void nullContent() {
            assertTrue(ValidationUtils.isContentSafe(null));
        }

        @Test
        @DisplayName("正常内容应返回true")
        void safeContent() {
            assertTrue(ValidationUtils.isContentSafe("这是一条正常的公告内容"));
        }

        @Test
        @DisplayName("包含敏感词应返回false")
        void unsafeContent() {
            assertFalse(ValidationUtils.isContentSafe("这是一条包含敏感词1的内容"));
        }

        @Test
        @DisplayName("敏感词错误消息应包含敏感词")
        void safetyErrorMessage() {
            String msg = ValidationUtils.getContentSafetyErrorMessage("包含敏感词1的内容");
            assertNotNull(msg);
            assertTrue(msg.contains("敏感词1"));
        }
    }

    @Nested
    @DisplayName("HTML安全验证")
    class HtmlSafety {

        @Test
        @DisplayName("null应返回true")
        void nullHtml() {
            assertTrue(ValidationUtils.isHtmlSafe(null, false));
        }

        @Test
        @DisplayName("纯文本应返回true")
        void plainText() {
            assertTrue(ValidationUtils.isHtmlSafe("这是一段纯文本", false));
        }

        @Test
        @DisplayName("包含HTML标签不允许时应返回false")
        void htmlTagNotAllowed() {
            assertFalse(ValidationUtils.isHtmlSafe("<script>alert(1)</script>", false));
        }

        @Test
        @DisplayName("白名单标签允许时应返回true")
        void allowedTags() {
            assertTrue(ValidationUtils.isHtmlSafe("<p>段落</p>", true, "p"));
            assertTrue(ValidationUtils.isHtmlSafe("<strong>加粗</strong>", true, "strong"));
        }

        @Test
        @DisplayName("非白名单标签应返回false")
        void disallowedTags() {
            assertFalse(ValidationUtils.isHtmlSafe("<script>alert(1)</script>", true, "p"));
        }
    }

    @Nested
    @DisplayName("字符串工具方法")
    class StringUtilities {

        @Test
        @DisplayName("isBlank")
        void isBlank() {
            assertTrue(ValidationUtils.isBlank(null));
            assertTrue(ValidationUtils.isBlank(""));
            assertTrue(ValidationUtils.isBlank("   "));
            assertFalse(ValidationUtils.isBlank("abc"));
        }

        @Test
        @DisplayName("isNotBlank")
        void isNotBlank() {
            assertFalse(ValidationUtils.isNotBlank(null));
            assertTrue(ValidationUtils.isNotBlank("abc"));
        }

        @Test
        @DisplayName("trimToNull")
        void trimToNull() {
            assertNull(ValidationUtils.trimToNull(null));
            assertNull(ValidationUtils.trimToNull(""));
            assertNull(ValidationUtils.trimToNull("   "));
            assertEquals("abc", ValidationUtils.trimToNull("  abc  "));
        }

        @Test
        @DisplayName("trimToEmpty")
        void trimToEmpty() {
            assertEquals("", ValidationUtils.trimToEmpty(null));
            assertEquals("", ValidationUtils.trimToEmpty(""));
            assertEquals("abc", ValidationUtils.trimToEmpty("  abc  "));
        }
    }

    @Nested
    @DisplayName("敏感信息掩码")
    class Masking {

        @Nested
        @DisplayName("身份证号掩码")
        class IdCardMasking {

            @Test
            @DisplayName("null应返回空字符串")
            void nullInput() {
                assertEquals("", ValidationUtils.maskIdCard(null));
            }

            @Test
            @DisplayName("空字符串应返回空字符串")
            void emptyInput() {
                assertEquals("", ValidationUtils.maskIdCard(""));
            }

            @Test
            @DisplayName("18位身份证号应显示前4后4")
            void normalIdCard() {
                String result = ValidationUtils.maskIdCard("110101199001010015");
                assertEquals("1101**********0015", result);
            }

            @Test
            @DisplayName("短于8位应原样返回")
            void shortIdCard() {
                assertEquals("1234567", ValidationUtils.maskIdCard("1234567"));
            }

            @Test
            @DisplayName("8位应原样返回")
            void eightDigits() {
                assertEquals("12345678", ValidationUtils.maskIdCard("12345678"));
            }

            @Test
            @DisplayName("9位应显示前4后4中间10星号")
            void nineDigits() {
                String result = ValidationUtils.maskIdCard("123456789");
                assertEquals("1234**********6789", result);
            }
        }

        @Nested
        @DisplayName("手机号掩码")
        class PhoneMasking {

            @Test
            @DisplayName("null应返回空字符串")
            void nullInput() {
                assertEquals("", ValidationUtils.maskPhone(null));
            }

            @Test
            @DisplayName("空字符串应返回空字符串")
            void emptyInput() {
                assertEquals("", ValidationUtils.maskPhone(""));
            }

            @Test
            @DisplayName("11位手机号应显示前3后4")
            void normalPhone() {
                assertEquals("138****8000", ValidationUtils.maskPhone("13800138000"));
            }

            @Test
            @DisplayName("短于7位应原样返回")
            void shortPhone() {
                assertEquals("123456", ValidationUtils.maskPhone("123456"));
            }
        }
    }

    @Nested
    @DisplayName("年龄计算")
    class AgeCalculation {

        @Test
        @DisplayName("无效身份证号应返回null")
        void invalidIdCard() {
            assertNull(ValidationUtils.calculateAgeFromIdCard(null));
            assertNull(ValidationUtils.calculateAgeFromIdCard(""));
            assertNull(ValidationUtils.calculateAgeFromIdCard("12345"));
        }

        @Test
        @DisplayName("有效身份证号应返回合理年龄")
        void validIdCard() {
            Integer age = ValidationUtils.calculateAgeFromIdCard("110101199001010015");
            assertNotNull(age);
            assertTrue(age >= 30 && age <= 40, "1990年出生的人年龄应在30-40之间，实际为" + age);
        }

        @Test
        @DisplayName("1949年出生应返回合理年龄")
        void oldIdCard() {
            Integer age = ValidationUtils.calculateAgeFromIdCard("11010519491231002X");
            assertNotNull(age);
            assertTrue(age >= 70 && age <= 80, "1949年出生的人年龄应在70-80之间，实际为" + age);
        }
    }
}
