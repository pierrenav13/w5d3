PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

--joins users to questions and vice versa
CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    users_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (users_id) REFERENCES questions(author_id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    subject_id INTEGER NOT NULL,
    parent_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (subject_id) REFERENCES question_follows(question_id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES questions_follows(users_id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    likes INTEGER,
    question_id INTEGER NOT NULL,
    users_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES question_follows(question_id),
    FOREIGN KEY (users_id) REFERENCES question_follows(users_id),
);

INSERT INTO
    users(fname, lname)
VALUES
    ('Bob', 'Smith'),
    ('John', 'Doe'),
    ('Sam', 'Smith');

INSERT INTO
    questions(title, body, author_id)
VALUES 
    ('Title1', 'This is Title1', (SELECT id FROM users WHERE fname = 'Bob' AND lname = 'Smith')),
    ('Title2', 'This is Title2', (SELECT id FROM users WHERE fname = 'John' AND lname = 'Doe')),
    ('Title3', 'This is Title3', (SELECT id FROM users WHERE fname = 'Sam' AND lname = 'Smith'));

INSERT INTO 
    question_follows(question_id, users_id)
VALUES
    (SELECT id, author_id FROM questions WHERE question_id = 1 AND author_id = 1),
    (SELECT id, author_id FROM questions WHERE question_id = 2 AND author_id = 2),
    (SELECT id, author_id FROM questions WHERE question_id = 3 AND author_id = 3);

INSERT INTO 
    replies(subject_id, parent_id, author_id, body)
VALUES  
    (S),