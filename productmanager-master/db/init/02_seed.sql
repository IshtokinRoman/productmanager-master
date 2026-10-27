-- Наполнение каталога: продукты и блюда российской кухни
-- КБЖУ на 100 г (крупы, макароны и бобовые сухие, мясо и рыба сырые). Количество ингредиента в граммах на порцию.
-- У блюда может быть несколько типов приёма пищи (таблица meal_type_by_dish): это позволяет готовить
-- одно блюдо сразу на соседние приёмы (обед и ужин, завтрак и перекус и т.д.).
-- Скрипт можно запускать повторно: существующие продукты и блюда (без учёта регистра) пропускаются.

BEGIN;

INSERT INTO product (name, category, calories, protein, fat, carbohydrates)
SELECT v.name, v.category, v.calories, v.protein, v.fat, v.carbohydrates
FROM (VALUES
  ('Гречневая крупа', 'GRAINS', 313, 12.6, 3.3, 62.1),
  ('Рис белый', 'GRAINS', 344, 6.7, 0.7, 78.9),
  ('Рис бурый', 'GRAINS', 337, 7.4, 1.8, 72.9),
  ('Овсяные хлопья', 'GRAINS', 352, 12.3, 6.2, 61.8),
  ('Пшено', 'GRAINS', 348, 11.5, 3.3, 69.3),
  ('Перловая крупа', 'GRAINS', 320, 9.3, 1.1, 73.7),
  ('Ячневая крупа', 'GRAINS', 322, 10.4, 1.3, 66.3),
  ('Булгур', 'GRAINS', 342, 12.3, 1.3, 75.9),
  ('Кускус', 'GRAINS', 376, 12.8, 0.6, 77.4),
  ('Манная крупа', 'GRAINS', 333, 10.3, 1, 70.6),
  ('Кукурузная крупа', 'GRAINS', 337, 8.3, 1.2, 75),
  ('Киноа', 'GRAINS', 368, 14.1, 6.1, 64.2),
  ('Мука пшеничная', 'GRAINS', 334, 10.3, 1.1, 68.9),
  ('Макароны (сухие)', 'PASTA', 344, 10.4, 1.1, 71.5),
  ('Гречневая лапша (соба)', 'PASTA', 336, 14, 0.8, 70),
  ('Пельмени мясные', 'OTHER', 275, 11.9, 12.4, 29),
  ('Хлеб ржаной (бородинский)', 'BREAD', 208, 6.9, 1.3, 40.9),
  ('Хлеб пшеничный', 'BREAD', 242, 8.1, 1, 48.8),
  ('Хлеб цельнозерновой', 'BREAD', 240, 9.5, 2.8, 43),
  ('Батон нарезной', 'BREAD', 262, 7.5, 2.9, 51),
  ('Лаваш тонкий', 'BREAD', 236, 7.9, 1, 47.6),
  ('Хлебцы ржаные', 'BREAD', 300, 11, 2, 60),
  ('Сушки', 'BREAD', 339, 11, 1.3, 71),
  ('Молоко 2,5%', 'DAIRY', 52, 2.8, 2.5, 4.7),
  ('Молоко 3,2%', 'DAIRY', 60, 2.9, 3.2, 4.7),
  ('Кефир 1%', 'DAIRY', 40, 3, 1, 4),
  ('Кефир 2,5%', 'DAIRY', 53, 2.9, 2.5, 4),
  ('Кефир 3,2%', 'DAIRY', 59, 2.9, 3.2, 4),
  ('Ряженка 2,5%', 'DAIRY', 54, 3, 2.5, 4.2),
  ('Йогурт натуральный 2,5%', 'DAIRY', 60, 4.3, 2.5, 5.7),
  ('Греческий йогурт 2%', 'DAIRY', 66, 8, 2, 4),
  ('Творог 0%', 'DAIRY', 71, 16.5, 0.2, 1.3),
  ('Творог 5%', 'DAIRY', 121, 17.2, 5, 1.8),
  ('Творог 9%', 'DAIRY', 159, 16.7, 9, 2),
  ('Сметана 15%', 'DAIRY', 158, 2.6, 15, 3),
  ('Сметана 20%', 'DAIRY', 206, 2.8, 20, 3.2),
  ('Сливки 10%', 'DAIRY', 118, 3, 10, 4),
  ('Сыр российский', 'DAIRY', 363, 23.2, 29.5, 0),
  ('Сыр моцарелла', 'DAIRY', 240, 18, 17.5, 1),
  ('Сыр адыгейский', 'DAIRY', 240, 19.8, 16.5, 1.5),
  ('Брынза', 'DAIRY', 260, 17.9, 20.1, 0),
  ('Масло сливочное 82,5%', 'DAIRY', 748, 0.5, 82.5, 0.8),
  ('Яйцо куриное', 'EGGS', 157, 12.7, 11.5, 0.7),
  ('Яичный белок', 'EGGS', 48, 11, 0.2, 1),
  ('Перепелиное яйцо', 'EGGS', 168, 11.9, 13.1, 0.6),
  ('Куриное филе (грудка)', 'MEAT', 113, 23.6, 1.9, 0.4),
  ('Куриное бедро без кожи', 'MEAT', 121, 19.7, 4.1, 0),
  ('Курица (целая тушка)', 'MEAT', 165, 18.7, 9.7, 0.4),
  ('Куриная печень', 'MEAT', 136, 19.1, 6.3, 0.6),
  ('Индейка (филе)', 'MEAT', 114, 23.6, 1.5, 0),
  ('Говядина (мякоть)', 'MEAT', 187, 18.9, 12.4, 0),
  ('Говяжий фарш', 'MEAT', 254, 17.2, 20, 0),
  ('Свинина (мякоть)', 'MEAT', 259, 16, 21.6, 0),
  ('Свино-говяжий фарш', 'MEAT', 263, 16.7, 20.8, 0),
  ('Телятина', 'MEAT', 90, 19.7, 1.2, 0),
  ('Баранина', 'MEAT', 209, 16.3, 15.3, 0),
  ('Говяжья печень', 'MEAT', 127, 17.9, 3.7, 5.3),
  ('Колбаса «Докторская»', 'MEAT', 257, 13.7, 22.8, 0),
  ('Сосиски молочные', 'MEAT', 266, 11, 24, 1.6),
  ('Треска', 'FISH', 69, 16, 0.6, 0),
  ('Минтай', 'FISH', 72, 15.9, 0.9, 0),
  ('Хек', 'FISH', 86, 16.6, 2.2, 0),
  ('Горбуша', 'FISH', 140, 20.5, 6.5, 0),
  ('Сёмга', 'FISH', 208, 20.4, 13.4, 0),
  ('Форель', 'FISH', 97, 19.2, 2.1, 0),
  ('Скумбрия', 'FISH', 181, 18, 11.1, 0),
  ('Сельдь солёная', 'FISH', 217, 17.7, 16.2, 0),
  ('Кета', 'FISH', 138, 22, 5.6, 0),
  ('Судак', 'FISH', 84, 18.4, 1.1, 0),
  ('Тунец консервированный (в собственном соку)', 'FISH', 96, 21, 1, 0),
  ('Креветки', 'SEAFOOD', 87, 18, 1.1, 0),
  ('Кальмар', 'SEAFOOD', 75, 18, 0.3, 0),
  ('Мидии', 'SEAFOOD', 77, 11.5, 2, 3.3),
  ('Крабовые палочки', 'SEAFOOD', 95, 7.6, 0.5, 15),
  ('Картофель', 'VEGETABLES', 77, 2, 0.4, 16.3),
  ('Морковь', 'VEGETABLES', 32, 1.3, 0.1, 6.9),
  ('Свёкла', 'VEGETABLES', 43, 1.5, 0.1, 8.8),
  ('Репа', 'VEGETABLES', 32, 1.5, 0.1, 6.2),
  ('Капуста белокочанная', 'VEGETABLES', 28, 1.8, 0.1, 4.7),
  ('Капуста квашеная', 'VEGETABLES', 23, 1.8, 0.1, 4.4),
  ('Брокколи', 'VEGETABLES', 28, 3, 0.4, 4),
  ('Цветная капуста', 'VEGETABLES', 30, 2.5, 0.3, 4.2),
  ('Лук репчатый', 'VEGETABLES', 41, 1.4, 0, 10.4),
  ('Лук зелёный', 'VEGETABLES', 19, 1.3, 0, 3.5),
  ('Чеснок', 'VEGETABLES', 143, 6.5, 0.5, 29.9),
  ('Помидоры', 'VEGETABLES', 20, 1.1, 0.2, 3.7),
  ('Огурцы', 'VEGETABLES', 15, 0.8, 0.1, 2.8),
  ('Огурцы солёные', 'VEGETABLES', 11, 0.8, 0.1, 1.7),
  ('Перец болгарский', 'VEGETABLES', 27, 1.3, 0, 5.3),
  ('Кабачок', 'VEGETABLES', 24, 0.6, 0.3, 4.6),
  ('Баклажан', 'VEGETABLES', 24, 1.2, 0.1, 4.5),
  ('Тыква', 'VEGETABLES', 22, 1, 0.1, 4.4),
  ('Шпинат', 'VEGETABLES', 22, 2.9, 0.3, 2),
  ('Зелень (укроп, петрушка)', 'VEGETABLES', 36, 2.7, 0.6, 5),
  ('Редис', 'VEGETABLES', 19, 1.2, 0.1, 3.4),
  ('Стручковая фасоль', 'VEGETABLES', 31, 1.8, 0.2, 5.5),
  ('Шампиньоны', 'VEGETABLES', 27, 4.3, 1, 0.1),
  ('Зелёный горошек консервированный', 'VEGETABLES', 55, 3.6, 0.2, 8.7),
  ('Кукуруза консервированная', 'VEGETABLES', 119, 4.1, 2.3, 22.5),
  ('Фасоль красная (сухая)', 'LEGUMES', 298, 21, 2, 47),
  ('Чечевица (сухая)', 'LEGUMES', 295, 24, 1.5, 46.3),
  ('Нут (сухой)', 'LEGUMES', 364, 19, 6, 61),
  ('Горох колотый (сухой)', 'LEGUMES', 298, 23, 1.2, 48.1),
  ('Фасоль консервированная', 'LEGUMES', 90, 6, 0.5, 15),
  ('Тофу', 'LEGUMES', 76, 8.1, 4.8, 1.9),
  ('Яблоко', 'FRUITS', 47, 0.4, 0.4, 9.8),
  ('Банан', 'FRUITS', 96, 1.5, 0.2, 21.8),
  ('Груша', 'FRUITS', 47, 0.4, 0.3, 10.9),
  ('Апельсин', 'FRUITS', 43, 0.9, 0.2, 8.1),
  ('Мандарин', 'FRUITS', 38, 0.8, 0.2, 7.5),
  ('Киви', 'FRUITS', 61, 1.1, 0.5, 14.7),
  ('Грейпфрут', 'FRUITS', 35, 0.7, 0.2, 6.5),
  ('Виноград', 'FRUITS', 65, 0.6, 0.2, 16),
  ('Персик', 'FRUITS', 45, 0.9, 0.1, 9.5),
  ('Слива', 'FRUITS', 49, 0.8, 0.2, 9.6),
  ('Курага', 'FRUITS', 241, 5.2, 0.3, 55),
  ('Изюм', 'FRUITS', 264, 2.3, 0.5, 66),
  ('Чернослив', 'FRUITS', 231, 2.3, 0.7, 57.5),
  ('Клубника', 'BERRIES', 41, 0.8, 0.4, 7.5),
  ('Малина', 'BERRIES', 46, 0.8, 0.5, 8.3),
  ('Черника', 'BERRIES', 44, 1.1, 0.6, 7.6),
  ('Чёрная смородина', 'BERRIES', 44, 1, 0.4, 7.3),
  ('Клюква', 'BERRIES', 46, 0.4, 0.1, 12.2),
  ('Вишня', 'BERRIES', 52, 0.8, 0.2, 10.3),
  ('Ягоды замороженные (смесь)', 'BERRIES', 43, 0.8, 0.3, 9),
  ('Грецкий орех', 'NUTS', 654, 15.2, 65.2, 7),
  ('Миндаль', 'NUTS', 579, 21.2, 49.9, 21.6),
  ('Фундук', 'NUTS', 628, 15, 61, 9.7),
  ('Кешью', 'NUTS', 553, 18.2, 43.9, 30.2),
  ('Арахис', 'NUTS', 551, 26.3, 45.2, 9.9),
  ('Семечки подсолнечника', 'NUTS', 601, 20.7, 52.9, 3.4),
  ('Тыквенные семечки', 'NUTS', 556, 24.5, 45.8, 4.7),
  ('Семена чиа', 'NUTS', 486, 16.5, 30.7, 42.1),
  ('Семена льна', 'NUTS', 534, 18.3, 42.2, 28.9),
  ('Арахисовая паста', 'NUTS', 588, 25, 50, 20),
  ('Подсолнечное масло', 'OIL', 899, 0, 99.9, 0),
  ('Оливковое масло', 'OIL', 898, 0, 99.8, 0),
  ('Майонез «Провансаль»', 'SAUCES', 624, 0.3, 67, 2.6),
  ('Кетчуп', 'SAUCES', 93, 1.8, 1, 22.2),
  ('Соевый соус', 'SAUCES', 53, 8.1, 0, 4.9),
  ('Томатная паста', 'SAUCES', 92, 5, 0.5, 16.7),
  ('Мёд', 'SWEETS', 329, 0.8, 0, 81.5),
  ('Сахар', 'SWEETS', 399, 0, 0, 99.8),
  ('Варенье', 'SWEETS', 263, 0.3, 0.2, 70.9),
  ('Тёмный шоколад', 'SWEETS', 539, 6.2, 35.4, 48.2),
  ('Зефир', 'SWEETS', 304, 0.8, 0, 78.3),
  ('Печенье овсяное', 'SWEETS', 437, 6.5, 14.4, 71.8),
  ('Чай чёрный (без сахара)', 'BEVERAGES', 0, 0, 0, 0),
  ('Кофе (без сахара)', 'BEVERAGES', 1, 0.1, 0, 0),
  ('Сок апельсиновый', 'BEVERAGES', 45, 0.7, 0.2, 10.4)
) AS v(name, category, calories, protein, fat, carbohydrates)
WHERE NOT EXISTS (SELECT 1 FROM product x WHERE lower(x.name) = lower(v.name));

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Овсяная каша на молоке с бананом', 'Овсянка, сваренная на молоке, с бананом и мёдом', 15
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Овсяная каша на молоке с бананом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Овсяные хлопья', 60), ('Молоко 3,2%', 200), ('Банан', 100), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Овсянка на воде с ягодами и орехами', 'Овсянка на воде с ягодами, грецким орехом и мёдом', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Овсянка на воде с ягодами и орехами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Овсяные хлопья', 60), ('Ягоды замороженные (смесь)', 80), ('Грецкий орех', 15), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречневая молочная каша', 'Рассыпчатая гречка на молоке со сливочным маслом', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречневая молочная каша'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая крупа', 60), ('Молоко 2,5%', 200), ('Масло сливочное 82,5%', 5), ('Сахар', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Манная каша с вареньем', 'Классическая манная каша на молоке с вареньем', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Манная каша с вареньем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Манная крупа', 40), ('Молоко 3,2%', 250), ('Масло сливочное 82,5%', 5), ('Варенье', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Рисовая каша с курагой', 'Молочная рисовая каша с курагой', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Рисовая каша с курагой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Рис белый', 60), ('Молоко 2,5%', 250), ('Курага', 30), ('Масло сливочное 82,5%', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Пшённая каша с тыквой', 'Пшённая каша с тыквой на молоке', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Пшённая каша с тыквой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Пшено', 60), ('Тыква', 150), ('Молоко 2,5%', 150), ('Масло сливочное 82,5%', 5), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Сырники со сметаной', 'Творожные сырники со сметаной', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Сырники со сметаной'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 5%', 200), ('Яйцо куриное', 50), ('Мука пшеничная', 30), ('Сахар', 10), ('Подсолнечное масло', 8), ('Сметана 15%', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Омлет с помидорами и сыром', 'Омлет из трёх яиц с помидорами и сыром', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Омлет с помидорами и сыром'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яйцо куриное', 150), ('Молоко 2,5%', 50), ('Помидоры', 100), ('Сыр российский', 30), ('Подсолнечное масло', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Яичница с ржаным хлебом и огурцом', 'Яичница из двух яиц, ржаной хлеб, свежий огурец', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Яичница с ржаным хлебом и огурцом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яйцо куриное', 110), ('Хлеб ржаной (бородинский)', 60), ('Огурцы', 100), ('Подсолнечное масло', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Блины с творогом', 'Тонкие блины с творожной начинкой', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Блины с творогом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Мука пшеничная', 70), ('Молоко 2,5%', 180), ('Яйцо куриное', 50), ('Подсолнечное масло', 8), ('Творог 5%', 100), ('Сахар', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Творог со сметаной и ягодами', 'Творог со сметаной, ягодами и мёдом', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Творог со сметаной и ягодами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 5%', 200), ('Сметана 15%', 30), ('Ягоды замороженные (смесь)', 100), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Бутерброды с сыром и яйцом', 'Бутерброды на батоне с сыром, яйцом и огурцом', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Бутерброды с сыром и яйцом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Батон нарезной', 80), ('Сыр российский', 40), ('Яйцо куриное', 55), ('Огурцы', 60)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Йогурт с овсянкой и яблоком', 'Йогурт, овсяные хлопья, яблоко и мёд', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Йогурт с овсянкой и яблоком'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Йогурт натуральный 2,5%', 200), ('Овсяные хлопья', 40), ('Яблоко', 120), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Творожная запеканка', 'Запеканка из творога с манкой и изюмом', 45
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Творожная запеканка'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 5%', 250), ('Манная крупа', 30), ('Яйцо куриное', 50), ('Сахар', 15), ('Изюм', 20), ('Сметана 15%', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Оладьи на кефире с вареньем', 'Пышные оладьи на кефире с вареньем', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Оладьи на кефире с вареньем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Мука пшеничная', 80), ('Кефир 2,5%', 150), ('Яйцо куриное', 50), ('Сахар', 10), ('Подсолнечное масло', 12), ('Варенье', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречка с яйцом и огурцом', 'Гречка со сливочным маслом, варёные яйца, огурец', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречка с яйцом и огурцом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая крупа', 70), ('Яйцо куриное', 110), ('Масло сливочное 82,5%', 8), ('Огурцы', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Омлет со шпинатом и адыгейским сыром', 'Омлет со шпинатом и адыгейским сыром', 15
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Омлет со шпинатом и адыгейским сыром'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яйцо куриное', 150), ('Шпинат', 80), ('Молоко 2,5%', 80), ('Сыр адыгейский', 40), ('Подсолнечное масло', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Овсяный боул с кефиром и бананом', 'Кефир, овсяные хлопья и банан', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Овсяный боул с кефиром и бананом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Кефир 2,5%', 250), ('Овсяные хлопья', 40), ('Банан', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Овсяноблин с творогом', 'Овсяные хлопья с яйцом и молоком, творог', 15
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Овсяноблин с творогом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Овсяные хлопья', 50), ('Яйцо куриное', 55), ('Молоко 2,5%', 80), ('Творог 5%', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Тыквенная каша с рисом', 'Рис с тыквой на молоке', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Тыквенная каша с рисом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Рис белый', 50), ('Тыква', 200), ('Молоко 3,2%', 200), ('Масло сливочное 82,5%', 5), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Яблоко с арахисовой пастой', 'Яблоко и ложка арахисовой пасты', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Яблоко с арахисовой пастой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яблоко', 180), ('Арахисовая паста', 15)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Кефир с бананом', 'Стакан кефира и банан', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Кефир с бананом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Кефир 2,5%', 250), ('Банан', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Творог с курагой', 'Творог с курагой', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Творог с курагой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 5%', 150), ('Курага', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Йогурт с ягодами', 'Натуральный йогурт с ягодами', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Йогурт с ягодами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Йогурт натуральный 2,5%', 200), ('Ягоды замороженные (смесь)', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Хлебцы с сыром и помидором', 'Ржаные хлебцы с сыром и помидором', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Хлебцы с сыром и помидором'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Хлебцы ржаные', 30), ('Сыр российский', 30), ('Помидоры', 80)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Грецкие орехи и сухофрукты', 'Грецкие орехи, курага и изюм', 2
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Грецкие орехи и сухофрукты'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Грецкий орех', 20), ('Курага', 30), ('Изюм', 15)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Банан с миндалём', 'Банан и горсть миндаля', 2
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Банан с миндалём'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Банан', 120), ('Миндаль', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Овощные палочки с йогуртовым соусом', 'Морковь, огурец и перец с йогуртом', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Овощные палочки с йогуртовым соусом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Морковь', 100), ('Огурцы', 100), ('Перец болгарский', 80), ('Йогурт натуральный 2,5%', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Ряженка с овсяным печеньем', 'Стакан ряженки и овсяное печенье', 2
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Ряженка с овсяным печеньем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Ряженка 2,5%', 250), ('Печенье овсяное', 25)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Груша с сыром', 'Груша и ломтик сыра', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Груша с сыром'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Груша', 150), ('Сыр российский', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Апельсин и фундук', 'Апельсин и горсть фундука', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Апельсин и фундук'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Апельсин', 200), ('Фундук', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Яйцо с ржаным хлебом', 'Варёные яйца и ломтик ржаного хлеба', 12
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Яйцо с ржаным хлебом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яйцо куриное', 110), ('Хлеб ржаной (бородинский)', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Печёное яблоко с творогом', 'Яблоко, запечённое с творогом и мёдом', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Печёное яблоко с творогом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яблоко', 200), ('Творог 5%', 80), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Кефир с сушками', 'Стакан кефира и сушки', 2
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Кефир с сушками'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Кефир 2,5%', 250), ('Сушки', 25)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('BREAKFAST'), ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Борщ с говядиной и сметаной', 'Классический борщ со сметаной и ржаным хлебом', 90
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Борщ с говядиной и сметаной'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Свёкла', 80), ('Капуста белокочанная', 100), ('Картофель', 120), ('Морковь', 40), ('Лук репчатый', 40), ('Говядина (мякоть)', 80), ('Томатная паста', 15), ('Подсолнечное масло', 8), ('Сметана 15%', 30), ('Хлеб ржаной (бородинский)', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Щи из свежей капусты', 'Щи с говядиной и сметаной', 80
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Щи из свежей капусты'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Капуста белокочанная', 200), ('Картофель', 120), ('Морковь', 40), ('Лук репчатый', 40), ('Говядина (мякоть)', 80), ('Подсолнечное масло', 8), ('Сметана 15%', 30), ('Хлеб ржаной (бородинский)', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Куриный суп с лапшой', 'Домашний суп с курицей и лапшой', 45
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Куриный суп с лапшой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Куриное филе (грудка)', 100), ('Макароны (сухие)', 40), ('Картофель', 100), ('Морковь', 40), ('Лук репчатый', 30), ('Подсолнечное масло', 5), ('Зелень (укроп, петрушка)', 5), ('Хлеб пшеничный', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гороховый суп со свининой', 'Густой гороховый суп со свининой', 100
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гороховый суп со свининой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Горох колотый (сухой)', 80), ('Картофель', 100), ('Морковь', 40), ('Лук репчатый', 40), ('Свинина (мякоть)', 80), ('Подсолнечное масло', 5), ('Хлеб ржаной (бородинский)', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Рассольник с перловкой', 'Рассольник с солёными огурцами и говядиной', 80
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Рассольник с перловкой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Перловая крупа', 40), ('Картофель', 100), ('Огурцы солёные', 80), ('Морковь', 40), ('Лук репчатый', 30), ('Говядина (мякоть)', 80), ('Подсолнечное масло', 8), ('Сметана 15%', 30), ('Хлеб ржаной (бородинский)', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Уха из горбуши', 'Уха с картофелем и морковью', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Уха из горбуши'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Горбуша', 150), ('Картофель', 120), ('Морковь', 40), ('Лук репчатый', 40), ('Подсолнечное масло', 5), ('Хлеб пшеничный', 60)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Плов с курицей', 'Рассыпчатый плов с куриным бедром', 60
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Плов с курицей'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Рис белый', 90), ('Куриное бедро без кожи', 150), ('Морковь', 80), ('Лук репчатый', 50), ('Подсолнечное масло', 12), ('Чеснок', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Плов с говядиной', 'Плов с говядиной, морковью и чесноком', 90
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Плов с говядиной'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Рис белый', 90), ('Говядина (мякоть)', 120), ('Морковь', 80), ('Лук репчатый', 50), ('Подсолнечное масло', 12), ('Чеснок', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречка с куриной котлетой', 'Гречка, куриная котлета и свежий огурец', 45
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречка с куриной котлетой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая крупа', 90), ('Куриное филе (грудка)', 150), ('Яйцо куриное', 20), ('Лук репчатый', 20), ('Хлеб пшеничный', 20), ('Подсолнечное масло', 10), ('Огурцы', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Макароны по-флотски', 'Макароны с говяжьим фаршем и жареным луком', 30
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Макароны по-флотски'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Макароны (сухие)', 90), ('Говяжий фарш', 120), ('Лук репчатый', 40), ('Подсолнечное масло', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Котлеты с картофельным пюре', 'Домашние котлеты и пюре на молоке', 55
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Котлеты с картофельным пюре'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Свино-говяжий фарш', 120), ('Хлеб пшеничный', 20), ('Лук репчатый', 30), ('Картофель', 250), ('Молоко 3,2%', 50), ('Масло сливочное 82,5%', 10), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Тефтели с рисом в томатном соусе', 'Тефтели в томатно-сметанном соусе', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Тефтели с рисом в томатном соусе'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Говяжий фарш', 120), ('Рис белый', 40), ('Лук репчатый', 30), ('Томатная паста', 20), ('Сметана 15%', 20), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Курица, запечённая с картофелем', 'Куриное бедро с картофелем и чесноком', 60
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Курица, запечённая с картофелем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Куриное бедро без кожи', 200), ('Картофель', 250), ('Лук репчатый', 40), ('Майонез «Провансаль»', 15), ('Чеснок', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Пельмени со сметаной', 'Варёные мясные пельмени со сметаной', 20
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Пельмени со сметаной'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Пельмени мясные', 250), ('Сметана 15%', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Ленивые голубцы', 'Запечённые голубцы из капусты, фарша и риса', 60
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Ленивые голубцы'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Капуста белокочанная', 200), ('Говяжий фарш', 100), ('Рис белый', 30), ('Лук репчатый', 30), ('Морковь', 30), ('Сметана 15%', 30), ('Томатная паста', 15), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Картофельная запеканка с фаршем', 'Картофельное пюре и фарш под сыром', 60
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Картофельная запеканка с фаршем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Картофель', 300), ('Говяжий фарш', 120), ('Лук репчатый', 40), ('Сыр российский', 30), ('Молоко 3,2%', 50), ('Масло сливочное 82,5%', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречка с грибами', 'Гречка с жареными шампиньонами и луком', 30
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречка с грибами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая крупа', 90), ('Шампиньоны', 150), ('Лук репчатый', 50), ('Подсолнечное масло', 12), ('Сметана 15%', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Минтай, запечённый с рисом', 'Минтай под морковью и луком, рис', 45
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Минтай, запечённый с рисом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Минтай', 200), ('Рис белый', 80), ('Морковь', 50), ('Лук репчатый', 40), ('Подсолнечное масло', 12), ('Сметана 15%', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Индейка с булгуром и овощами', 'Индейка, булгур, кабачок и перец', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Индейка с булгуром и овощами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Индейка (филе)', 180), ('Булгур', 80), ('Кабачок', 100), ('Перец болгарский', 80), ('Оливковое масло', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Чечевичный суп с курицей', 'Густой суп из чечевицы с курицей', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Чечевичный суп с курицей'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Чечевица (сухая)', 70), ('Куриное филе (грудка)', 100), ('Морковь', 50), ('Лук репчатый', 40), ('Картофель', 100), ('Подсолнечное масло', 8), ('Хлеб ржаной (бородинский)', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Овощное рагу с говядиной', 'Говядина, тушёная с картофелем и овощами', 70
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Овощное рагу с говядиной'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Говядина (мякоть)', 150), ('Картофель', 200), ('Кабачок', 100), ('Морковь', 50), ('Лук репчатый', 40), ('Перец болгарский', 60), ('Томатная паста', 15), ('Подсолнечное масло', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Макароны с курицей в сливочном соусе', 'Макароны, курица и сыр в сливочном соусе', 30
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Макароны с курицей в сливочном соусе'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Макароны (сухие)', 90), ('Куриное филе (грудка)', 150), ('Сыр российский', 30), ('Сливки 10%', 50), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Жареная картошка с грибами', 'Картофель, жареный с грибами и луком', 30
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Жареная картошка с грибами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Картофель', 300), ('Шампиньоны', 150), ('Лук репчатый', 50), ('Подсолнечное масло', 20), ('Огурцы солёные', 80)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречка по-купечески', 'Гречка со свининой, луком и морковью', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречка по-купечески'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая крупа', 80), ('Свинина (мякоть)', 120), ('Лук репчатый', 40), ('Морковь', 40), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Окрошка на кефире', 'Холодный суп с колбасой, яйцом и огурцами', 30
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Окрошка на кефире'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Картофель', 150), ('Яйцо куриное', 110), ('Огурцы', 150), ('Колбаса «Докторская»', 80), ('Кефир 2,5%', 300), ('Зелень (укроп, петрушка)', 10), ('Редис', 50)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Горбуша, запечённая с брокколи', 'Горбуша с брокколи под оливковым маслом', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Горбуша, запечённая с брокколи'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Горбуша', 200), ('Брокколи', 150), ('Оливковое масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Куриная грудка с гречкой', 'Отварная грудка, гречка и огурцы', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Куриная грудка с гречкой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Куриное филе (грудка)', 150), ('Гречневая крупа', 60), ('Огурцы', 100), ('Подсолнечное масло', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Тушёная капуста с курицей', 'Капуста, тушёная с курицей и морковью', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Тушёная капуста с курицей'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Капуста белокочанная', 300), ('Куриное бедро без кожи', 120), ('Морковь', 50), ('Лук репчатый', 40), ('Томатная паста', 10), ('Подсолнечное масло', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Рыбные котлеты с картофельным пюре', 'Котлеты из минтая и пюре', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Рыбные котлеты с картофельным пюре'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Минтай', 200), ('Хлеб пшеничный', 30), ('Лук репчатый', 30), ('Яйцо куриное', 25), ('Картофель', 200), ('Молоко 3,2%', 50), ('Масло сливочное 82,5%', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Омлет с овощами и сыром', 'Омлет с помидорами, перцем и сыром', 15
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Омлет с овощами и сыром'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яйцо куриное', 150), ('Молоко 2,5%', 80), ('Помидоры', 100), ('Перец болгарский', 80), ('Сыр российский', 30), ('Подсолнечное масло', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Кабачки, фаршированные индейкой', 'Кабачки с индейкой и рисом в сметане', 60
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Кабачки, фаршированные индейкой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Индейка (филе)', 150), ('Кабачок', 300), ('Рис белый', 20), ('Лук репчатый', 40), ('Томатная паста', 10), ('Сметана 15%', 30), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Треска, запечённая с картофелем', 'Треска со сметаной и картофелем', 45
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Треска, запечённая с картофелем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Треска', 200), ('Картофель', 250), ('Подсолнечное масло', 10), ('Сметана 15%', 30), ('Лук репчатый', 40)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Паровые куриные котлеты с рисом', 'Диетические котлеты на пару с рисом', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Паровые куриные котлеты с рисом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Куриное филе (грудка)', 180), ('Хлеб пшеничный', 20), ('Молоко 2,5%', 30), ('Лук репчатый', 30), ('Рис белый', 60)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Салат с тунцом и яйцом', 'Тунец, яйцо, овощи и ржаной хлеб', 15
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Салат с тунцом и яйцом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Тунец консервированный (в собственном соку)', 100), ('Яйцо куриное', 110), ('Огурцы', 100), ('Помидоры', 100), ('Оливковое масло', 10), ('Хлеб ржаной (бородинский)', 40)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Тушёная говядина с гречкой', 'Говядина в томатном соусе с гречкой', 90
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Тушёная говядина с гречкой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Говядина (мякоть)', 150), ('Гречневая крупа', 60), ('Лук репчатый', 40), ('Морковь', 30), ('Томатная паста', 10), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Минтай в сметанном соусе с макаронами', 'Минтай в сметане с макаронами', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Минтай в сметанном соусе с макаронами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Минтай', 200), ('Сметана 15%', 30), ('Макароны (сухие)', 70), ('Лук репчатый', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Сёмга с бурым рисом и брокколи', 'Запечённая сёмга, бурый рис, брокколи', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Сёмга с бурым рисом и брокколи'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Сёмга', 150), ('Рис бурый', 60), ('Брокколи', 100), ('Оливковое масло', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Запечённая индейка с овощами', 'Индейка с картофелем и морковью', 60
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Запечённая индейка с овощами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Индейка (филе)', 200), ('Картофель', 200), ('Морковь', 60), ('Лук репчатый', 40), ('Подсолнечное масло', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Запеканка из цветной капусты с сыром', 'Цветная капуста под сырным соусом', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Запеканка из цветной капусты с сыром'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Цветная капуста', 300), ('Яйцо куриное', 55), ('Сыр российский', 40), ('Сливки 10%', 50), ('Масло сливочное 82,5%', 5)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Лобио из красной фасоли', 'Фасоль с луком, орехами и зеленью', 70
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Лобио из красной фасоли'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Фасоль красная (сухая)', 80), ('Лук репчатый', 50), ('Подсолнечное масло', 10), ('Грецкий орех', 15), ('Томатная паста', 10), ('Зелень (укроп, петрушка)', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречневая лапша с курицей и овощами', 'Соба с курицей, перцем и морковью', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречневая лапша с курицей и овощами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая лапша (соба)', 80), ('Куриное филе (грудка)', 120), ('Перец болгарский', 80), ('Морковь', 60), ('Соевый соус', 15), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Скумбрия, запечённая с картофелем', 'Скумбрия с картофелем и луком', 45
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Скумбрия, запечённая с картофелем'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Скумбрия', 200), ('Картофель', 150), ('Лук репчатый', 40)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Винегрет с селёдкой', 'Винегрет, солёная сельдь и ржаной хлеб', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Винегрет с селёдкой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Свёкла', 120), ('Картофель', 100), ('Морковь', 60), ('Огурцы солёные', 60), ('Зелёный горошек консервированный', 40), ('Подсолнечное масло', 15), ('Лук репчатый', 20), ('Сельдь солёная', 60), ('Хлеб ржаной (бородинский)', 60)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Куриная печень с гречкой', 'Печень в сметане с гречкой', 35
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Куриная печень с гречкой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Куриная печень', 150), ('Гречневая крупа', 60), ('Лук репчатый', 50), ('Сметана 15%', 30), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Тыквенный крем-суп', 'Крем-суп из тыквы со сливками', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Тыквенный крем-суп'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Тыква', 300), ('Картофель', 100), ('Лук репчатый', 40), ('Сливки 10%', 100), ('Масло сливочное 82,5%', 10), ('Хлеб пшеничный', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Креветки с рисом и овощами', 'Креветки, рис, перец и морковь', 25
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Креветки с рисом и овощами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Креветки', 150), ('Рис белый', 60), ('Перец болгарский', 80), ('Морковь', 50), ('Подсолнечное масло', 10), ('Соевый соус', 15)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Говяжья печень с картофельным пюре', 'Тушёная печень с луком и пюре', 40
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Говяжья печень с картофельным пюре'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Говяжья печень', 150), ('Картофель', 250), ('Молоко 3,2%', 50), ('Лук репчатый', 50), ('Масло сливочное 82,5%', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Гречневая запеканка с творогом', 'Запеканка из гречки и творога', 50
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Гречневая запеканка с творогом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Гречневая крупа', 60), ('Творог 5%', 150), ('Яйцо куриное', 50), ('Сметана 15%', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Кальмар с рисом и овощами', 'Кальмар, рис, морковь и лук', 30
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Кальмар с рисом и овощами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Кальмар', 200), ('Рис белый', 60), ('Морковь', 50), ('Лук репчатый', 40), ('Подсолнечное масло', 8)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('LUNCH'), ('DINNER')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Творог с бананом и мёдом', 'Творог с бананом и мёдом', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Творог с бананом и мёдом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 5%', 200), ('Банан', 100), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('DINNER'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Кефир с овсяными хлопьями', 'Кефир с замоченными овсяными хлопьями', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Кефир с овсяными хлопьями'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Кефир 1%', 250), ('Овсяные хлопья', 30)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Ряженка с грецкими орехами', 'Стакан ряженки и грецкие орехи', 2
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Ряженка с грецкими орехами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Ряженка 2,5%', 250), ('Грецкий орех', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Варёное яйцо с овощами', 'Варёные яйца, огурец и помидор', 10
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Варёное яйцо с овощами'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Яйцо куриное', 110), ('Огурцы', 100), ('Помидоры', 100)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Творожок с ягодами и мёдом', 'Нежирный творог с ягодами и мёдом', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Творожок с ягодами и мёдом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 0%', 200), ('Ягоды замороженные (смесь)', 100), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Бутерброд с куриным филе', 'Ржаной хлеб, куриное филе и огурец', 15
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Бутерброд с куриным филе'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Хлеб ржаной (бородинский)', 50), ('Куриное филе (грудка)', 80), ('Огурцы', 80)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Греческий йогурт с орехами и мёдом', 'Греческий йогурт, миндаль и мёд', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Греческий йогурт с орехами и мёдом'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Греческий йогурт 2%', 200), ('Миндаль', 20), ('Мёд', 10)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Банан с арахисовой пастой', 'Банан и арахисовая паста', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Банан с арахисовой пастой'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Банан', 150), ('Арахисовая паста', 20)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Кефир с черносливом и миндалём', 'Кефир, чернослив и миндаль', 3
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Кефир с черносливом и миндалём'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Кефир 1%', 250), ('Чернослив', 30), ('Миндаль', 15)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

WITH d AS (
  INSERT INTO dish (name, description, cooking_time)
  SELECT 'Творог с огурцом и зеленью', 'Солёный творог со сметаной, огурцом и зеленью', 5
  WHERE NOT EXISTS (SELECT 1 FROM dish WHERE lower(name) = lower('Творог с огурцом и зеленью'))
  RETURNING id
), ing AS (
  INSERT INTO dish_ingredient (dish_id, product_id, amount)
  SELECT d.id, p.id, v.amount
  FROM d CROSS JOIN (VALUES ('Творог 5%', 200), ('Огурцы', 100), ('Зелень (укроп, петрушка)', 10), ('Сметана 15%', 15)) AS v(pname, amount)
  JOIN product p ON lower(p.name) = lower(v.pname)
)
INSERT INTO meal_type_by_dish (dish_id, meal_type)
SELECT d.id, t.meal_type FROM d CROSS JOIN (VALUES ('SNACK'), ('SECOND_SNACK')) AS t(meal_type);

COMMIT;
