
package com.village.committee.common;

import java.util.regex.Pattern;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;

/**
 * 通用验证工具类
 * 提供身份证、手机号、中文名字等中国特色字段的校验
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

    // ==================== 中文名字验证 ====================

    /**
     * 中文名字正则，支持2-4个汉字，可包含间隔号·
     */
    private static final Pattern CHINESE_NAME_PATTERN = Pattern.compile(
            "^[\u4e00-\u9fa5]{2,4}$|^[\u4e00-\u9fa5]{1,3}·[\u4e00-\u9fa5]{1,3}$"
    );

    /**
     * 验证是否为有效的中文名字
     *
     * @param name 名字（允许为空，空值返回 true）
     * @return true=有效或为空，false=格式错误
     */
    public static boolean isValidChineseName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return true; // 允许为空
        }

        String n = name.trim();
        return CHINESE_NAME_PATTERN.matcher(n).matches();
    }

    /**
     * 获取中文名字验证失败的原因
     */
    public static String getChineseNameErrorMessage(String name) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }

        String n = name.trim();

        if (n.length() < 2) {
            return "姓名至少需要2个字符";
        }

        if (n.length() > 4) {
            return "姓名不能超过4个字符";
        }

        if (!CHINESE_NAME_PATTERN.matcher(n).matches()) {
            return "姓名只能包含中文和间隔号·";
        }

        return null;
    }

    // ==================== 地址验证 ====================

    /**
     * 中国地址正则，简单验证地址格式
     */
    private static final Pattern CHINESE_ADDRESS_PATTERN = Pattern.compile(
            "^[\u4e00-\u9fa5]{2,}(省|市|区|县|镇|乡|街道|村|路|巷|号|室|栋|单元|层)[\u4e00-\u9fa50-9()（）#号-]*$"
    );

    /**
     * 验证是否为有效的中国地址
     *
     * @param address 地址（允许为空，空值返回 true）
     * @return true=有效或为空，false=格式错误
     */
    public static boolean isValidChineseAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            return true; // 允许为空
        }

        String a = address.trim();
        return CHINESE_ADDRESS_PATTERN.matcher(a).matches();
    }

    /**
     * 获取地址验证失败的原因
     */
    public static String getAddressErrorMessage(String address) {
        if (address == null || address.trim().isEmpty()) {
            return null;
        }

        String a = address.trim();

        if (a.length() < 5) {
            return "地址过于简短，请输入详细地址";
        }

        if (!CHINESE_ADDRESS_PATTERN.matcher(a).matches()) {
            return "地址格式不正确，应包含省市区县等行政区划信息";
        }

        return null;
    }

    // ==================== 年龄验证 ====================

    /**
     * 根据身份证号计算年龄
     *
     * @param idCard 身份证号
     * @return 年龄，如果身份证号无效返回null
     */
    public static Integer calculateAgeFromIdCard(String idCard) {
        if (!isValidIdCard(idCard)) {
            return null;
        }

        try {
            String id = idCard.trim().toUpperCase();
            String birthDateStr = id.substring(6, 14);
            LocalDate birthDate = LocalDate.parse(birthDateStr, DateTimeFormatter.ofPattern("yyyyMMdd"));
            return Period.between(birthDate, LocalDate.now()).getYears();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 验证年龄是否在合理范围内
     *
     * @param age 年龄
     * @return true=年龄合理，false=年龄不合理
     */
    public static boolean isValidAge(Integer age) {
        if (age == null) {
            return true; // 允许为空
        }
        return age >= 0 && age <= 150;
    }

    /**
     * 获取年龄验证失败的原因
     */
    public static String getAgeErrorMessage(Integer age) {
        if (age == null) {
            return null;
        }

        if (age < 0) {
            return "年龄不能为负数";
        }

        if (age > 150) {
            return "年龄不能超过150岁";
        }

        return null;
    }

    // ==================== 内容安全验证 ====================

    /**
     * 简单的敏感词列表（实际项目中应该使用更完善的敏感词库）
     */
    private static final String[] SENSITIVE_WORDS = {
        "敏感词1", "敏感词2", "敏感词3" // 示例，实际应替换为真实敏感词
    };

    /**
     * 检查文本是否包含敏感词
     *
     * @param text 文本内容
     * @return true=不包含敏感词，false=包含敏感词
     */
    public static boolean isContentSafe(String text) {
        if (text == null || text.trim().isEmpty()) {
            return true; // 允许为空
        }

        String t = text.trim().toLowerCase();
        for (String word : SENSITIVE_WORDS) {
            if (t.contains(word.toLowerCase())) {
                return false;
            }
        }
        return true;
    }

    /**
     * 获取内容安全验证失败的原因
     */
    public static String getContentSafetyErrorMessage(String text) {
        if (text == null || text.trim().isEmpty()) {
            return null;
        }

        String t = text.trim().toLowerCase();
        for (String word : SENSITIVE_WORDS) {
            if (t.contains(word.toLowerCase())) {
                return "内容包含敏感词：" + word;
            }
        }
        return null;
    }

    // ==================== HTML标签过滤 ====================

    /**
     * 简单的HTML标签正则
     */
    private static final Pattern HTML_TAG_PATTERN = Pattern.compile("<[^>]+>");

    /**
     * 检查文本是否包含HTML标签
     *
     * @param text 文本内容
     * @param allowAllowedTags 是否允许白名单中的标签
     * @param allowedTags 允许的HTML标签白名单
     * @return true=不包含非法HTML标签，false=包含非法HTML标签
     */
    public static boolean isHtmlSafe(String text, boolean allowAllowedTags, String... allowedTags) {
        if (text == null || text.trim().isEmpty()) {
            return true; // 允许为空
        }

        // 如果不允许任何HTML标签
        if (!allowAllowedTags) {
            return !HTML_TAG_PATTERN.matcher(text).find();
        }

        // 允许白名单中的HTML标签
        // 这里简化处理，实际项目中应使用更完善的HTML解析器
        String lowerText = text.toLowerCase();
        for (String tag : allowedTags) {
            lowerText = lowerText.replaceAll("<" + tag.toLowerCase() + "[^>]*>", "");
            lowerText = lowerText.replaceAll("</" + tag.toLowerCase() + ">", "");
        }

        return !HTML_TAG_PATTERN.matcher(lowerText).find();
    }

    /**
     * 获取HTML安全验证失败的原因
     */
    public static String getHtmlSafetyErrorMessage(String text, boolean allowAllowedTags, String... allowedTags) {
        if (text == null || text.trim().isEmpty()) {
            return null;
        }

        if (!isHtmlSafe(text, allowAllowedTags, allowedTags)) {
            if (allowAllowedTags && allowedTags.length > 0) {
                return "内容包含不允许的HTML标签，仅允许: " + String.join(", ", allowedTags);
            } else {
                return "内容不允许包含HTML标签";
            }
        }

        return null;
    }
}
