package ru.productmanager.dto;

import lombok.Data;
import ru.productmanager.model.DishIngredient;
import ru.productmanager.model.MealType;

import java.util.ArrayList;
import java.util.List;

@Data
public class DishCreateDto {
    private String name;

    private String description;

    private Integer cookingTime;

    private MealType mealType;

    private List<DishIngredient> ingredients = new ArrayList<>();
}
