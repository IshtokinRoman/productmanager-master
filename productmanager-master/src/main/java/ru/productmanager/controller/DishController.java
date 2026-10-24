package ru.productmanager.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import ru.productmanager.dto.DishCreateDto;
import ru.productmanager.dto.DishResponse;
import ru.productmanager.model.Dish;
import ru.productmanager.service.DishService;

import java.net.URI;

@RestController
@RequestMapping("/api/dishes")
@RequiredArgsConstructor
public class DishController {
    private final DishService service;

    @PostMapping
    public ResponseEntity<DishResponse> create(@Valid @RequestBody DishCreateDto dto) {
        Dish saved = service.saveDish(dto);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}").buildAndExpand(saved.getId()).toUri();
        return ResponseEntity.created(location).body(DishResponse.from(saved));
    }

    @GetMapping("/{id}")
    public DishResponse get(@PathVariable Long id) {
        return DishResponse.from(service.getDish(id));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.deleteDish(id);
    }
}