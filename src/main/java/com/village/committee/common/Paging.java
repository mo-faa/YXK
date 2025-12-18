package com.village.committee.common;

public final class Paging {
    private Paging() {}

    public static int normalizePage(Integer page) {
        if (page == null || page < 1) return 1;
        return page;
    }

    public static int normalizeSize(Integer size, int defaultSize, int maxSize) {
        int s = (size == null) ? defaultSize : size;
        if (s < 1) s = defaultSize;
        if (s > maxSize) s = maxSize;
        return s;
    }

    public static int offset(int page1Based, int size) {
        return (page1Based - 1) * size;
    }

    public static String normalizeQuery(String q) {
        if (q == null) return null;
        String t = q.trim();
        return t.isEmpty() ? null : t;
    }
}
