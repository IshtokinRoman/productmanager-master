package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.productmanager.model.Dish;
import ru.productmanager.model.MealType;

import java.util.List;

public interface DishRepository extends JpaRepository<Dish, Long> {
    boolean existsByNameIgnoreCase(String name);
}
