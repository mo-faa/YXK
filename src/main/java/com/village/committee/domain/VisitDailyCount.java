
package com.village.committee.domain;

import java.time.LocalDate;

/**
 * Dashboard / 报表用：每日访问量统计
 */
public record VisitDailyCount(LocalDate date, long count) {}
