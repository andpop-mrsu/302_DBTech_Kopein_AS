CREATE TABLE IF NOT EXISTS masters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    surname TEXT NOT NULL,
    firstname TEXT NOT NULL,
    patronymic TEXT,
    specialization TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS work_schedule (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    master_id INTEGER NOT NULL,
    day_of_week TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS completed_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    master_id INTEGER NOT NULL,
    client_name TEXT NOT NULL,
    service_name TEXT NOT NULL,
    service_date DATE NOT NULL,
    price REAL NOT NULL,
    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE
);

INSERT INTO masters (surname, firstname, patronymic, specialization) VALUES
    ('Иванова', 'Анна', 'Сергеевна', 'Колорист'),
    ('Петрова', 'Елена', 'Ивановна', 'Парикмахер-стилист'),
    ('Сидорова', 'Ольга', 'Александровна', 'Мастер по стрижкам'),
    ('Кузнецова', 'Мария', 'Дмитриевна', 'Мастер по мужским стрижкам'),
    ('Смирнова', 'Татьяна', 'Владимировна', 'Визажист');

INSERT INTO work_schedule (master_id, day_of_week, start_time, end_time) VALUES
    (1, 'Понедельник', '10:00', '19:00'),
    (1, 'Вторник', '10:00', '19:00'),
    (1, 'Среда', '10:00', '19:00'),
    (2, 'Понедельник', '09:00', '18:00'),
    (2, 'Четверг', '09:00', '18:00'),
    (2, 'Пятница', '09:00', '18:00'),
    (3, 'Вторник', '11:00', '20:00'),
    (3, 'Среда', '11:00', '20:00'),
    (3, 'Пятница', '11:00', '20:00'),
    (4, 'Понедельник', '08:00', '17:00'),
    (4, 'Среда', '08:00', '17:00'),
    (4, 'Пятница', '08:00', '17:00'),
    (5, 'Вторник', '12:00', '21:00'),
    (5, 'Четверг', '12:00', '21:00'),
    (5, 'Суббота', '10:00', '16:00');

INSERT INTO completed_services (master_id, client_name, service_name, service_date, price) VALUES
    (1, 'Ковалева А.П.', 'Окрашивание волос', '2024-12-01', 4500.00),
    (1, 'Семенова И.В.', 'Мелирование', '2024-12-05', 5500.00),
    (2, 'Николаева Е.С.', 'Стрижка и укладка', '2024-12-02', 2500.00),
    (3, 'Орлова М.К.', 'Женская стрижка', '2024-12-03', 2000.00),
    (4, 'Волков П.А.', 'Мужская стрижка', '2024-12-04', 1500.00),
    (5, 'Захарова С.Д.', 'Вечерний макияж', '2024-12-05', 3000.00);