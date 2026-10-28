package ru.productmanager.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import ru.productmanager.exception.NotFoundException;
import ru.productmanager.model.ExcludedProduct;
import ru.productmanager.model.Product;
import ru.productmanager.model.UserProfile;
import ru.productmanager.repo.ExcludedProductRepository;
import ru.productmanager.repo.ProductRepository;
import ru.productmanager.repo.UserProfileRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ExcludedProductService {
    private final ExcludedProductRepository repository;
    private final UserProfileRepository profileRepository;
    private final ProductRepository productRepository;

    @Transactional(readOnly = true)
    public List<ExcludedProduct> list(Long profileId) {
        requireProfile(profileId);
        return repository.findByUserProfileIdOrderByProductNameAsc(profileId);
    }

    /** Добавляет продукт в исключения и возвращает обновлённый список. */
    @Transactional
    public List<ExcludedProduct> add(Long profileId, Long productId) {
        UserProfile profile = requireProfile(profileId);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new NotFoundException("Product with id:" + productId + ", not found!"));
        if (repository.existsByUserProfileIdAndProductId(profileId, productId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Product already excluded");
        }

        ExcludedProduct excluded = new ExcludedProduct();
        excluded.setUserProfile(profile);
        excluded.setProduct(product);
        repository.save(excluded);
        return repository.findByUserProfileIdOrderByProductNameAsc(profileId);
    }

    @Transactional
    public void remove(Long profileId, Long productId) {
        ExcludedProduct excluded = repository.findByUserProfileIdAndProductId(profileId, productId)
                .orElseThrow(() -> new NotFoundException(
                        "Product " + productId + " is not excluded for profile " + profileId));
        repository.delete(excluded);
    }

    private UserProfile requireProfile(Long id) {
        return profileRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("User Profile with id:" + id + ", not found!"));
    }
}
