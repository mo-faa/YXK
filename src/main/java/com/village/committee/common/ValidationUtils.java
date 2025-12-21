// FILE: src/main/java/com/village/committee/common/ValidationUtils.java

package com.village.committee.common;

import java.util.regex.Pattern;

/**
 * 通用验证工具类
 * 提供身份证、手机号等中国特色字段的校验
 */
public final class ValidationUtils {

    private ValidationUtils() {}

    // ==================== 身份证号验证 ====================

    /**
     * 18位身份证号正则（不含校验码验证）
     * 格式：6位地区码 + 8位生日 + 3位顺序码 + 1位校验码
     */
    private static final Pattern ID_CARD_PATTERN = Pattern.compile(
            "^[1-9]\\d{5}(19|20)\\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\\d|3[01])\\d{3}[0-9Xx]$"
    );

    /**
     * 身份证校验码加权因子
     */
    private static final int[] ID_CARD_WEIGHTS = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};

    /**
     * 身份证校验码映射
     */
    private static final char[] ID_CARD_CHECK_CODES = {'1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'};

    /**
     * 验证18位身份证号是否有效
     *
     * @param idCard 身份证号（允许为空，空值返回 true）
     * @return true=有效或为空，false=格式错误
     */
    public static boolean isValidIdCard(String idCard) {
        if (idCard == null || idCard.trim().isEmpty()) {
            return true; // 允许为空
        }

        String id = idCard.trim().toUpperCase();

        // 1. 基本格式校验
        if (!ID_CARD_PATTERN.matcher(id).matches()) {
            return false;
        }

        // 2. 校验码验证
        int sum = 0;
        for (int i = 0; i < 17; i++) {
            sum += (id.charAt(i) - '0') * ID_CARD_WEIGHTS[i];
        }
        char expectedCheckCode = ID_CARD_CHECK_CODES[sum % 11];
        char actualCheckCode = id.charAt(17);

        return expectedCheckCode == actualCheckCode;
    }

    /**
     * 获取身份证验证失败的原因
     */
    public static String getIdCardErrorMessage(String idCard) {
        if (idCard == null || idCard.trim().isEmpty()) {
            return null;
        }

        String id = idCard.trim().toUpperCase();

        if (id.length() != 18) {
            return "身份证号必须为18位";
        }

        if (!ID_CARD_PATTERN.matcher(id).matches()) {
            // 进一步细化错误信息
            String regionCode = id.substring(0, 6);
            if (!regionCode.matches("[1-9]\\d{5}")) {
                return "身份证号地区码无效";
            }

            String birthDate = id.substring(6, 14);
            String year = birthDate.substring(0, 4);
            String month = birthDate.substring(4, 6);
            String day = birthDate.substring(6, 8);

            int y = Integer.parseInt(year);
            int m = Integer.parseInt(month);
            int d = Integer.parseInt(day);

            if (y < 1900 || y > 2100) {
                return "身份证号出生年份无效";
            }
            if (m < 1 || m > 12) {
                return "身份证号出生月份无效";
            }
            if (d < 1 || d > 31) {
                return "身份证号出生日期无效";
            }

            return "身份证号格式不正确";
        }

        // 校验码错误
        int sum = 0;
        for (int i = 0; i < 17; i++) {
            sum += (id.charAt(i) - '0') * ID_CARD_WEIGHTS[i];
        }
        char expectedCheckCode = ID_CARD_CHECK_CODES[sum % 11];
        char actualCheckCode = id.charAt(17);

        if (expectedCheckCode != actualCheckCode) {
            return "身份证号校验码错误（末位应为 " + expectedCheckCode + "）";
        }

        return null;
    }

    // ==================== 手机号验证 ====================

    /**
     * 中国大陆手机号正则
     * 支持：13x, 14x, 15x, 16x, 17x, 18x, 19x
     */
    private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^1[3-9]\\d{9}$"
    );

    /**
     * 座机号正则（区号-号码 或 纯号码）
     */
    private static final Pattern LANDLINE_PATTERN = Pattern.compile(
            "^(0\\d{2,3}-?)?\\d{7,8}$"
    );

    /**
     * 验证手机号是否有效
     *
     * @param phone 手机号（允许为空，空值返回 true）
     * @return true=有效或为空
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true; // 允许为空
        }

        String p = phone.trim().replaceAll("[\\s-]", "");

        // 手机号或座机号都可以
        return PHONE_PATTERN.matcher(p).matches() || LANDLINE_PATTERN.matcher(p).matches();
    }

    /**
     * 验证是否为有效的手机号（严格模式，仅手机号）
     */
    public static boolean isValidMobilePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true;
        }
        String p = phone.trim().replaceAll("[\\s-]", "");
        return PHONE_PATTERN.matcher(p).matches();
    }

    /**
     * 获取手机号验证失败的原因
     */
    public static String getPhoneErrorMessage(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return null;
        }

        String p = phone.trim().replaceAll("[\\s-]", "");

        if (p.length() < 7) {
            return "电话号码太短";
        }

        if (p.length() > 12) {
            return "电话号码太长";
        }

        if (p.length() == 11 && !p.startsWith("1")) {
            return "手机号必须以1开头";
        }

        if (p.length() == 11 && !PHONE_PATTERN.matcher(p).matches()) {
            return "手机号格式不正确（应为11位有效手机号）";
        }

        if (!PHONE_PATTERN.matcher(p).matches() && !LANDLINE_PATTERN.matcher(p).matches()) {
            return "电话号码格式不正确";
        }

        return null;
    }

    // ==================== 通用字符串验证 ====================

    /**
     * 判断字符串是否为空白
     */
    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * 判断字符串是否非空白
     */
    public static boolean isNotBlank(String s) {
        return !isBlank(s);
    }

    /**
     * 安全裁剪字符串
     */
    public static String trimToNull(String s) {
        if (s == null) return null;
        String trimmed = s.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    /**
     * 安全裁剪字符串（空值转为空字符串）
     */
    public static String trimToEmpty(String s) {
        if (s == null) return "";
        return s.trim();
    }
}
