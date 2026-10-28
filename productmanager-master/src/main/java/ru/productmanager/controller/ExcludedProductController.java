package ru.productmanager.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import ru.productmanager.dto.ExcludedProductAddDto;
import ru.productmanager.dto.ExcludedProductResponse;
import ru.productmanager.service.ExcludedProductService;

import java.util.List;

@RestController
@RequestMapping("/api/profiles/{profileId}/excluded-products")
@RequiredArgsConstructor
public class ExcludedProductController {
    private final ExcludedProductService service;

    @GetMapping
    public List<ExcludedProductResponse> list(@PathVariable Long profileId) {
        return service.list(profileId).stream().map(ExcludedProductResponse::from).toList();
    }

    @PostMapping
    public List<ExcludedProductResponse> add(@PathVariable Long profileId,
                                             @Valid @RequestBody ExcludedProductAddDto dto) {
        return service.add(profileId, dto.productId()).stream().map(ExcludedProductResponse::from).toList();
    }

    @DeleteMapping("/{productId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void remove(@PathVariable Long profileId, @PathVariable Long productId) {
        service.remove(profileId, productId);
    }
}
