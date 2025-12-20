// FILE: src/main/java/com/village/committee/common/Paging.java

package com.village.committee.common;

/**
 * 分页参数处理工具
 */
public final class Paging {

    private Paging() {}

    /**
     * 规范化搜索关键词
     * - null 或空白字符串返回 null
     * - 去除首尾空格
     * - 限制最大长度100
     */
    public static String normalizeQuery(String q) {
        if (q == null || q.trim().isEmpty()) {
            return null;
        }
        String trimmed = q.trim();
        if (trimmed.length() > 100) {
            trimmed = trimmed.substring(0, 100);
        }
        return trimmed;
    }

    /**
     * 规范化页码（从1开始）
     * - null 或 小于1 返回 1
     * - 最大限制10000页
     */
    public static int normalizePage(Integer page) {
        if (page == null || page < 1) {
            return 1;
        }
        if (page > 10000) {
            return 10000;
        }
        return page;
    }

    /**
     * 规范化每页数量
     * @param size 输入值
     * @param defaultSize 默认值
     * @param maxSize 最大值
     */
    public static int normalizeSize(Integer size, int defaultSize, int maxSize) {
        if (size == null || size < 1) {
            return defaultSize;
        }
        if (size > maxSize) {
            return maxSize;
        }
        return size;
    }

    /**
     * 计算偏移量（数据库 OFFSET）
     */
    public static int offset(int page, int size) {
        return (page - 1) * size;
    }

    /**
     * 计算总页数
     */
    public static int totalPages(long total, int size) {
        if (total <= 0 || size <= 0) {
            return 0;
        }
        return (int) Math.ceil((double) total / size);
    }

    /**
     * 判断是否有下一页
     */
    public static boolean hasNext(int page, int size, long total) {
        return (long) page * size < total;
    }

    /**
     * 判断是否有上一页
     */
    public static boolean hasPrev(int page) {
        return page > 1;
    }
}
