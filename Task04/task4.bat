#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT v1.name AS FirstViewer,v2.name AS SecondViewer,title,r1.rating AS FirstViewerRating,r2.rating AS SecondViewerRating FROM movies AS m1 INNER JOIN ratings r1 ON m1.id = r1.movie_id INNER JOIN ratings r2 ON m1.id = r2.movie_id INNER JOIN users v1 ON r1.user_id = v1.id INNER JOIN users v2 ON r2.user_id = v2.id WHERE (v1.id<v2.id AND r1.id < r2.id);"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT name,rating,DATE(timestamp,'unixepoch') AS date FROM ratings INNER JOIN users ON ratings.user_id = users.id ORDER BY date DESC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке "Рекомендуем" для фильмов должно быть написано "Да" или "Нет"."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title, year, result.rating AS rating, result.recommend AS 'Рекомендуем' FROM movies INNER JOIN (SELECT avegare.movie_id AS movie_id, avegare.middleValue AS rating, CASE avegare.middleValue WHEN TopAndBottom.MaxRate THEN 'Да' WHEN TopAndBottom.MinRate THEN'Нет' END recommend FROM (SELECT movie_id, AVG(rating) AS middleValue FROM ratings GROUP BY movie_id) avegare INNER JOIN (SELECT MAX(mid_val) AS MaxRate, MAX(mid_val) AS MinRate FROM (SELECT movie_id, AVG(rating) AS mid_val FROM ratings GROUP BY movie_id)) TopAndBottom ON avegare.middleValue== TopAndBottom.MaxRate OR avegare.middleValue== TopAndBottom.MinRate) result ON movies.id==movie_id ORDER BY year, title;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(ratings.rating) AS NumberOfWomen,AVG(rating) AS AverageRating FROM ratings INNER JOIN users ON ratings.user_id = users.id WHERE (users.gender = 'female' AND CAST(DATE(timestamp,'unixepoch') AS INTEGER) BETWEEN 2010 AND 2012);"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title, year, average.average_rating,ROW_NUMBER() OVER (ORDER BY average_rating) AS 'Place in Rating' FROM movies INNER JOIN (SELECT movie_id, AVG(rating) AS average_rating FROM ratings GROUP BY movie_id) AS average ON average.movie_id = movies.id ORDER BY movies.year, movies.title LIMIT 20;"
echo " "

echo "6. Вывести список из 10 последних зарегистрированных пользователей в формате "Фамилия Имя|Дата регистрации" (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT SUBSTRING(name ,INSTR(name,' ')+1) || ' ' || SUBSTRING(name ,0,INSTR(name,' ')) AS LastName_FirstName,register_date FROM users ORDER BY register_date DESC LIMIT 20;"
echo " "

echo "7. С помощью рекурсивного CTE составить таблицу умножения для чисел от 1 до 10. Должен получиться один столбец следующего вида:
1x1=1
1x2=2
. . .
1x10=10
2x1=2
2x2=2
. . .
10x9=90
10x10=100"
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE ten(x,y) AS (SELECT 1, 1 UNION ALL SELECT x+(y)/10,(y+0)%10+1 FROM ten WHERE x<10) SELECT ten.x || '*' || ten.y || ' = ' ||  FORMAT(ten.x*ten.y) AS Multiplication FROM ten WHERE ten.x <= 10;"
echo " "

echo "8. С помощью рекурсивного CTE выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH GenresList(length, part, result) AS (SELECT 1, movies.genres||'|', '' FROM movies WHERE 1 UNION ALL SELECT INSTR(part, '|' ) AS delimetr, SUBSTR(part, INSTR(part, '|' ) + 1), SUBSTR(part, 1, INSTR(part, '|' ) - 1)FROM GenresList WHERE delimetr > 0)SELECT DISTINCT result AS 'Genres' FROM GenresList WHERE length(result) > 0;"
echo " "