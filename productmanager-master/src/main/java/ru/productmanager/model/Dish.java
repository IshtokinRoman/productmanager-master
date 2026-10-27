package ru.productmanager.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
public class Dish {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String description;

    private Integer cookingTime;

    @OneToMany(mappedBy = "dish", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DishIngredient> ingredients = new ArrayList<>();

    public void addIngredient(DishIngredient dishIngredient) {
        ingredients.add(dishIngredient);
    }

    @Transient
    public double getCalories() {
        return ingredients.stream()
                .mapToDouble(DishIngredient::getCalories)
                .sum();
    }
}
