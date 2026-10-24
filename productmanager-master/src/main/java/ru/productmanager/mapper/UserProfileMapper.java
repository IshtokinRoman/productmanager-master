package ru.productmanager.mapper;

import lombok.Data;
import org.springframework.stereotype.Component;
import ru.productmanager.dto.UserProfileCreateDto;
import ru.productmanager.model.Goal;
import ru.productmanager.model.UserProfile;

@Component
@Data
public class UserProfileMapper {
    public UserProfile toEntity(UserProfileCreateDto createDto) {
        UserProfile userProfile = new UserProfile();
        userProfile.setHeight(createDto.getHeight());
        userProfile.setWeight(createDto.getWeight());
        userProfile.setActivityLevel(createDto.getActivityLevel());
        userProfile.setBirthday(createDto.getBirthday());
        userProfile.setFirstName(createDto.getFirstName());
        userProfile.setLastName(createDto.getLastName());
        userProfile.setEmail(createDto.getEmail());
        if (createDto.getGoal() != null) {
            userProfile.setGoal(createDto.getGoal());
        } else {
            userProfile.setGoal(Goal.MAINTENANCE);
        }
        return userProfile;
    }
}
