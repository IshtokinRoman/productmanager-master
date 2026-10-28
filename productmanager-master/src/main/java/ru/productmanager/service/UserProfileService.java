package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import ru.productmanager.dto.UserProfileCreateDto;
import ru.productmanager.dto.UserProfilePatchDto;
import ru.productmanager.dto.UserProfileUpdateDto;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.mapper.UserProfileMapper;
import ru.productmanager.model.UserProfile;
import ru.productmanager.repo.UserProfileRepository;

@Service
@RequiredArgsConstructor
public class UserProfileService {
    private final UserProfileRepository repository;
    private final UserProfileMapper mapper;

    @Transactional
    public UserProfile save(UserProfileCreateDto createDto) {
        if (repository.existsByEmail(createDto.getEmail()))
            throw new IllegalArgumentException("user with email " + createDto.getEmail() + " already exist");
        UserProfile userProfile = mapper.toEntity(createDto);
        return repository.save(userProfile);
    }

    /** Частичное обновление: меняются только переданные поля (не null). */
    @Transactional
    public UserProfile patch(Long id, UserProfilePatchDto dto) {
        if (dto.isEmpty()) {
            throw new IllegalArgumentException("Не передано ни одного поля для изменения");
        }

        UserProfile profile = getById(id);

        if (dto.email() != null) {
            String email = dto.email().trim();
            repository.findByEmailIgnoreCase(email)
                    .filter(other -> !other.getId().equals(id))
                    .ifPresent(other -> {
                        throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
                    });
            profile.setEmail(email);
        }
        if (dto.firstName() != null) profile.setFirstName(dto.firstName().trim());
        if (dto.lastName() != null) profile.setLastName(dto.lastName().trim());
        if (dto.height() != null) profile.setHeight(dto.height());
        if (dto.weight() != null) profile.setWeight(dto.weight());
        if (dto.birthday() != null) profile.setBirthday(dto.birthday());
        if (dto.gender() != null) profile.setGender(dto.gender());
        if (dto.activityLevel() != null) profile.setActivityLevel(dto.activityLevel());
        if (dto.goal() != null) profile.setGoal(dto.goal());
        return profile; // изменения сохранятся при коммите транзакции
    }

    @Transactional(readOnly = true)
    public UserProfile getById(Long id) {
        return repository.findById(id).
                orElseThrow(() -> new NotFoundException("User Profile with id:" + id + ", not found!"));
    }

    @Transactional
    public void deleteUserProfile(Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return;
        }
        throw new NotFoundException("User Profile with id:" + id + ", not found!");
    }

    // UserProfileService
    @Transactional(readOnly = true)
    public UserProfile getByEmail(String email) {
        return repository.findByEmailIgnoreCase(email.trim()).orElseThrow(() -> new NotFoundException("User Profile with email: " + email + ", not found!"));
    }
}
