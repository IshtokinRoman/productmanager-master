package ru.productmanager.service;

import org.springframework.stereotype.Component;
import ru.productmanager.model.ActivityLevel;
import ru.productmanager.model.Gender;

@Component
public class BmrCalculator {
    public double calculateDailyCalories(Gender gender, double weight, double height,
                                         int age, ActivityLevel activityLevel) {
        int genderConstant = gender == Gender.MALE ? 5 : -161;

        double activityCoefficient = switch (activityLevel) {
            case LOW -> 1.375;
            case MODERATE -> 1.55;
            case HIGH -> 1.725;
            case VERY_HIGH -> 1.9;
        };

        return (10 * weight + 6.25 * height - 5 * age + genderConstant) * activityCoefficient;
    }
}
