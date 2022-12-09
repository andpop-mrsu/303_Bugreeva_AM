import csv

file = open("db_init.sql", 'w', encoding='utf-8')

#Пересоздание в случае существования
tables = ["movies", "ratings", "tags", "users"]
for name in tables:
    file.write("DROP TABLE IF EXISTS " + name + ";\n")
file.write("\n")

#Создание таблиц
file.write("""
CREATE TABLE movies (
  id INTEGER(8) PRIMARY KEY,
  title VARCHAR(255),
  year INTEGER(8),
  genres VARCHAR(255)
);
""")
file.write("\n\n")

file.write("""
CREATE TABLE ratings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  movie_id INTEGER NOT NULL,
  rating REAL NOT NULL,
  'timestamp' INTEGER NOT NULL
);
""")
file.write("\n\n")

file.write("""
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  movie_id INTEGER NOT NULL,
  tag VARCHAR(255),
  'timestamp' INTEGER NOT NULL
);
""")
file.write("\n\n")

file.write("""
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(255),
  email VARCHAR(255),
  gender VARCHAR(255),
  register_date VARCHAR(128),
  occupation VARCHAR(255)
);
""")
file.write("\n\n")

#INSERT запросы
insertM = "\nINSERT INTO movies VALUES "

j = 0

movie = []
movieId = []
with open("../dataset/movies.csv", encoding='utf-8') as file:
    csvfilereader = csv.reader(file, delimiter=",")
    i = 0
    for sas in csvfilereader:
        if(i == 0):
            movie.append(sas)
            i += 1
            continue
        movieId.append(sas[0])
        if(sas[0] == "7789"):
            bufferYear = sas[1][-5:]
            bufferYear = bufferYear.replace(")", "")
            name = sas[1].split(" (")
            name = name[0].replace("\'",".")
            name = name.replace("\"", ".")
            movie.append(sas)
            movie[i][0] = name
            movie[i][1] = bufferYear
            i += 1
            continue
        bufferYear = sas[1][-5:]
        bufferYear = bufferYear.replace(")", "")
        bufferYear = bufferYear.replace(" ", "")
        if(bufferYear.isdigit()):
            bufferName = sas[1][0:len(sas[1]) - 7]
            movie.append(sas)
            movie[i][0] = bufferName
            movie[i][1] = bufferYear
            i += 1
        else:
            name = sas[1]
            year = "NULL"
            movie.append(sas)
            movie[i][0] = name
            movie[i][1] = year
            i += 1

movie.pop(0)

file = open("db_init.sql", 'a', encoding='utf-8')
file.write(insertM)
for i in range(len(movie)):
    if(i != len(movie)-1):
        file.write(f'({movieId[i]},"{movie[i][0]}",{movie[i][1]},"{movie[i][2]}"),\n')
    else:
        file.write(f'({movieId[i]},"{movie[i][0]}",{movie[i][1]},"{movie[i][2]}");')

rating = []
insertR = "\n\nINSERT INTO ratings VALUES "
with open("../dataset/ratings.csv", encoding='utf-8') as file:
    csvfilereader = csv.reader(file, delimiter=",")
    for sas in csvfilereader:
        rating.append(sas)

rating.pop(0)
file = open("db_init.sql", 'a', encoding='utf-8')
file.write(insertR)
for i in range(len(rating)):
    if(i != len(rating)-1):
        file.write(f'(NULL,"{rating[i][0]}","{rating[i][1]}","{rating[i][2]}","{rating[i][3]}"),\n')
    else:
        file.write(f'(NULL,"{rating[i][0]}","{rating[i][1]}","{rating[i][2]}","{rating[i][3]}");')

tag = []
insertT = "\n\nINSERT INTO tags VALUES "
with open("../dataset/tags.csv", encoding='utf-8') as file:
    csvfilereader = csv.reader(file, delimiter=",")
    for sas in csvfilereader:
        tag.append(sas)

tag.pop(0)
file = open("db_init.sql", 'a', encoding='utf-8')
file.write(insertT)
for i in range(len(tag)):
    if(i != len(tag)-1):
        if (tag[i][3] == "1525285878"):
            file.write(f'(NULL,"{tag[i][0]}","{tag[i][1]}",{tag[i][2]},"{tag[i][3]}"),\n')
            continue
        file.write(f'(NULL,"{tag[i][0]}","{tag[i][1]}","{tag[i][2]}","{tag[i][3]}"),\n')
    else:
        file.write(f'(NULL,"{tag[i][0]}","{tag[i][1]}","{tag[i][2]}","{tag[i][3]}");')

user = []
insertU = "\n\nINSERT INTO users VALUES "
with open("../dataset/users.txt", encoding='utf-8') as file:
    csvfilereader = csv.reader(file, delimiter=",")
    for sas in csvfilereader:
        buffer = sas[0].split('|')
        user.append(buffer)
file = open("db_init.sql", 'a', encoding='utf-8')
file.write(insertU)
for i in range(len(user)):
    if(i != len(user)-1):
        file.write(f'(NULL,"{user[i][1]}","{user[i][2]}","{user[i][3]}","{user[i][4]}","{user[i][5]}"),\n')
    else:
        file.write(f'(NULL,"{user[i][1]}","{user[i][2]}","{user[i][3]}","{user[i][4]}","{user[i][5]}");')


