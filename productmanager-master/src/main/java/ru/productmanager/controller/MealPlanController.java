package ru.productmanager.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import ru.productmanager.dto.MealPlanResponse;
import ru.productmanager.dto.MealPlanSummary;
import ru.productmanager.model.MealPlan;
import ru.productmanager.model.UserProfile;
import ru.productmanager.service.MealPlanService;
import ru.productmanager.service.UserProfileService;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/meal-plans")
@RequiredArgsConstructor
public class MealPlanController {
    private final MealPlanService service;
    private final UserProfileService profileService;

    @PostMapping("/generate")
    public ResponseEntity<MealPlanResponse> generate(@RequestParam Long profileId,
                                                     @RequestParam int days,
                                                     @RequestParam int mealsPerDay,
                                                     @RequestParam(required = false) Integer cookingsPerDay,
                                                     @RequestParam(defaultValue = "false") boolean forFamily) {
        UserProfile profile = profileService.getById(profileId); // 404, если профиля нет
        MealPlan plan = service.generateMealPlan(profile, forFamily, days, mealsPerDay,
                cookingsPerDay != null ? cookingsPerDay : mealsPerDay);

        URI location = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/api/meal-plans/{id}").buildAndExpand(plan.getId()).toUri();
        return ResponseEntity.created(location).body(MealPlanResponse.from(plan));
    }

    @GetMapping
    public List<MealPlanSummary> list(@RequestParam Long profileId) {
        return service.getPlansByOwner(profileId);
    }

    @GetMapping("/{id}")
    public MealPlanResponse get(@PathVariable Long id) {
        return MealPlanResponse.from(service.getPlan(id));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}
