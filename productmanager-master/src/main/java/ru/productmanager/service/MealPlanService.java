package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.productmanager.dto.MealPlanSummary;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.model.*;
import ru.productmanager.repo.MealPlanRepository;
import ru.productmanager.repo.MealTypeByDishRepository;
import ru.productmanager.repo.UserProfileRepository;

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
    // в семье нормы калорий различаются (ребёнок и взрослый), поэтому личные порции допускаются шире
    private static final double FAMILY_MIN_PORTION = 0.3;
    private static final double FAMILY_MAX_PORTION = 3.0;
    private static final int CLOSEST_LIMIT = 3;

    private final MealTypeByDishRepository mealTypeByDishRepository;
    private final MealPlanRepository repository;
    private final UserProfileRepository userProfileRepository;
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

    /**
     * План для одного человека (forFamily = false) или для всей семьи профиля (forFamily = true).
     * Для приёма пищи выбирается одно блюдо на всех. Порция каждого участника считается от его собственной
     * нормы калорий и записывается в MealPortion, а Meal.portion равна сумме порций участников.
     */
    @Transactional
    public MealPlan generateMealPlan(UserProfile requester, boolean forFamily, int days, int mealsPerDay,
                                     int cookingCountPerDay) {
        if (days < 1) {
            throw new IllegalArgumentException("days must be >= 1");
        }

        UserProfile owner = userProfileRepository.findById(requester.getId())
                .orElseThrow(() -> new NotFoundException("User Profile with id:" + requester.getId() + ", not found!"));

        Family family = null;
        List<UserProfile> members = List.of(owner);
        if (forFamily) {
            family = owner.getFamily();
            if (family == null) {
                throw new IllegalArgumentException("Профиль не состоит в семье");
            }
            members = userProfileRepository.findByFamilyIdOrderById(family.getId());
        }

        List<Double> dailyCalories = members.stream().map(this::dailyCaloriesOf).toList();
        double meanDaily = dailyCalories.stream().mapToDouble(Double::doubleValue).average().orElseThrow();
        boolean shared = members.size() > 1;
        double minPortion = shared ? FAMILY_MIN_PORTION : MIN_PORTION;
        double maxPortion = shared ? FAMILY_MAX_PORTION : MAX_PORTION;

        MealPlan plan = new MealPlan();
        plan.setOwner(owner);
        plan.setFamily(family);
        plan.setDays(days);

        Map<MealType, Double> mealShares = getTargetCaloriesByMeals(mealsPerDay);
        List<List<MealType>> groups = getMealTypeByCookingCount(mealsPerDay, cookingCountPerDay);

        // кандидатов для каждой готовки грузим один раз, до цикла по дням
        List<List<Dish>> candidatesByGroup = new ArrayList<>();
        List<Long> excludedIds = requester.getExcludedProducts().stream()
                .map(excludedProduct -> excludedProduct.getProduct().getId())
                .toList();
        for (List<MealType> group : groups) {
            List<Dish> candidates = mealTypeByDishRepository.findDishesByMealTypes(group, excludedIds);
            if (candidates.isEmpty()) {
                throw new IllegalStateException("No dishes suitable for all meal types " + group);
            }
            candidatesByGroup.add(candidates);
        }

        // id блюд, использованных в последние дни, отдельно по каждому типу приёма
        Map<MealType, Deque<Long>> recentIds = new EnumMap<>(MealType.class);

        for (int day = 1; day <= days; day++) {
            for (int g = 0; g < groups.size(); g++) {
                List<MealType> group = groups.get(g);

                // блюдо подбираем по средней цели участников
                List<Double> targets = group.stream()
                        .map(type -> mealShares.get(type) * meanDaily)
                        .toList();

                Set<Long> recent = new HashSet<>();
                for (MealType type : group) {
                    recent.addAll(recentIds.computeIfAbsent(type, t -> new ArrayDeque<>()));
                }

                Dish dish = pickDish(candidatesByGroup.get(g), recent, targets);

                for (MealType type : group) {
                    Deque<Long> history = recentIds.get(type);
                    history.addLast(dish.getId());
                    if (history.size() > REPEAT_WINDOW_DAYS) {
                        history.removeFirst();
                    }

                    Meal meal = new Meal();
                    meal.setDish(dish);
                    meal.setDayNumber(day);
                    meal.setMealType(type);

                    double total = 0;
                    for (int i = 0; i < members.size(); i++) {
                        double target = mealShares.get(type) * dailyCalories.get(i);
                        double portion = Math.max(minPortion, Math.min(maxPortion, target / dish.getCalories()));
                        meal.addMemberPortion(members.get(i), portion);
                        total += portion;
                    }
                    meal.setPortion(total);
                    plan.addMeal(meal);
                }
            }
        }

        return repository.save(plan);
    }

    @Transactional(readOnly = true)
    public List<MealPlanSummary> getPlansByOwner(Long profileId) {
        return repository.findSummariesByOwnerId(profileId);
    }

    private double dailyCaloriesOf(UserProfile member) {
        if (member.getGender() == null || member.getWeight() == null || member.getHeight() == null
                || member.getBirthday() == null || member.getActivityLevel() == null) {
            throw new IllegalArgumentException("Профиль «" + member.getFirstName() + "» заполнен не полностью");
        }
        return calculator.calculateDailyCalories(member.getGender(), member.getWeight(), member.getHeight(),
                member.getAge(), member.getActivityLevel());
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
     * Блюдо подходит, если его можно довести до цели множителем порции, причём для КАЖДОГО приёма
     * группы. Порядок выбора:
     * 1) свежие блюда с порцией в комфортном диапазоне;
     * 2) свежие блюда с любой допустимой порцией;
     * 3) недавно использованные блюда с допустимой порцией;
     * 4) если ничего не масштабируется в допустимых пределах, то несколько ближайших по калорийности.
     */
    private Dish pickDish(List<Dish> dishes, Collection<Long> recent, List<Double> targets) {
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

        List<Dish> candidates = withPortionIn(fresh, targets, PREFERRED_MIN_PORTION, PREFERRED_MAX_PORTION);
        if (candidates.isEmpty()) {
            candidates = withPortionIn(fresh, targets, MIN_PORTION, MAX_PORTION);
        }
        if (candidates.isEmpty()) {
            candidates = withPortionIn(repeated, targets, MIN_PORTION, MAX_PORTION);
        }
        if (!candidates.isEmpty()) {
            return randomOf(candidates);
        }

        List<Dish> closest = closestTo(fresh.isEmpty() ? dishes : fresh, targets);
        if (closest.isEmpty()) {
            throw new IllegalStateException("Dishes for this meal type have no calories");
        }
        return randomOf(closest);
    }

    private List<Dish> withPortionIn(List<Dish> dishes, List<Double> targets, double minPortion, double maxPortion) {
        return dishes.stream()
                .filter(d -> d.getCalories() > 0)
                .filter(d -> targets.stream().allMatch(target -> {
                    double portion = target / d.getCalories();
                    return portion >= minPortion && portion <= maxPortion;
                }))
                .toList();
    }

    // ближайшие блюда: минимизируем наибольшее отклонение множителя порции среди приёмов группы
    private List<Dish> closestTo(List<Dish> dishes, List<Double> targets) {
        return dishes.stream()
                .filter(d -> d.getCalories() > 0)
                .sorted(Comparator.comparingDouble(d -> targets.stream()
                        .mapToDouble(target -> Math.abs(Math.log(target / d.getCalories())))
                        .max()
                        .orElse(0)))
                .limit(CLOSEST_LIMIT)
                .toList();
    }

    private Dish randomOf(List<Dish> list) {
        return list.get(ThreadLocalRandom.current().nextInt(list.size()));
    }

    private List<List<MealType>> getMealTypeByCookingCount(int mealsPerDay, int cookingCountByDay) {
        if (mealsPerDay < 3 || mealsPerDay > 5) {
            throw new IllegalArgumentException("Количество приёмов пищи должно быть от 3 до 5");
        }

        if (cookingCountByDay < 1 || cookingCountByDay > mealsPerDay) {
            throw new IllegalArgumentException("Количество готовок должно быть от 1 до " + mealsPerDay);
        }

        List<MealType> mealTypes = switch (mealsPerDay) {
            case 3 -> List.of(MealType.BREAKFAST, MealType.LUNCH, MealType.DINNER);
            case 4 -> List.of(MealType.BREAKFAST, MealType.SNACK, MealType.LUNCH, MealType.DINNER);
            case 5 -> List.of(MealType.BREAKFAST, MealType.SNACK, MealType.LUNCH, MealType.DINNER,
                    MealType.SECOND_SNACK);
            default -> throw new IllegalStateException();
        };

        List<List<MealType>> result = new ArrayList<>();

        int baseSize = mealsPerDay / cookingCountByDay;
        int remainder = mealsPerDay % cookingCountByDay;
        int index = 0;

        for (int i = 0; i < cookingCountByDay; i++) {
            int groupSize = baseSize + (i < remainder ? 1 : 0);

            List<MealType> group = new ArrayList<>(mealTypes.subList(index, index + groupSize));

            result.add(group);
            index += groupSize;
        }

        return result;
    }
}
