package ru.productmanager.dto;

import ru.productmanager.model.ExcludedProduct;
import ru.productmanager.model.ProductCategory;

public record ExcludedProductResponse(Long productId, String name, ProductCategory category) {
    public static ExcludedProductResponse from(ExcludedProduct excluded) {
        return new ExcludedProductResponse(
                excluded.getProduct().getId(),
                excluded.getProduct().getName(),
                excluded.getProduct().getCategory());
    }
}
