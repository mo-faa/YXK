package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.common.ValidationResult;
import com.village.committee.common.ValidationUtils;
import com.village.committee.domain.Announcement;
import com.village.committee.mapper.AnnouncementMapper;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AnnouncementService {

    private final AnnouncementMapper announcementMapper;

    public AnnouncementService(AnnouncementMapper announcementMapper) {
        this.announcementMapper = announcementMapper;
    }

    @Transactional(readOnly = true)
    public List<Announcement> list() {
        return announcementMapper.findAll();
    }

    @Transactional(readOnly = true)
    public long countAll() {
        return announcementMapper.count();
    }

    /**
     * 统计指定时间之后的公告数量
     */
    @Transactional(readOnly = true)
    public long countSince(LocalDateTime from) {
        return announcementMapper.countSince(from);
    }

    /**
     * 统计本月新增公告数量
     */
    @Transactional(readOnly = true)
    public long countThisMonth() {
        LocalDateTime firstDayOfMonth = LocalDateTime.now()
                .with(TemporalAdjusters.firstDayOfMonth())
                .withHour(0).withMinute(0).withSecond(0).withNano(0);
        return announcementMapper.countSince(firstDayOfMonth);
    }

    /**
     * 获取最新的N条公告
     */
    @Transactional(readOnly = true)
    public List<Announcement> latest(int limit) {
        if (limit <= 0) {
            limit = 5;
        }
        if (limit > 100) {
            limit = 100;
        }
        return announcementMapper.findLatest(limit);
    }

    @Transactional(readOnly = true)
    public PageResult<Announcement> page(String q, Integer status, Boolean isTop, Integer page, Integer size) {
        String query = Paging.normalizeQuery(q);
        int p = Paging.normalizePage(page);
        int s = Paging.normalizeSize(size, 10, 100);

        long total = announcementMapper.countByQuery(query, status, isTop);
        int offset = Paging.offset(p, s);

        if (total > 0 && offset >= total) {
            return new PageResult<>(List.of(), p, s, total);
        }

        List<Announcement> items = announcementMapper.findPage(query, status, isTop, offset, s);
        return new PageResult<>(items, p, s, total);
    }

    @Transactional(readOnly = true)
    public Announcement get(Long id) {
        return announcementMapper.findById(id);
    }

    private ValidationResult doValidate(Announcement announcement) {
        if (announcement == null) {
            return ValidationResult.error("公告信息不能为空");
        }

        if (ValidationUtils.isBlank(announcement.getTitle())) {
            return ValidationResult.error("标题不能为空");
        }

        String title = announcement.getTitle().trim();
        if (title.length() > 100) {
            return ValidationResult.error("标题不能超过100个字符");
        }

        String titleSafetyError = ValidationUtils.getContentSafetyErrorMessage(title);
        if (titleSafetyError != null) {
            return ValidationResult.error("标题" + titleSafetyError);
        }

        String titleHtmlError = ValidationUtils.getHtmlSafetyErrorMessage(title, false);
        if (titleHtmlError != null) {
            return ValidationResult.error("标题" + titleHtmlError);
        }

        if (ValidationUtils.isBlank(announcement.getContent())) {
            return ValidationResult.error("内容不能为空");
        }

        if (announcement.getContent().length() > 10000) {
            return ValidationResult.error("内容不能超过10000个字符");
        }

        String contentSafetyError = ValidationUtils.getContentSafetyErrorMessage(announcement.getContent());
        if (contentSafetyError != null) {
            return ValidationResult.error("内容" + contentSafetyError);
        }

        String contentHtmlError = ValidationUtils.getHtmlSafetyErrorMessage(
            announcement.getContent(), true, "p", "br", "div", "span", "strong", "em", "ul", "ol", "li", "h1", "h2", "h3", "h4", "h5", "h6");
        if (contentHtmlError != null) {
            return ValidationResult.error("内容" + contentHtmlError);
        }

        if (ValidationUtils.isBlank(announcement.getPublisher())) {
            return ValidationResult.error("发布人不能为空");
        }

        if (announcement.getPublishTime() != null && announcement.getPublishTime().isAfter(LocalDateTime.now().plusDays(1))) {
            return ValidationResult.error("发布时间不能是未来时间");
        }

        return ValidationResult.ok();
    }

    public void validate(Announcement announcement) {
        doValidate(announcement).orThrow();
    }

    public String validateAndGetError(Announcement announcement) {
        return doValidate(announcement).orNull();
    }

    /**
     * 规范化数据
     */
    private void normalize(Announcement announcement) {
        if (announcement.getTitle() != null) {
            announcement.setTitle(announcement.getTitle().trim());
        }
        if (announcement.getPublisher() != null) {
            announcement.setPublisher(announcement.getPublisher().trim());
        }
        if (announcement.getPublishTime() == null) {
            announcement.setPublishTime(LocalDateTime.now());
        }
        if (announcement.getIsTop() == null) {
            announcement.setIsTop(false);
        }
        if (announcement.getStatus() == null) {
            announcement.setStatus(1);
        }
    }

    @Transactional
    public Announcement create(Announcement announcement) {
        validate(announcement);
        normalize(announcement);
        announcementMapper.insert(announcement);
        return announcement;
    }

    @Transactional
    public boolean update(Long id, Announcement announcement) {
        validate(announcement);
        normalize(announcement);
        announcement.setId(id);
        return announcementMapper.update(announcement) > 0;
    }

    @Transactional
    public boolean delete(Long id) {
        return announcementMapper.deleteById(id) > 0;
    }
}
