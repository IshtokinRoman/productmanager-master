package ru.productmanager.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
public class UserProfile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;

    private String lastName;

    private String email;

    private Double height;

    private Double weight;

    private LocalDate birthday;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Enumerated(EnumType.STRING)
    private ActivityLevel activityLevel;

    @Enumerated(EnumType.STRING)
    private Goal goal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "family_id")
    private Family family;

    @OneToMany(
            mappedBy = "userProfile",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<ExcludedProduct> excludedProducts = new ArrayList<>();

    @Transient
    public int getAge() {
        if (birthday == null) {
            return 0;
        }
        return Period.between(birthday, LocalDate.now()).getYears();
    }
}
