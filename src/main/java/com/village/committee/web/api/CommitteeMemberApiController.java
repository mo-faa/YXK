package com.village.committee.web.api;

import com.village.committee.common.PageResult;
import com.village.committee.domain.CommitteeMember;
import com.village.committee.service.CommitteeMemberService;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

/**
 * 村委会成员API控制器
 */
@RestController
@RequestMapping("/api/committee-members")
public class CommitteeMemberApiController {

    private final CommitteeMemberService committeeMemberService;

    public CommitteeMemberApiController(CommitteeMemberService committeeMemberService) {
        this.committeeMemberService = committeeMemberService;
    }

    /**
     * 获取所有成员
     */
    @GetMapping
    public ResponseEntity<PageResult<CommitteeMember>> list(
            @RequestParam(value = "q", required = false) String q,
            @RequestParam(value = "page", required = false) Integer page,
            @RequestParam(value = "size", required = false) Integer size) {

        PageResult<CommitteeMember> result = committeeMemberService.page(q, page, size);
        return ResponseEntity.ok(result);
    }

    /**
     * 获取在职成员
     */
    @GetMapping("/active")
    public ResponseEntity<List<CommitteeMember>> listActive() {
        List<CommitteeMember> members = committeeMemberService.listActive();
        return ResponseEntity.ok(members);
    }

    /**
     * 获取单个成员
     */
    @GetMapping("/{id}")
    public ResponseEntity<CommitteeMember> get(@PathVariable("id") Long id) {
        CommitteeMember member = committeeMemberService.get(id);
        if (member == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }
        return ResponseEntity.ok(member);
    }

    /**
     * 创建成员
     */
    @PostMapping
    public ResponseEntity<CommitteeMember> create(@RequestBody CommitteeMember member,
                                                   HttpServletRequest request) {
        committeeMemberService.validate(member);
        CommitteeMember created = committeeMemberService.create(member);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * 更新成员
     */
    @PutMapping("/{id}")
    public ResponseEntity<CommitteeMember> update(@PathVariable("id") Long id,
                                                   @RequestBody CommitteeMember member) {
        committeeMemberService.validate(member);
        boolean ok = committeeMemberService.update(id, member);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }
        return ResponseEntity.ok(member);
    }

    /**
     * 删除成员
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        boolean ok = committeeMemberService.delete(id);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Committee member not found: " + id);
        }
        return ResponseEntity.noContent().build();
    }

    /**
     * 处理验证异常
     */
    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ApiError> handleValidationException(ResponseStatusException ex, HttpServletRequest req) {
        int status = ex.getStatusCode().value();
        ApiError body = new ApiError(
                java.time.Instant.now(),
                status,
                ex.getStatusCode().toString(),
                ex.getReason(),
                req.getRequestURI(),
                null
        );
        return ResponseEntity.status(status).body(body);
    }
}
