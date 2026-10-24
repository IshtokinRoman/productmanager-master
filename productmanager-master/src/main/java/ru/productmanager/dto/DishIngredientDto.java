package ru.productmanager.dto;

import lombok.Data;
import ru.productmanager.model.Dish;
import ru.productmanager.model.Product;

@Data
public class DishIngredientDto {
    private Dish dish;

    private Product product;

    private Double amount;
}
