package ru.productmanager.dto;

import ru.productmanager.model.Family;
import ru.productmanager.model.UserProfile;

import java.util.List;

public record FamilyResponse(Long id, String name, List<Member> members) {
    public record Member(Long id, String firstName, String lastName, String email) {
    }

    public static FamilyResponse from(Family family, List<UserProfile> members) {
        return new FamilyResponse(family.getId(), family.getName(), members.stream()
                .map(p -> new Member(p.getId(), p.getFirstName(), p.getLastName(), p.getEmail()))
                .toList());
    }
}
