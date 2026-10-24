package ru.productmanager.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Data;
import ru.productmanager.model.ProductCategory;

@Data
public class ProductCreateDto {
    @NotNull
    private String name;

    @NotNull
    private ProductCategory category;

    @NotNull
    @PositiveOrZero
    private Double calories;

    @NotNull
    @PositiveOrZero
    private Double protein;

    @NotNull
    @PositiveOrZero
    private Double fat;

    @NotNull
    @PositiveOrZero
    private Double carbohydrates;
}
