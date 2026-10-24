package ru.productmanager.dto;

import ru.productmanager.model.Product;
import ru.productmanager.model.ProductCategory;

public record ProductResponse(
        Long id,
        String name,
        ProductCategory category,
        Double calories,
        Double protein,
        Double fat,
        Double carbohydrates
) {
    public static ProductResponse from(Product product) {
        return new ProductResponse(
                product.getId(),
                product.getName(),
                product.getCategory(),
                product.getCalories(),
                product.getProtein(),
                product.getFat(),
                product.getCarbohydrates());
    }
}