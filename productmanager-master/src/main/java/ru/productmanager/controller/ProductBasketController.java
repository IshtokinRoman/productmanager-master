package ru.productmanager.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import ru.productmanager.dto.BasketItemUpdateDto;
import ru.productmanager.dto.ProductBasketCreateDto;
import ru.productmanager.dto.ProductBasketResponse;
import ru.productmanager.model.ProductBasket;
import ru.productmanager.service.ProductBasketService;

import java.net.URI;

@RestController
@RequestMapping("/api/baskets")
@RequiredArgsConstructor
public class ProductBasketController {
    private final ProductBasketService service;

    @PostMapping
    public ResponseEntity<ProductBasketResponse> create(@Valid @RequestBody ProductBasketCreateDto dto) {
        ProductBasket basket = service.createFromPlan(dto.mealPlanId());
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}").buildAndExpand(basket.getId()).toUri();
        return ResponseEntity.created(location).body(ProductBasketResponse.from(basket));
    }

    @GetMapping("/{id}")
    public ProductBasketResponse get(@PathVariable Long id) {
        return ProductBasketResponse.from(service.getBasket(id));
    }

    @GetMapping("/by-plan/{mealPlanId}")
    public ProductBasketResponse getByPlan(@PathVariable Long mealPlanId) {
        return ProductBasketResponse.from(service.getByMealPlan(mealPlanId));
    }

    @PatchMapping("/{basketId}/items/{itemId}")
    public ProductBasketResponse updateItem(@PathVariable Long basketId,
                                            @PathVariable Long itemId,
                                            @Valid @RequestBody BasketItemUpdateDto dto) {
        return ProductBasketResponse.from(service.setPurchased(basketId, itemId, dto.purchased()));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}