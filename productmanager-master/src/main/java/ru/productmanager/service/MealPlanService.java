package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.dto.MealPlanSummary;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.model.*;
import ru.productmanager.repo.DishRepository;
import ru.productmanager.repo.MealPlanRepository;

import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
public class MealPlanService {
    private static final int REPEAT_WINDOW_DAYS = 3;

    // допустимый множитель порции и "комфортный" диапазон, который выбираем в первую очередь
    private static final double MIN_PORTION = 0.5;
    private static final double MAX_PORTION = 2.0;
    private static final double PREFERRED_MIN_PORTION = 0.75;
    private static final double PREFERRED_MAX_PORTION = 1.5;
    private static final int CLOSEST_LIMIT = 3;

    private final DishRepository dishRepository;
    private final MealPlanRepository repository;
    private final BmrCalculator calculator;

    @Transactional(readOnly = true)
    public MealPlan getPlan(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Meal plan with id:" + id + ", not found!"));
    }

    @Transactional
    public void delete(Long id) {
        MealPlan plan = getPlan(id); // единообразно: 404, если плана нет
        repository.delete(plan);
    }

    @Transactional
    public MealPlan generateMealPlan(UserProfile profile, int days, int mealsPerDay) {
        if (days < 1) {
            throw new IllegalArgumentException("days must be >= 1");
        }

        MealPlan plan = new MealPlan();
        plan.setOwner(profile);
        plan.setDays(days);

        double dailyCalories = calculator.calculateDailyCalories(profile.getGender(), profile.getWeight(),
                profile.getHeight(), profile.getAge(), profile.getActivityLevel());

        Map<MealType, Double> mealShares = getTargetCaloriesByMeals(mealsPerDay);

        // блюда грузим один раз, до циклов по дням
        Map<MealType, List<Dish>> dishesByMealType = new EnumMap<>(MealType.class);
        for (MealType type : mealShares.keySet()) {
            List<Dish> dishes = dishRepository.findByMealType(type);
            if (dishes.isEmpty()) {
                throw new IllegalStateException("No dishes for meal type " + type);
            }
            dishesByMealType.put(type, dishes);
        }

        // id блюд, использованных в последние дни, отдельно по каждому типу приёма
        Map<MealType, Deque<Long>> recentIds = new EnumMap<>(MealType.class);

        for (int day = 1; day <= days; day++) {
            for (Map.Entry<MealType, Double> entry : mealShares.entrySet()) {
                MealType type = entry.getKey();
                double mealTargetCalories = entry.getValue() * dailyCalories;

                Deque<Long> recent = recentIds.computeIfAbsent(type, t -> new ArrayDeque<>());
                Dish dish = pickDish(dishesByMealType.get(type), recent, mealTargetCalories);

                recent.addLast(dish.getId());
                if (recent.size() > REPEAT_WINDOW_DAYS) {
                    recent.removeFirst();
                }

                double portion = mealTargetCalories / dish.getCalories();
                portion = Math.max(MIN_PORTION, Math.min(MAX_PORTION, portion));

                Meal meal = new Meal();
                meal.setDish(dish);
                meal.setDayNumber(day);
                meal.setMealType(type);
                meal.setPortion(portion);
                meal.setMealPlan(plan);
                plan.addMeal(meal);
            }
        }

        return repository.save(plan);
    }

    @Transactional(readOnly = true)
    public List<MealPlanSummary> getPlansByOwner(Long profileId) {
        return repository.findSummariesByOwnerId(profileId);
    }

    private Map<MealType, Double> getTargetCaloriesByMeals(int mealsPerDay) {
        Map<MealType, Double> shares = new EnumMap<>(MealType.class);
        switch (mealsPerDay) {
            case 3 -> {
                shares.put(MealType.BREAKFAST, 0.30);
                shares.put(MealType.LUNCH, 0.50);
                shares.put(MealType.DINNER, 0.20);
            }
            case 4 -> {
                shares.put(MealType.BREAKFAST, 0.20);
                shares.put(MealType.SNACK, 0.10);
                shares.put(MealType.LUNCH, 0.45);
                shares.put(MealType.DINNER, 0.25);
            }
            case 5 -> {
                shares.put(MealType.BREAKFAST, 0.20);
                shares.put(MealType.SNACK, 0.10);
                shares.put(MealType.LUNCH, 0.30);
                shares.put(MealType.DINNER, 0.25);
                shares.put(MealType.SECOND_SNACK, 0.15);
            }
            default -> throw new IllegalArgumentException("mealsPerDay must be 3, 4 or 5");
        }
        return shares;
    }

    /**
     * Блюдо подходит, если его можно довести до цели множителем порции.
     * Сравнивать нужно не калорийность блюда с целью, а получающийся множитель: блюдо на 650 ккал
     * при цели 850 ккал даёт порцию x1,3, и это нормально. Порядок выбора:
     * 1) свежие блюда с порцией в комфортном диапазоне;
     * 2) свежие блюда с любой допустимой порцией;
     * 3) недавно использованные блюда с допустимой порцией;
     * 4) если ничего не масштабируется в допустимых пределах, то несколько ближайших по калорийности.
     */
    private Dish pickDish(List<Dish> dishes, Collection<Long> recent, double target) {
        if (dishes.isEmpty()) {
            throw new NotFoundException("No dishes available for this meal type");
        }

        List<Dish> fresh = new ArrayList<>();
        List<Dish> repeated = new ArrayList<>();
        for (Dish dish : dishes) {
            if (recent.contains(dish.getId())) {
                repeated.add(dish);
            } else {
                fresh.add(dish);
            }
        }

        List<Dish> candidates = withPortionIn(fresh, target, PREFERRED_MIN_PORTION, PREFERRED_MAX_PORTION);
        if (candidates.isEmpty()) {
            candidates = withPortionIn(fresh, target, MIN_PORTION, MAX_PORTION);
        }
        if (candidates.isEmpty()) {
            candidates = withPortionIn(repeated, target, MIN_PORTION, MAX_PORTION);
        }
        if (!candidates.isEmpty()) {
            return randomOf(candidates);
        }

        List<Dish> closest = closestTo(fresh.isEmpty() ? dishes : fresh, target);
        if (closest.isEmpty()) {
            throw new IllegalStateException("Dishes for this meal type have no calories");
        }
        return randomOf(closest);
    }

    private List<Dish> withPortionIn(List<Dish> dishes, double target, double minPortion, double maxPortion) {
        return dishes.stream()
                .filter(d -> d.getCalories() > 0)
                .filter(d -> {
                    double portion = target / d.getCalories();
                    return portion >= minPortion && portion <= maxPortion;
                })
                .toList();
    }

    private List<Dish> closestTo(List<Dish> dishes, double target) {
        return dishes.stream()
                .filter(d -> d.getCalories() > 0)
                .sorted(Comparator.comparingDouble(d -> Math.abs(Math.log(target / d.getCalories()))))
                .limit(CLOSEST_LIMIT)
                .toList();
    }

    private Dish randomOf(List<Dish> list) {
        return list.get(ThreadLocalRandom.current().nextInt(list.size()));
    }
}