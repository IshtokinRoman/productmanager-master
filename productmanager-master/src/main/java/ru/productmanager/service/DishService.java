package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.dto.DishCreateDto;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.model.Dish;
import ru.productmanager.model.DishIngredient;
import ru.productmanager.model.Product;
import ru.productmanager.repo.DishRepository;
import ru.productmanager.repo.ProductRepository;

import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DishService {
    private final DishRepository repository;
    private final ProductRepository productRepository;

    @Transactional
    public Dish saveDish(DishCreateDto dto) {
        if (repository.existsByNameIgnoreCase(dto.getName()))
            throw new IllegalArgumentException("Product already exists: " + dto.getName());

        Dish dish = new Dish();
        dish.setName(dto.getName());
        dish.setDescription(dto.getDescription());
        dish.setCookingTime(dto.getCookingTime());

        Set<Long> ids = dto.getIngredients().stream()
                .map(dishIngredient -> dishIngredient.getProduct().getId())
                .collect(Collectors.toSet());

        if (ids.size() != dto.getIngredients().size()) {
            throw new IllegalArgumentException("Продукты в списке повторяются");
        }

        Map<Long, Product> products = productRepository.findAllById(ids)
                .stream().collect(Collectors.toMap(Product::getId, Function.identity()));

        for (var i : dto.getIngredients()) {
            Product product = products.get(i.getProduct().getId());
            if (product == null) {
                throw new NotFoundException("Продукт не найден: " + i.getProduct().getId());
            }
            DishIngredient di = new DishIngredient();
            di.setProduct(product);
            di.setAmount(i.getAmount());
            di.setDish(dish);
            dish.addIngredient(di);
        }
        return repository.save(dish);
    }

    @Transactional(readOnly = true)
    public Dish getDish(Long id) {
        return repository.findById(id).
                orElseThrow(() -> new NotFoundException("Dish with id:" + id + ", not found!"));
    }

    @Transactional
    public void deleteDish(Long id) {
        repository.deleteById(id);
    }
}
