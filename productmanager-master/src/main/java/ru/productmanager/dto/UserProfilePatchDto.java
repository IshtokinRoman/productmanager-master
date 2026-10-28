package ru.productmanager.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import ru.productmanager.model.ActivityLevel;
import ru.productmanager.model.Gender;
import ru.productmanager.model.Goal;

import java.time.LocalDate;

/**
 * Частичное обновление профиля: непереданное поле (null) не меняется.
 * Ограничения проверяют только переданные значения; @Pattern не пропускает пустые и пробельные строки.
 */
public record UserProfilePatchDto(
        @Pattern(regexp = ".*\\S.*") @Size(max = 100) String firstName,
        @Pattern(regexp = ".*\\S.*") @Size(max = 100) String lastName,
        @Pattern(regexp = ".*\\S.*") @Email @Size(max = 255) String email,
        @Positive Double height,
        @Positive Double weight,
        @Past LocalDate birthday,
        Gender gender,
        ActivityLevel activityLevel,
        Goal goal
) {
    public boolean isEmpty() {
        return firstName == null && lastName == null && email == null && height == null && weight == null
                && birthday == null && gender == null && activityLevel == null && goal == null;
    }
}
