package ru.productmanager.dto;

import ru.productmanager.model.Dish;
import ru.productmanager.model.MealType;

import java.util.List;

public record DishResponse(
        Long id,
        String name,
        String description,
        Integer cookingTime,
        MealType mealType,
        double calories,
        List<IngredientItem> ingredients
) {
    public record IngredientItem(
            Long productId,
            String productName,
            Double amount,
            double calories
    ) {
    }

    public static DishResponse from(Dish dish) {
        List<IngredientItem> items = dish.getIngredients().stream()
                .map(i -> new IngredientItem(
                        i.getProduct().getId(),
                        i.getProduct().getName(),
                        i.getAmount(),
                        i.getCalories()))
                .toList();

        return new DishResponse(
                dish.getId(),
                dish.getName(),
                dish.getDescription(),
                dish.getCookingTime(),
                dish.getMealType(),
                dish.getCalories(),
                items);
    }
}