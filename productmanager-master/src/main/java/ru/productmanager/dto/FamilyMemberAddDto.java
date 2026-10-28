package ru.productmanager.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record FamilyMemberAddDto(@NotBlank @Email String email) {
}
