BEGIN TRANSACTION;

-- Удаление существующих таблиц
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;

-- Создание таблицы movies
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);

-- Создание таблицы ratings
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL
);

-- Создание таблицы tags
CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL
);

-- Создание таблицы users
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);

-- Вставка данных в movies
INSERT INTO movies VALUES (1,'Toy Story',1995,'Adventure|Animation|Children|Comedy|Fantasy');
INSERT INTO movies VALUES (2,'Jumanji',1995,'Adventure|Children|Fantasy');
INSERT INTO movies VALUES (3,'Grumpier Old Men',1995,'Comedy|Romance');
INSERT INTO movies VALUES (4,'Waiting to Exhale',1995,'Comedy|Drama|Romance');
INSERT INTO movies VALUES (5,'Father of the Bride Part II',1995,'Comedy');
INSERT INTO movies VALUES (6,'Heat',1995,'Action|Crime|Thriller');
INSERT INTO movies VALUES (7,'Sabrina',1995,'Comedy|Romance');
INSERT INTO movies VALUES (8,'Tom and Huck',1995,'Adventure|Children');
INSERT INTO movies VALUES (9,'Sudden Death',1995,'Action');
INSERT INTO movies VALUES (10,'GoldenEye',1995,'Action|Adventure|Thriller');

-- Вставка данных в ratings
INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES (1,1,4.0,964982703);
INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES (1,3,4.0,964981247);
INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES (2,6,4.0,964982224);
INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES (2,8,4.0,964982224);
INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES (3,10,4.5,964982224);

-- Вставка данных в tags
INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES (2,60756,'funny',1445714994);
INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES (2,60756,'Highly quotable',1445714996);
INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES (3,1,'animation',1445714997);

-- Вставка данных в users
INSERT INTO users VALUES (1,'Devonte Stamm','marianne.krajcik@bartoletti.com','male','2010-09-19','technician');
INSERT INTO users VALUES (2,'Merritt Grimes','rempel.yvette@kertzmann.com','male','2018-06-12','other');
INSERT INTO users VALUES (3,'Dianna Herzog','jarrell.stokes@gmail.com','female','2013-11-19','writer');
INSERT INTO users VALUES (4,'Alice Johnson','alice.johnson@example.com','female','2015-03-22','engineer');
INSERT INTO users VALUES (5,'Adam Smith','adam.smith@example.com','male','2012-07-14','student');
INSERT INTO users VALUES (6,'Amanda Brown','amanda.brown@example.com','female','2019-01-05','designer');
INSERT INTO users VALUES (7,'Robert Anderson','robert.anderson@example.com','male','2016-08-30','manager');

COMMIT;
