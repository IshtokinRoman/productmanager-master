package ru.productmanager.dto;

import jakarta.validation.constraints.NotNull;

public record ProductBasketCreateDto(@NotNull Long mealPlanId) {
}