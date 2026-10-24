package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.dto.ProductCreateDto;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.mapper.ProductMapper;
import ru.productmanager.model.Product;
import ru.productmanager.repo.ProductRepository;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository repository;
    private final ProductMapper mapper;

    @Transactional
    public Product save(ProductCreateDto createDto) {
        if (repository.existsByNameIgnoreCase(createDto.getName()))
            throw new IllegalArgumentException("Product already exists: " + createDto.getName());
        Product product = mapper.toEntity(createDto);
        return repository.save(product);
    }

    @Transactional(readOnly = true)
    public Product getProductById(Long id) {
        return repository.findById(id).
                orElseThrow(() -> new NotFoundException("Product with id:" + id + ", not found!"));
    }

    @Transactional
    public void deleteProduct(Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return;
        }
        throw new NotFoundException("Product with id:" + id + ", not found!");
    }
}
