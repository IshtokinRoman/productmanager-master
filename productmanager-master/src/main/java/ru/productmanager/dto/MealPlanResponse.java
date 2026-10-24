package ru.productmanager.dto;

import ru.productmanager.model.Meal;
import ru.productmanager.model.MealPlan;
import ru.productmanager.model.MealType;

import java.util.Comparator;
import java.util.List;

public record MealPlanResponse(
        Long id,
        Long ownerId,
        int days,
        List<MealItem> meals
) {
    public record MealItem(
            Long id,
            int dayNumber,
            MealType mealType,
            Double portion,
            Long dishId,
            String dishName
    ) {
    }

    public static MealPlanResponse from(MealPlan plan) {
        List<MealItem> items = plan.getMeals().stream()
                .sorted(Comparator.comparingInt(Meal::getDayNumber)) // сортировка стабильная
                .map(m -> new MealItem(
                        m.getId(),
                        m.getDayNumber(),
                        m.getMealType(),
                        m.getPortion(),
                        m.getDish().getId(),
                        m.getDish().getName()))
                .toList();

        return new MealPlanResponse(
                plan.getId(),
                plan.getOwner().getId(),
                plan.getDays(),
                items);
    }
}