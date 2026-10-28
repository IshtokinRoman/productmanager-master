package ru.productmanager.dto;

import ru.productmanager.model.ActivityLevel;
import ru.productmanager.model.Gender;
import ru.productmanager.model.Goal;
import ru.productmanager.model.UserProfile;

import java.time.LocalDate;

public record UserProfileResponse(
        Long id,
        String firstName,
        String lastName,
        String email,
        Double height,
        Double weight,
        LocalDate birthday,
        int age,
        Gender gender,
        ActivityLevel activityLevel,
        Goal goal,
        Long familyId
) {
    public static UserProfileResponse from(UserProfile profile) {
        return new UserProfileResponse(
                profile.getId(),
                profile.getFirstName(),
                profile.getLastName(),
                profile.getEmail(),
                profile.getHeight(),
                profile.getWeight(),
                profile.getBirthday(),
                profile.getAge(),
                profile.getGender(),
                profile.getActivityLevel(),
                profile.getGoal(),
                profile.getFamily() == null ? null : profile.getFamily().getId());
    }
}
