package ru.productmanager.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record FamilyCreateDto(@NotBlank String name, @NotNull Long profileId) {
}
