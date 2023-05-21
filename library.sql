SET TIME ZONE 'Europe/Moscow';



-- Таблица "Читатели"

CREATE TABLE readers (
  reader_id serial PRIMARY KEY NOT NULL,
  name varchar(100),
  phonenumber varchar(11),
  email varchar(100),
  dateofbirth date,
  login varchar(20) NOT NULL,
  password varchar(20) NOT NULL
);

INSERT INTO readers (name, phonenumber, email, dateofbirth, login, password) VALUES
('ADMIN', NULL, NULL, NULL, 'admin', '1234'),
('Новокшонов Никита Григорьевич', '89674619881', 'nikita62@ya.ru', '2001-04-27', 'nikita62', 'nikita62'),
('Лесничий Георгий Прохорович', '89727765195', 'georgiyles@mail.ru', '2003-12-26', 'georg', 'les977'),
('Ряхина Валентина Алексеевна', '89749166942', 'val.ryakhina@mail.ru', '2001-08-05', 'valr', 'ryakhina01'),
('Вершинин Даниил Тимофеевич', '89475763888', 'daniilv2000@mail.ru', '2000-11-27', 'daniil', 'versh1dan'),
('Беспалова Мила Никифоровна', '89318547360', 'bespalova@ya.ru', '2002-01-20', 'milabespalova', '120mila'),
('Крутикова Варвара Николаевна', '89639966456', 'varvara11k@mail.ru', '2003-11-06', 'krtvar', 'vrvr22'),
('Марин Иван Николаевич', '89128037499', 'marinivan@ya.ru', '2004-07-07', 'ivanm', 'ivan2004');





-- Таблица "Авторы"

CREATE TABLE authors (
  author_id serial PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL
);

INSERT INTO authors (name) VALUES
('Александр Сергеевич Пушкин'),
('Иван Сергеевич Тургенев'),
('Альберт Эйнштейн'),
('Лев Николаевич Толстой'),
('Федор Михайлович Достоевский'),
('Владимир Иванович Даль'),
('Антон Павлович Чехов'),
('Жюль Верн');





-- Таблица "Виды"

CREATE TABLE types (
  type_id serial PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL
);

INSERT INTO types (name) VALUES
('Художественная литература'),
('Научная литература'),
('Справочная литература'),
('Техническая литература'),
('Документальная литература');





-- Таблица "Издательства"

CREATE TABLE publishers (
  publisher_id serial PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL,
  city varchar(100) NOT NULL,
  adress varchar(100) NOT NULL
);

INSERT INTO publishers (name, city, adress) VALUES
('ОНИКС', 'Москва', 'ул. Новочеремушкинская, 54, 117418'),
('Азбука', 'Санкт-Петербург', 'ул. Решетникова, 15, 196105'),
('Омега-Л', 'Москва', 'ш. Энтузиастов, 56, 111123'),
('Просвещение', 'Москва', '3-й пр. Марьиной Рощи, 41, 127521'),
('Эксмо', 'Москва', 'ул. Зорге, 1, 123308');





-- Таблица "Книги"

CREATE TABLE books (
  book_id serial PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL,
  releaseyear integer NOT NULL,
  pages integer NOT NULL,
  author_id integer NOT NULL,
  type_id integer NOT NULL,
  publisher_id integer NOT NULL,
  amount integer NOT NULL,
  CONSTRAINT books_authors_fk FOREIGN KEY(author_id) REFERENCES authors(author_id),
  CONSTRAINT books_types_fk FOREIGN KEY(type_id) REFERENCES types(type_id),
  CONSTRAINT books_publishers_fk FOREIGN KEY(publisher_id) REFERENCES publishers(publisher_id)
);

INSERT INTO books (name, releaseyear, pages, author_id, type_id, publisher_id, amount) VALUES
('Идиот', 1976, 267, 5, 1, 2, 10),
('Толковый словарь русского языка', 2010, 401, 6, 3, 4, 9),
('Таинственный остров', 1985, 324, 8, 1, 1, 2),
('Преступление и наказание', 1994, 378, 5, 1, 5, 7),
('Теория относительности', 1978, 198, 3, 2, 4, 1),
('Анна Каренина', 1996, 560, 4, 1, 3, 7),
('Отцы и дети', 2013, 457, 2, 1, 5, 9),
('Руслан и Людмила', 1965, 180, 1, 1, 4, 5);





-- Таблица "Выдачи"

CREATE TABLE borrows (
  borrow_id serial PRIMARY KEY NOT NULL,
  borrowdate date NOT NULL,
  returndate date NOT NULL,
  book_id integer NOT NULL,
  reader_id integer NOT NULL,
  borrowstatus boolean,
  CONSTRAINT borrows_books_fk FOREIGN KEY(book_id) REFERENCES books(book_id),
  CONSTRAINT borrows_readers_fk FOREIGN KEY(reader_id) REFERENCES readers(reader_id)
);

INSERT INTO borrows (borrowdate, returndate, book_id, reader_id, borrowstatus) VALUES
('2022-12-05', '2022-12-19', 4, 3, false),
('2022-12-07', '2022-12-21', 2, 2, false),
('2022-12-09', '2022-12-30', 3, 4, true),
('2022-12-26', '2023-01-09', 1, 5, true);





-- Триггер на каскадное удаление данных (при удалении читателя)

CREATE OR REPLACE FUNCTION public.delete_reader_function()
  RETURNS trigger AS
$BODY$
BEGIN
DELETE FROM borrows WHERE reader_id = OLD.reader_id;
RETURN OLD;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.delete_reader_function()
  OWNER TO postgres;

CREATE TRIGGER delete_reader
BEFORE DELETE ON readers
FOR EACH ROW
EXECUTE PROCEDURE delete_reader_function();





-- Триггер на каскадное удаление данных (при удалении книги)

CREATE OR REPLACE FUNCTION public.delete_book_function()
  RETURNS trigger AS
$BODY$
BEGIN
DELETE FROM borrows WHERE book_id = OLD.book_id;
RETURN OLD;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.delete_book_function()
  OWNER TO postgres;

CREATE TRIGGER delete_book
BEFORE DELETE ON books
FOR EACH ROW
EXECUTE PROCEDURE delete_book_function();





--Триггеры на проверку данных

CREATE OR REPLACE FUNCTION public.check_data_readers1()
  RETURNS trigger AS
$BODY$
BEGIN
IF (NEW.login IS NULL) OR (length(NEW.login) > 20) THEN
RAISE EXCEPTION 'Incorrect login';
END IF;
IF (NEW.password IS NULL) OR (length(NEW.password) > 20) THEN
RAISE EXCEPTION 'Incorrect password';
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.check_data_readers1()
  OWNER TO postgres;

CREATE TRIGGER check_data_reader1
BEFORE INSERT ON readers
FOR EACH ROW
EXECUTE PROCEDURE public.check_data_readers1();



CREATE OR REPLACE FUNCTION public.check_data_readers2()
  RETURNS trigger AS
$BODY$
BEGIN
IF length(NEW.name) > 100 THEN
RAISE EXCEPTION 'Name cannot be longer than 100 symbols ';
END IF;
IF length(NEW.phonenumber) <> 11  THEN
RAISE EXCEPTION 'Phone number must be 11 characters long';
END IF;
IF length(NEW.email) > 100 OR (NEW.email NOT LIKE '_%@_%._%') THEN
RAISE EXCEPTION 'Incorrect email                        ';
END IF;
IF NEW.dateofbirth > current_date THEN
RAISE EXCEPTION 'Incorrect birth date                   ';
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.check_data_readers2()
  OWNER TO postgres;

CREATE TRIGGER check_data_reader2
BEFORE UPDATE ON readers
FOR EACH ROW
EXECUTE PROCEDURE public.check_data_readers2();



CREATE OR REPLACE FUNCTION public.check_data_publishers()
  RETURNS trigger AS
$BODY$
BEGIN
IF (NEW.name IS NULL) THEN
RAISE EXCEPTION 'Name is null';
END IF;
IF (NEW.city IS NULL) THEN
RAISE EXCEPTION 'City is null';
END IF;
IF (NEW.adress IS NULL) THEN
RAISE EXCEPTION 'Adress is null';
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.check_data_publishers()
  OWNER TO postgres;

CREATE TRIGGER check_data_publisher
BEFORE INSERT ON publishers
FOR EACH ROW
EXECUTE PROCEDURE public.check_data_publishers();



CREATE OR REPLACE FUNCTION public.check_data_books()
  RETURNS trigger AS
$BODY$
BEGIN
IF (NEW.name IS NULL) THEN
RAISE EXCEPTION 'Book name is null        ';
END IF;
IF (NEW.releaseyear IS NULL) OR (NEW.releaseyear < 0) THEN
RAISE EXCEPTION 'Incorrect release year   ';
END IF;
IF (NEW.pages IS NULL) OR (NEW.pages < 0) THEN
RAISE EXCEPTION 'Incorrect number of pages';
END IF;
IF (NEW.amount IS NULL) OR (NEW.amount < 0) THEN
RAISE EXCEPTION 'Incorrect amount of books';
END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.check_data_books()
  OWNER TO postgres;

CREATE TRIGGER check_data_book
BEFORE INSERT ON books
FOR EACH ROW
EXECUTE PROCEDURE public.check_data_books();





--Применение VIEW

CREATE VIEW books_data AS
SELECT books.book_id, books.name, books.releaseyear, books.pages, authors.author_id, types.type_id, publishers.publisher_id, publishers.city
FROM books
JOIN authors ON authors.author_id = books.author_id
JOIN types ON types.type_id = books.type_id
JOIN publishers ON publishers.publisher_id = books.publisher_id;





--Хранимые процедуры

CREATE OR REPLACE FUNCTION add_author(
p_authorname varchar(100)
)
RETURNS void AS $$
BEGIN
INSERT INTO authors (name)
VALUES (p_authorname);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_authors(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT author_id, name FROM authors;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_types(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT type_id, name FROM types;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_publishers(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT publisher_id, name FROM publishers;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION add_book(
p_bookname varchar(100),
p_releaseyear integer,
p_pages integer,
p_author_id integer,
p_type_id integer,
p_publisher_id integer,
p_amount integer
)
RETURNS void AS $$
BEGIN
INSERT INTO books (name, releaseyear, pages, author_id, type_id, publisher_id, amount)
VALUES (p_bookname, p_releaseyear, p_pages, p_author_id, p_type_id, p_publisher_id, p_amount);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_reader(
p_readername varchar(100),
p_phonenumber varchar(11),
p_email varchar(100),
p_dateofbirth date,
p_login varchar(20)
)
RETURNS void AS $$
BEGIN
UPDATE readers SET name = p_readername, phonenumber = p_phonenumber, email = p_email, dateofbirth = p_dateofbirth WHERE login = p_login;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_reader(
  p_login varchar(20)
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT reader_id FROM readers WHERE login = p_login;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_activeborrows(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT b.name, r.name, bo.borrowdate, bo.returndate
        FROM books AS b, borrows AS bo, readers AS r
        WHERE b.book_id = bo.book_id AND r.reader_id = bo.reader_id AND bo.borrowstatus = true;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_allborrows(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT b.name, r.name, bo.borrowdate, bo.returndate, borrowstatus
        FROM books AS b, borrows AS bo, readers AS r
        WHERE b.book_id = bo.book_id AND r.reader_id = bo.reader_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_readers(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT reader_id, login, name, phonenumber, email, dateofbirth FROM readers WHERE login <> 'admin' ORDER BY 1;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_readerborrows(
  p_id integer
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT b.book_id, CONCAT(b.name, ' - ', a.name) AS full
		FROM books AS b, borrows AS bo, authors AS a 
		WHERE b.book_id = bo.book_id 
		AND b.author_id = a.author_id 
		AND bo.reader_id = p_id
		AND bo.borrowstatus = true;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_borrowfalse(
p_idr integer,
p_idb integer
)
RETURNS void AS $$
BEGIN
UPDATE borrows SET borrowstatus = false WHERE book_id = p_idb AND reader_id = p_idr;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_bookamountplus(
p_idb integer
)
RETURNS void AS $$
BEGIN
UPDATE books SET amount = amount + 1 WHERE book_id = p_idb;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_books(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT b.book_id, b.name, b.releaseyear, t.name, a.name, b.pages, p.name, b.amount
        FROM books AS b JOIN types AS t ON b.type_id = t.type_id
        JOIN authors AS a ON b.author_id = a.author_id
        JOIN publishers AS p ON b.publisher_id = p.publisher_id
        ORDER BY 1;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_availablebooks(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT book_id, CONCAT(b.name, ' - ', a.name) AS full FROM books AS b, authors AS a WHERE a.author_id = b.author_id AND amount > 0;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION add_borrow(
p_idb integer,
p_idr integer
)
RETURNS void AS $$
BEGIN
INSERT INTO borrows (borrowdate, returndate, book_id, reader_id, borrowstatus)
VALUES (CURRENT_DATE, CURRENT_DATE + integer '14', p_idb, p_idr, true);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_returndate(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT EXTRACT(day FROM CURRENT_DATE + integer '14'), TO_CHAR(CURRENT_DATE + integer '14', 'Month'), EXTRACT(YEAR FROM CURRENT_DATE + integer '14');
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_bookamountminus(
p_idb integer
)
RETURNS void AS $$
BEGIN
UPDATE books SET amount = amount - 1 WHERE book_id = p_idb;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION update_returndate(
p_idb integer,
p_idr integer
)
RETURNS void AS $$
BEGIN
UPDATE borrows SET returndate = returndate + integer '7' WHERE reader_id = p_idr AND book_id = p_idb;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_newreturndate(
p_idb integer,
p_idr integer
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT EXTRACT(DAY FROM returndate), TO_CHAR(returndate, 'Month'), EXTRACT(YEAR FROM returndate) FROM borrows WHERE reader_id = p_idr AND book_id = p_idb;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION delete_book(
p_idb integer
)
RETURNS void AS $$
BEGIN
DELETE FROM books WHERE book_id = p_idb;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION check_reader(
  p_login varchar(20)
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT * FROM readers WHERE login = p_login AND name IS NULL;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION check_pass(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT login, password FROM readers;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION see_allpublishers(
)
RETURNS SETOF RECORD AS $$
BEGIN
RETURN QUERY SELECT * FROM publishers;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION add_pass(
p_login varchar(20),
p_password varchar(20)
)
RETURNS void AS $$
BEGIN
INSERT INTO readers (login,password) VALUES (p_login, p_password);
END;
$$ LANGUAGE plpgsql;





--Роли и политики доступа

CREATE ROLE admin1 LOGIN PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE Library TO admin1;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin1;

CREATE ROLE user1 LOGIN PASSWORD 'user123';
GRANT CONNECT ON DATABASE Library TO user1;
GRANT SELECT ON borrows, authors, types, publishers, books TO user1;
GRANT INSERT ON borrows, readers TO user1;

CREATE ROLE guest1 LOGIN PASSWORD 'guest123';
GRANT CONNECT ON DATABASE Library TO guest1;
GRANT SELECT ON books, publishers, types, authors TO guest1;

ALTER TABLE borrows ENABLE ROW LEVEL SECURITY;
CREATE POLICY borrows_policy ON borrows FOR SELECT USING (login = current_user);





--Наследование таблиц

CREATE TABLE students (
  schoolnumber varchar(4),
  grade varchar(2)
) INHERITS(readers);





--Секционирование таблиц

CREATE TABLE logs (
    logdate date NOT NULL,
    reader_id serial NOT NULL,
    borrow_id serial NOT NULL,
    logdata text
);