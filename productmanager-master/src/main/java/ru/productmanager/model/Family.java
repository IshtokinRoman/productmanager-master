package ru.productmanager.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
public class Family {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    // Без cascade и orphanRemoval: семья лишь объединяет профили. Удаление семьи
    // или выход из неё не должны удалять сами профили пользователей.
    @OneToMany(mappedBy = "family")
    private List<UserProfile> familyMembers = new ArrayList<>();

    public void addMember(UserProfile profile) {
        familyMembers.add(profile);
        profile.setFamily(this);
    }

    public void removeMember(UserProfile profile) {
        familyMembers.remove(profile);
        profile.setFamily(null);
    }
}