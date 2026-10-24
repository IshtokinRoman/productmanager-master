package ru.productmanager.dto;

import jakarta.validation.constraints.NotNull;

public record BasketItemUpdateDto(@NotNull Boolean purchased) {
}
