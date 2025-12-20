package com.village.committee.common;

import java.util.Collections;
import java.util.List;

public class PageResult<T> {
    private final List<T> items;
    private final int page;   // 1-based
    private final int size;
    private final long total;

    public PageResult(List<T> items, int page, int size, long total) {
        this.items = items == null ? Collections.emptyList() : items;
        this.page = page;
        this.size = size;
        this.total = total;
    }

    public List<T> getItems() {
        return items;
    }

    public int getPage() {
        return page;
    }

    public int getSize() {
        return size;
    }

    public long getTotal() {
        return total;
    }

    public long getTotalPages() {
        if (size <= 0) return 0;
        return (total + size - 1) / size;
    }

    public boolean isHasPrev() {
        return page > 1;
    }

    public boolean isHasNext() {
        return page < getTotalPages();
    }
}

