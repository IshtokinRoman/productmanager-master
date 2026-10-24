package ru.productmanager.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.productmanager.dto.MealPlanSummary;
import ru.productmanager.model.MealPlan;

import java.util.List;

public interface MealPlanRepository extends JpaRepository<MealPlan, Long> {
    @Query("""
        select new ru.productmanager.dto.MealPlanSummary(p.id, p.days, count(m))
        from MealPlan p left join p.meals m
        where p.owner.id = :ownerId
        group by p.id, p.days
        order by p.id desc
        """)
    List<MealPlanSummary> findSummariesByOwnerId(@Param("ownerId") Long ownerId);
}
