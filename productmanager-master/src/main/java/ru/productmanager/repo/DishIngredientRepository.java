package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.productmanager.model.DishIngredient;

public interface DishIngredientRepository extends JpaRepository<DishIngredient, Long> {
}
