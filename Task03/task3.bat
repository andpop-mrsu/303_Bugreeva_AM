#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title FROM ratings INNER JOIN movies on movies.id = ratings.movie_id and year NOT NULL GROUP BY title HAVING count(movie_id) ORDER BY year,title LIMIT 10;"
echo ""

echo "2.Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT name FROM users WHERE SUBSTRING(name ,instr(name,' ')+1) LIKE 'A%' ORDER BY register_date LIMIT 5;"
echo ""

echo "3.Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT name,title,year,rating,DATE(timestamp,'unixepoch') as date FROM ratings INNER JOIN movies on movies.id = ratings.movie_id INNER JOIN users on ratings.user_id = users.id ORDER BY users.name,title,rating LIMIT 50;"
echo ""

echo "4.Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title,tag FROM tags INNER JOIN movies on movie_id == movies.id WHERE year NOT NULL ORDER BY year,title,tag LIMIT 40;"
echo ""

echo "5.Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)"
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title FROM movies WHERE year=(SELECT max(year) FROM movies);"
echo ""

echo "6.Найти все комедии, выпущенные после 2000 года, которые понравились мужчинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT comedy.title,comedy.year,count(comedy.title) as number_rating FROM ratings INNER JOIN (SELECT title,id,year FROM movies WHERE genres LIKE '%Comedy%' AND year > 2000) comedy ON movie_id == comedy.id INNER JOIN users ON ratings.user_id = users.id WHERE gender == 'male' GROUP BY comedy.title ORDER BY comedy.year,comedy.title;"
echo ""

echo "7.Провести анализ занятий (профессий) пользователей - вывести количество пользователей для каждого рода занятий. Найти самую распространенную и самую редкую профессию посетитетей сайта."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT users.occupation,count(users.occupation) as number_occupation FROM users GROUP BY occupation;"
echo ""

echo " Самая распространённая профессия."
sqlite3 movies_rating.db -box -echo "SELECT occupation,max(number_occupation) as common_profession FROM (SELECT users.occupation,count(users.occupation) as number_occupation FROM users GROUP BY occupation);"
echo ""

echo " Самая редкая профессия."
sqlite3 movies_rating.db -box -echo "SELECT occupation,min(number_occupation) as rarest_profession FROM (SELECT users.occupation,count(users.occupation) as number_occupation FROM users GROUP BY occupation);"
echo ""



