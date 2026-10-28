package ru.productmanager.dto;

import ru.productmanager.model.Meal;
import ru.productmanager.model.MealPlan;
import ru.productmanager.model.MealPortion;
import ru.productmanager.model.MealType;

import java.util.Comparator;
import java.util.List;

public record MealPlanResponse(
        Long id,
        Long ownerId,
        Long familyId,
        int days,
        List<MealItem> meals
) {
    public record MemberPortion(Long profileId, String name, double portion) {
    }

    public record MealItem(
            Long id,
            int dayNumber,
            MealType mealType,
            Double portion,
            Long dishId,
            String dishName,
            List<MemberPortion> members
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
                        m.getDish().getName(),
                        m.getMemberPortions().stream()
                                .sorted(Comparator.comparing((MealPortion mp) -> mp.getMember().getId()))
                                .map(mp -> new MemberPortion(
                                        mp.getMember().getId(),
                                        mp.getMember().getFirstName(),
                                        mp.getPortion()))
                                .toList()))
                .toList();

        return new MealPlanResponse(
                plan.getId(),
                plan.getOwner().getId(),
                plan.getFamily() == null ? null : plan.getFamily().getId(),
                plan.getDays(),
                items);
    }
}
