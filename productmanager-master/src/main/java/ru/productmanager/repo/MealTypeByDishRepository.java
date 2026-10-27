package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.productmanager.model.Dish;
import ru.productmanager.model.MealType;
import ru.productmanager.model.MealTypeByDish;

import java.util.List;

public interface MealTypeByDishRepository extends JpaRepository<MealTypeByDish, Long> {
    List<MealTypeByDish> findByMealType(MealType type);


    @Query("""
   SELECT mtd.dish
    FROM MealTypeByDish mtd
    WHERE mtd.mealType = :mealType
   """)
    List<Dish> findDishesByMealType(@Param("mealType") MealType mealType);

    @Query("""
    SELECT mtd.dish
    FROM MealTypeByDish mtd
    WHERE mtd.mealType IN :mealTypes
    GROUP BY mtd.dish
    HAVING COUNT(DISTINCT mtd.mealType) = :#{#mealTypes.size()}
    """)
    List<Dish> findDishesByMealTypes(
            @Param("mealTypes") List<MealType> mealTypes
    );
}