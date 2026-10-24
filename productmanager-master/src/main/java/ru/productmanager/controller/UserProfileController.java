package ru.productmanager.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import ru.productmanager.dto.UserProfileCreateDto;
import ru.productmanager.dto.UserProfileResponse;
import ru.productmanager.model.UserProfile;
import ru.productmanager.service.UserProfileService;

import java.net.URI;

@RestController
@RequestMapping("/api/profiles")
@RequiredArgsConstructor
public class UserProfileController {
    private final UserProfileService service;

    @PostMapping
    public ResponseEntity<UserProfileResponse> create(@Valid @RequestBody UserProfileCreateDto dto) {
        UserProfile saved = service.save(dto);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}").buildAndExpand(saved.getId()).toUri();
        return ResponseEntity.created(location).body(UserProfileResponse.from(saved));
    }

    @GetMapping("/{id}")
    public UserProfileResponse get(@PathVariable Long id) {
        return UserProfileResponse.from(service.getById(id));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.deleteUserProfile(id);
    }

    @GetMapping("/by-email")
    public UserProfileResponse getByEmail(@RequestParam String email) {
        return UserProfileResponse.from(service.getByEmail(email));
    }
}