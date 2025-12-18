package com.village.committee.web.api;

import com.village.committee.domain.Resident;
import com.village.committee.service.ResidentService;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/residents")
public class ResidentApiController {

    private final ResidentService residentService;

    public ResidentApiController(ResidentService residentService) {
        this.residentService = residentService;
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Resident> list() {
        return residentService.list();
    }

    @GetMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Resident get(@PathVariable("id") Long id) {
        Resident r = residentService.get(id);
        if (r == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }
        return r;
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Resident> create(@RequestBody Resident resident) {
        if (resident.getName() == null || resident.getName().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "name is required");
        }
        Resident created = residentService.create(resident);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public Resident update(@PathVariable("id") Long id, @RequestBody Resident resident) {
        if (resident.getName() == null || resident.getName().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "name is required");
        }
        boolean ok = residentService.update(id, resident);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }
        return residentService.get(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        boolean ok = residentService.delete(id);
        if (!ok) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Resident not found: " + id);
        }
        return ResponseEntity.noContent().build();
    }
}
