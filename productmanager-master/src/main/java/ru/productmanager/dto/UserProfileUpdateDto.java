package ru.productmanager.dto;

import jakarta.validation.constraints.*;
import ru.productmanager.model.ActivityLevel;
import ru.productmanager.model.Gender;
import ru.productmanager.model.Goal;

import java.time.LocalDate;

public record UserProfileUpdateDto(
        @NotBlank @Size(max = 100) String firstName,
        @NotBlank @Size(max = 100) String lastName,
        @NotBlank @Email @Size(max = 255) String email,
        @NotNull @Positive Double height,
        @NotNull @Positive Double weight,
        @NotNull @Past LocalDate birthday,
        @NotNull Gender gender,
        @NotNull ActivityLevel activityLevel,
        @NotNull Goal goal
) {
}
