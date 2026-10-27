package ru.productmanager.model;

import jakarta.persistence.*;

@Entity
@Table(
        name = "meal_type_by_dish",
        uniqueConstraints = @UniqueConstraint(
                name = "uq_meal_type_by_dish",
                columnNames = {"dish_id", "meal_type"}
        )
)
public class MealTypeByDish {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dish_id", nullable = false)
    private Dish dish;

    @Enumerated(EnumType.STRING)
    @Column(name = "meal_type", nullable = false, length = 32)
    private MealType mealType;
}
