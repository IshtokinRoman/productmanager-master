package ru.productmanager.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.List;
import java.util.Set;

/**
 * Простая защита админских операций ключом в заголовке X-Admin-Key.
 * Закрыто: все запросы на /api/admin/** и изменяющие запросы (POST, PUT, PATCH, DELETE)
 * на /api/dishes и /api/products. Чтение каталога остаётся открытым.
 * Если свойство app.admin-key пустое, защита выключена (удобно для разработки).
 */
@Slf4j
@Component
public class AdminKeyFilter extends OncePerRequestFilter {
    private static final Set<String> WRITE_METHODS = Set.of("POST", "PUT", "PATCH", "DELETE");
    private static final List<String> PROTECTED_WRITE_PREFIXES = List.of("/api/dishes", "/api/products");

    private final byte[] adminKey;

    public AdminKeyFilter(@Value("${app.admin-key:}") String adminKey) {
        this.adminKey = adminKey.getBytes(StandardCharsets.UTF_8);
        if (this.adminKey.length == 0) {
            log.warn("app.admin-key не задан: добавление и удаление блюд и продуктов доступно всем");
        }
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        if (adminKey.length > 0 && isProtected(request) && !keyMatches(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/problem+json;charset=UTF-8");
            response.getWriter().write("{\"status\":401,\"title\":\"Unauthorized\",\"detail\":\"Admin key required\"}");
            return;
        }
        chain.doFilter(request, response);
    }

    private boolean isProtected(HttpServletRequest request) {
        String path = request.getRequestURI();
        if (path.startsWith("/api/admin/")) {
            return true;
        }
        return WRITE_METHODS.contains(request.getMethod())
                && PROTECTED_WRITE_PREFIXES.stream().anyMatch(path::startsWith);
    }

    private boolean keyMatches(HttpServletRequest request) {
        String provided = request.getHeader("X-Admin-Key");
        return provided != null
                && MessageDigest.isEqual(provided.getBytes(StandardCharsets.UTF_8), adminKey);
    }
}
