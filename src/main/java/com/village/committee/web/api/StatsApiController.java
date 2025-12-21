
package com.village.committee.web.api;

import com.village.committee.domain.VisitDailyCount;
import com.village.committee.service.VisitService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/stats")
public class StatsApiController {

    private final VisitService visitService;

    public StatsApiController(VisitService visitService) {
        this.visitService = visitService;
    }

    @GetMapping("/visits")
    public List<VisitDailyCount> visits(@RequestParam(defaultValue = "7") int days) {
        return visitService.lastNDays(days);
    }
}
