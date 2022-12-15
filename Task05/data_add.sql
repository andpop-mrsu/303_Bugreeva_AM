INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Kirill","Ryabikin","kirill2002ares@gmail.com","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Anton","Timovkin","anton.timovk@cloud.com","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Denis","Turaes","denis_turaev@yandex.com","male",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Darya","Akimova","akimdar@mail.eu","female",19);
INSERT INTO users (first_name,last_name,email,gender,occupation_id) VALUES ("Sergey","Akaykin","aksergkonyan@yaml.net","male",19);

INSERT INTO movies(title,year) VALUES
('Strange World',2022),
('Wednesday',2022),
('Bleach: Thousand Year Blood War',2022);

INSERT INTO ratings(user_id,movie_id,rating) VALUES
((SELECT id FROM users WHERE email="kirill2002ares@gmail.com"),
(SELECT id FROM movies WHERE title="Strange World"), 2.5),
((SELECT id FROM users WHERE email="kirill2002ares@gmail.com"),
(SELECT id FROM movies WHERE title="Wednesday"), 4.0),
((SELECT id FROM users WHERE email="kirill2002ares@gmail.com"),
(SELECT id FROM movies WHERE title="Bleach: Thousand Year Blood War"), 5.0);

