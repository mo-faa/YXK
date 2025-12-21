package com.village.committee.service;

import com.village.committee.common.PageResult;
import com.village.committee.common.Paging;
import com.village.committee.common.ValidationUtils;
import com.village.committee.domain.Announcement;
import com.village.committee.mapper.AnnouncementMapper;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

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
    public PageResult<Announcement> page(String q, Integer page, Integer size) {
        String query = Paging.normalizeQuery(q);
        int p = Paging.normalizePage(page);
        int s = Paging.normalizeSize(size, 10, 100);

        long total = announcementMapper.countByQuery(query);
        int offset = Paging.offset(p, s);

        if (total > 0 && offset >= total) {
            return new PageResult<>(List.of(), p, s, total);
        }

        List<Announcement> items = announcementMapper.findPage(query, offset, s);
        return new PageResult<>(items, p, s, total);
    }

    @Transactional(readOnly = true)
    public Announcement get(Long id) {
        return announcementMapper.findById(id);
    }

    /**
     * 验证公告数据（抛异常）
     */
    public void validate(Announcement announcement) {
        if (announcement == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "公告信息不能为空");
        }

        if (ValidationUtils.isBlank(announcement.getTitle())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "标题不能为空");
        }

        String title = announcement.getTitle().trim();
        if (title.length() > 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "标题不能超过100个字符");
        }

        if (ValidationUtils.isBlank(announcement.getContent())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "内容不能为空");
        }

        if (announcement.getContent().length() > 10000) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "内容不能超过10000个字符");
        }

        if (ValidationUtils.isBlank(announcement.getPublisher())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "发布人不能为空");
        }

        if (announcement.getPublisher().length() > 50) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "发布人不能超过50个字符");
        }
    }

    /**
     * 验证并返回错误消息（用于MVC控制器）
     */
    public String validateAndGetError(Announcement announcement) {
        if (announcement == null) {
            return "公告信息不能为空";
        }

        if (ValidationUtils.isBlank(announcement.getTitle())) {
            return "标题不能为空";
        }

        if (announcement.getTitle().trim().length() > 100) {
            return "标题不能超过100个字符";
        }

        if (ValidationUtils.isBlank(announcement.getContent())) {
            return "内容不能为空";
        }

        if (announcement.getContent().length() > 10000) {
            return "内容不能超过10000个字符";
        }

        if (ValidationUtils.isBlank(announcement.getPublisher())) {
            return "发布人不能为空";
        }

        if (announcement.getPublisher().length() > 50) {
            return "发布人不能超过50个字符";
        }

        return null;
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
