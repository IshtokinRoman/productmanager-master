package ru.productmanager.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Getter
@Setter
public class Meal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "dish_id", nullable = false)
    private Dish dish;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "meal_plan_id", nullable = false)
    private MealPlan mealPlan;

    @Column(nullable = false)
    private int dayNumber;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MealType mealType;

    // сумма порций всех участников: именно столько блюда нужно приготовить (и купить продуктов)
    private Double portion;

    // Set, а не List: так план можно загрузить одним запросом вместе с meals (иначе MultipleBagFetchException)
    @OneToMany(mappedBy = "meal", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MealPortion> memberPortions = new LinkedHashSet<>();

    public void addMemberPortion(UserProfile member, double portion) {
        MealPortion memberPortion = new MealPortion();
        memberPortion.setMeal(this);
        memberPortion.setMember(member);
        memberPortion.setPortion(portion);
        memberPortions.add(memberPortion);
    }
}
