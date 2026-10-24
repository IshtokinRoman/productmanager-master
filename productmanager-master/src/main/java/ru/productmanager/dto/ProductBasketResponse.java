package ru.productmanager.dto;

import ru.productmanager.model.ProductBasket;
import ru.productmanager.model.ProductCategory;

import java.time.Instant;
import java.util.Comparator;
import java.util.List;

public record ProductBasketResponse(
        Long id,
        Long mealPlanId,
        Instant createdAt,
        List<Item> items
) {
    public record Item(
            Long id,
            Long productId,
            String productName,
            ProductCategory category,
            double amount,
            boolean purchased
    ) {
    }

    public static ProductBasketResponse from(ProductBasket basket) {
        // группируем по категории продукта, внутри категории по названию
        Comparator<Item> order = Comparator
                .comparing((Item it) -> it.category() == null ? Integer.MAX_VALUE : it.category().ordinal())
                .thenComparing(Item::productName);

        List<Item> items = basket.getItems().stream()
                .map(i -> new Item(
                        i.getId(),
                        i.getProduct().getId(),
                        i.getProduct().getName(),
                        i.getProduct().getCategory(),
                        i.getAmount(),
                        i.isPurchased()))
                .sorted(order)
                .toList();

        return new ProductBasketResponse(
                basket.getId(),
                basket.getMealPlan().getId(),
                basket.getCreatedAt(),
                items);
    }
}
