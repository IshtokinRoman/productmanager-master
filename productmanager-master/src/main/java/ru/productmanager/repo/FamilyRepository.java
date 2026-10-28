package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.productmanager.model.Family;

public interface FamilyRepository extends JpaRepository<Family, Long> {
}
