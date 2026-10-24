package ru.productmanager.mapper;

import lombok.Data;
import org.springframework.stereotype.Component;
import ru.productmanager.dto.ProductCreateDto;
import ru.productmanager.model.Product;

@Data
@Component
public class ProductMapper {
    public Product toEntity(ProductCreateDto createDto) {
        Product product = new Product();
        product.setName(createDto.getName());
        product.setCategory(createDto.getCategory());
        product.setCalories(createDto.getCalories());
        product.setCarbohydrates(createDto.getCarbohydrates());
        product.setFat(createDto.getFat());
        product.setProtein(createDto.getProtein());
        return product;
    }
}
