package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.model.Family;
import ru.productmanager.model.UserProfile;
import ru.productmanager.repo.FamilyRepository;
import ru.productmanager.repo.UserProfileRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FamilyService {
    private final FamilyRepository repository;
    private final UserProfileRepository profileRepository;

    @Transactional
    public Family create(String name, Long profileId) {
        UserProfile profile = findProfile(profileId);
        if (profile.getFamily() != null) {
            throw new IllegalArgumentException("Профиль уже состоит в семье");
        }
        Family family = new Family();
        family.setName(name.trim());
        repository.save(family);
        family.addMember(profile); // обновит profile.family, сохранится при коммите
        return family;
    }

    @Transactional(readOnly = true)
    public Family get(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Family with id:" + id + ", not found!"));
    }

    @Transactional(readOnly = true)
    public List<UserProfile> getMembers(Long familyId) {
        return profileRepository.findByFamilyIdOrderById(familyId);
    }

    @Transactional
    public Family addMember(Long familyId, String email) {
        Family family = get(familyId);
        UserProfile profile = profileRepository.findByEmailIgnoreCase(email.trim())
                .orElseThrow(() -> new NotFoundException("User Profile with email: " + email + ", not found!"));
        Family current = profile.getFamily();
        if (current != null && !current.getId().equals(familyId)) {
            throw new IllegalArgumentException("Профиль уже состоит в другой семье");
        }
        profile.setFamily(family); // сторона-владелец связи, список участников загружать не нужно
        return family;
    }

    /** Убирает участника; когда в семье никого не остаётся, семья удаляется. */
    @Transactional
    public void removeMember(Long familyId, Long profileId) {
        Family family = get(familyId);
        UserProfile profile = findProfile(profileId);
        if (profile.getFamily() == null || !profile.getFamily().getId().equals(familyId)) {
            throw new NotFoundException("Profile " + profileId + " is not a member of family " + familyId);
        }
        profile.setFamily(null);
        profileRepository.flush();
        if (profileRepository.countByFamilyId(familyId) == 0) {
            repository.delete(family);
        }
    }

    private UserProfile findProfile(Long id) {
        return profileRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("User Profile with id:" + id + ", not found!"));
    }
}
