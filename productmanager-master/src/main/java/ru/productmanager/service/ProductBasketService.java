package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.model.*;
import ru.productmanager.repo.ProductBasketRepository;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductBasketService {
    private final ProductBasketRepository repository;
    private final MealPlanService mealPlanService;

    /**
     * Собирает корзину по плану: граммы каждого ингредиента умножаются на порцию приёма пищи
     * и суммируются по продуктам. Если корзина на этот план уже есть, она пересобирается.
     */
    @Transactional
    public ProductBasket createFromPlan(Long mealPlanId) {
        MealPlan plan = mealPlanService.getPlan(mealPlanId);

        // старую корзину удаляем и сразу сбрасываем в БД: иначе вставка новой
        // может опередить удаление и нарушить уникальность
        repository.findByMealPlanId(mealPlanId).ifPresent(old -> {
            repository.delete(old);
            repository.flush();
        });

        Map<Long, Product> products = new HashMap<>();
        Map<Long, Double> grams = new HashMap<>();
        for (Meal meal : plan.getMeals()) {
            double portion = meal.getPortion() != null ? meal.getPortion() : 1.0;
            for (DishIngredient ingredient : meal.getDish().getIngredients()) {
                Product product = ingredient.getProduct();
                products.putIfAbsent(product.getId(), product);
                grams.merge(product.getId(), ingredient.getAmount() * portion, Double::sum);
            }
        }

        ProductBasket basket = new ProductBasket();
        basket.setOwner(plan.getOwner());
        basket.setMealPlan(plan);
        grams.forEach((productId, amount) -> {
            BasketItem item = new BasketItem();
            item.setProduct(products.get(productId));
            item.setAmount(amount);
            basket.addItem(item);
        });
        return repository.save(basket);
    }

    @Transactional(readOnly = true)
    public ProductBasket getBasket(Long id) {
        return repository.findWithItemsById(id)
                .orElseThrow(() -> new NotFoundException("Basket with id:" + id + ", not found!"));
    }

    @Transactional(readOnly = true)
    public ProductBasket getByMealPlan(Long mealPlanId) {
        return repository.findWithItemsByMealPlanId(mealPlanId)
                .orElseThrow(() -> new NotFoundException("Basket for meal plan " + mealPlanId + ", not found!"));
    }

    @Transactional
    public ProductBasket setPurchased(Long basketId, Long itemId, boolean purchased) {
        ProductBasket basket = getBasket(basketId);
        BasketItem item = basket.getItems().stream()
                .filter(i -> i.getId().equals(itemId))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("Basket item with id:" + itemId + ", not found!"));
        item.setPurchased(purchased); // сохранится само при коммите (dirty checking)
        return basket;
    }

    @Transactional
    public void delete(Long id) {
        repository.delete(getBasket(id));
    }
}