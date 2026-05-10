package com.village.committee.web.api;

import com.village.committee.domain.Announcement;
import com.village.committee.service.AnnouncementService;
import java.util.List;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import static org.springframework.http.HttpStatus.*;

@RestController
@RequestMapping("/api/announcements")
public class AnnouncementApiController {

    private final AnnouncementService announcementService;

    public AnnouncementApiController(AnnouncementService announcementService) {
        this.announcementService = announcementService;
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Announcement> list() {
        return announcementService.list();
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Announcement get(@PathVariable("id") Long id) {
        Announcement a = announcementService.get(id);
        if (a == null) {
            throw new ResponseStatusException(NOT_FOUND, "Announcement not found: " + id);
        }
        return a;
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Announcement> create(@RequestBody Announcement announcement) {
        validate(announcement); // ✅ 关键：调用校验方法，让它“被用起来”
        Announcement created = announcementService.create(announcement);
        return ResponseEntity.status(CREATED).body(created);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Announcement update(@PathVariable("id") Long id, @RequestBody Announcement announcement) {
        validate(announcement); // ✅ 关键：调用校验方法，让它“被用起来”
        if (!announcementService.update(id, announcement)) {
            throw new ResponseStatusException(NOT_FOUND, "Announcement not found: " + id);
        }
        Announcement updated = announcementService.get(id);
        // 正常情况下 updated 不为空；若极端情况为空，也返回请求体（已更新成功）
        return updated != null ? updated : announcement;
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        if (!announcementService.delete(id)) {
            throw new ResponseStatusException(NOT_FOUND, "Announcement not found: " + id);
        }
        return ResponseEntity.noContent().build();
    }

    /**
     * 服务端兜底校验（防止绕过前端直接提交空值/超长）
     */
    private void validate(Announcement a) {
        if (a == null) {
            throw new ResponseStatusException(BAD_REQUEST, "Request body is required");
        }

        String title = a.getTitle();
        String content = a.getContent();
        String publisher = a.getPublisher();

        if (isBlank(title)) {
            throw new ResponseStatusException(BAD_REQUEST, "title is required");
        }
        if (title.trim().length() > 100) { // 对应表结构 title VARCHAR(100)
            throw new ResponseStatusException(BAD_REQUEST, "title too long (max 100)");
        }

        if (isBlank(content)) {
            throw new ResponseStatusException(BAD_REQUEST, "content is required");
        }

        if (isBlank(publisher)) {
            throw new ResponseStatusException(BAD_REQUEST, "publisher is required");
        }
        if (publisher.trim().length() > 50) { // 对应表结构 publisher VARCHAR(50)
            throw new ResponseStatusException(BAD_REQUEST, "publisher too long (max 50)");
        }
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
