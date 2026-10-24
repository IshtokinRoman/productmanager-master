package ru.productmanager.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
import ru.productmanager.model.ActivityLevel;
import ru.productmanager.model.Gender;
import ru.productmanager.model.Goal;

import java.time.LocalDate;

@Data
public class UserProfileCreateDto {

    @NotNull
    private String email;

    @NotNull
    private String firstName;

    @NotNull
    private String lastName;

    @NotNull
    @Positive
    private Double height;

    @NotNull
    @Positive
    private Double weight;

    @NotNull
    private LocalDate birthday;

    @NotNull
    private Gender gender;

    @NotNull
    private ActivityLevel activityLevel;

    private Goal goal;
}
