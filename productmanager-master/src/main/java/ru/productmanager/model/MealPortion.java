package ru.productmanager.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

/** Порция приёма пищи конкретного участника. Сумма порций участников равна Meal.portion. */
@Entity
@Getter
@Setter
public class MealPortion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "meal_id", nullable = false)
    private Meal meal;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "member_id", nullable = false)
    private UserProfile member;

    @Column(nullable = false)
    private double portion;
}
