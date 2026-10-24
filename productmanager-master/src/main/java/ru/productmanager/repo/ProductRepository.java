package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.productmanager.model.Product;

public interface ProductRepository extends JpaRepository<Product, Long> {
    boolean existsByNameIgnoreCase(String name);
}
