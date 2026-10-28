package ru.productmanager.dto;

import jakarta.validation.constraints.NotNull;

public record ExcludedProductAddDto(@NotNull Long productId) {
}
