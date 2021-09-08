PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
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
    FOREIGN KEY (users_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    users_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
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
    ((SELECT id FROM questions WHERE author_id = 1), (SELECT author_id FROM questions WHERE id = 1)),
    ((SELECT id FROM questions WHERE author_id = 2), (SELECT author_id FROM questions WHERE id = 2)),
    ((SELECT id FROM questions WHERE author_id = 3), (SELECT author_id FROM questions WHERE id = 3));

INSERT INTO 
    replies(question_id, author_id, parent_id, body)
VALUES  
    ((SELECT question_id FROM question_follows WHERE question_id = 1),
    (SELECT users_id FROM question_follows WHERE users_id = 1),
    (SELECT parent_id FROM replies WHERE parent_id = 1), ('This is reply 1')),
    
    ((SELECT question_id FROM question_follows WHERE question_id = 2),
    (SELECT users_id FROM question_follows WHERE users_id = 2),
    (SELECT parent_id FROM replies WHERE parent_id = 2), ('This is reply 2')),
    
    ((SELECT question_id FROM question_follows WHERE question_id = 3),
    (SELECT users_id FROM question_follows WHERE users_id = 3),
    (SELECT parent_id FROM replies WHERE parent_id = 3), ('This is reply 3'));

INSERT INTO
    question_likes(question_id, users_id)
VALUES  
    ((SELECT question_id FROM question_follows WHERE question_id = 1), 
    (SELECT users_id FROM question_follows WHERE users_id = 1)),

    ((SELECT question_id FROM question_follows WHERE question_id = 2), 
    (SELECT users_id FROM question_follows WHERE users_id = 2)),

    ((SELECT question_id FROM question_follows WHERE question_id = 3), 
    (SELECT users_id FROM question_follows WHERE users_id = 3));

        