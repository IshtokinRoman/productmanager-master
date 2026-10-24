package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.productmanager.model.UserProfile;

import java.util.Optional;

public interface UserProfileRepository extends JpaRepository<UserProfile, Long> {
    boolean existsByEmail(String email);

    Optional<UserProfile> findByEmailIgnoreCase(String email);
}
