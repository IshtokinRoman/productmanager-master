package ru.productmanager.repo;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import ru.productmanager.model.ProductBasket;

import java.util.List;
import java.util.Optional;

public interface ProductBasketRepository extends JpaRepository<ProductBasket, Long> {
    List<ProductBasket> findByOwnerIdOrderByCreatedAtDesc(Long ownerId);

    Optional<ProductBasket> findByMealPlanId(Long mealPlanId);

    @EntityGraph(attributePaths = {"items", "items.product"})
    Optional<ProductBasket> findWithItemsById(Long id);

    @EntityGraph(attributePaths = {"items", "items.product"})
    Optional<ProductBasket> findWithItemsByMealPlanId(Long mealPlanId);
}