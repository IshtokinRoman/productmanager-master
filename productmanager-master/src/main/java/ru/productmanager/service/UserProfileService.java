package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.dto.UserProfileCreateDto;
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
