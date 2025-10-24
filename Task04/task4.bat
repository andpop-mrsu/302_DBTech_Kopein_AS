#!/bin/bash
chcp 65001

echo "Проверка наличия необходимых файлов..."
if [ ! -f "sqlite3.exe" ]; then
    echo "Ошибка: sqlite3.exe не найден в текущей директории"
    exit 1
fi

if [ ! -f "db_init.sql" ]; then
    echo "Ошибка: db_init.sql не найден в текущей директории"
    exit 1
fi

echo "Исправляем ошибки в db_init.sql..."
sed 's/,None,/,NULL,/g; s/,None)/,NULL)/g' db_init.sql > db_init_fixed.sql

echo "Файлы найдены, создаем базу данных..."

rm -f movies_rating.db
./sqlite3.exe movies_rating.db < db_init.sql

echo "База данных создана, выполняем запросы..."
echo ""

echo "1. Найти все пары пользователей, оценивших один и тот же фильм..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "SELECT DISTINCT
    u1.name AS user1,
    u2.name AS user2,
    m.title AS movie
FROM ratings r1
JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id
JOIN users u1 ON r1.user_id = u1.id
JOIN users u2 ON r2.user_id = u2.id
JOIN movies m ON r1.movie_id = m.id
LIMIT 100;"
echo ""

echo "2. Найти 10 самых старых оценок..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "SELECT 
    m.title,
    u.name,
    r.rating,
    strftime('%Y-%m-%d', datetime(r.timestamp, 'unixepoch')) AS rating_date
FROM ratings r
JOIN movies m ON r.movie_id = m.id
JOIN users u ON r.user_id = u.id
ORDER BY r.timestamp ASC
LIMIT 10;"
echo ""

echo "3. Фильмы с максимальным и минимальным рейтингом..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "WITH avg_ratings AS (
    SELECT movie_id, AVG(rating) AS avg_rating
    FROM ratings GROUP BY movie_id
),
max_avg AS (SELECT MAX(avg_rating) AS max_r FROM avg_ratings),
min_avg AS (SELECT MIN(avg_rating) AS min_r FROM avg_ratings)
SELECT 
    m.year,
    m.title,
    ROUND(ar.avg_rating, 2) AS avg_rating,
    CASE WHEN ar.avg_rating = (SELECT max_r FROM max_avg) THEN 'Да' ELSE 'Нет' END AS Рекомендуем
FROM movies m
JOIN avg_ratings ar ON m.id = ar.movie_id
WHERE ar.avg_rating = (SELECT max_r FROM max_avg) OR ar.avg_rating = (SELECT min_r FROM min_avg)
ORDER BY m.year, m.title;"
echo ""

echo "4. Оценки мужчин за 2011-2014..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "SELECT 
    COUNT(*) AS количество_оценок,
    ROUND(AVG(r.rating), 2) AS средняя_оценка
FROM ratings r
JOIN users u ON r.user_id = u.id
WHERE u.gender = 'male'
    AND strftime('%Y', datetime(r.timestamp, 'unixepoch')) BETWEEN '2011' AND '2014';"
echo ""

echo "5. Список фильмов с оценками..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "SELECT 
    m.year,
    m.title,
    ROUND(AVG(r.rating), 2) AS средняя_оценка,
    COUNT(DISTINCT r.user_id) AS количество_пользователей
FROM movies m
LEFT JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.year, m.title
ORDER BY m.year, m.title
LIMIT 20;"
echo ""

echo "6. Самый распространенный жанр..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "WITH genre_counts AS (
    WITH RECURSIVE split(genre, rest) AS (
        SELECT '', genres || '|' FROM movies
        UNION ALL
        SELECT substr(rest, 0, instr(rest, '|')), substr(rest, instr(rest, '|') + 1)
        FROM split WHERE rest != ''
    )
    SELECT genre, COUNT(*) as count FROM split WHERE genre != '' GROUP BY genre ORDER BY count DESC
)
SELECT genre AS самый_распространенный_жанр, count AS количество_фильмов
FROM genre_counts LIMIT 1;"
echo ""

echo "7. Последние зарегистрированные пользователи..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "SELECT 
    name AS 'Фамилия Имя',
    register_date AS 'Дата регистрации'
FROM users
ORDER BY register_date DESC
LIMIT 10;"
echo ""

echo "8. День рождения по годам..."
echo "--------------------------------------------------"
./sqlite3.exe movies_rating.db -box -echo "WITH RECURSIVE years(year) AS (
    SELECT 2000 UNION ALL SELECT year + 1 FROM years WHERE year < 2024
)
SELECT 
    year,
    strftime('%Y-%m-%d', year || '-12-15') AS birthday,
    CASE strftime('%w', year || '-12-15')
        WHEN '0' THEN 'Воскресенье' WHEN '1' THEN 'Понедельник' WHEN '2' THEN 'Вторник'
        WHEN '3' THEN 'Среда' WHEN '4' THEN 'Четверг' WHEN '5' THEN 'Пятница' WHEN '6' THEN 'Суббота'
    END AS day_of_week
FROM years;"
echo ""

rm -f db_init_fixed.sql
