package ru.productmanager.repo;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.productmanager.model.ExcludedProduct;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface ExcludedProductRepository extends JpaRepository<ExcludedProduct, Long> {
    @EntityGraph(attributePaths = "product")
    List<ExcludedProduct> findByUserProfileIdOrderByProductNameAsc(Long profileId);

    boolean existsByUserProfileIdAndProductId(Long profileId, Long productId);

    Optional<ExcludedProduct> findByUserProfileIdAndProductId(Long profileId, Long productId);

    @Query("select e.product.id from ExcludedProduct e where e.userProfile.id in :profileIds")
    List<Long> findProductIdsByProfileIds(@Param("profileIds") Collection<Long> profileIds);
}
