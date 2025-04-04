CREATE DATABASE test2;
\c test2;

CREATE TYPE user_profile_photo_enum AS ENUM
('fish', 'shark', 'crab', 'dolphin');
CREATE TYPE activity_enum AS ENUM
('cardio', 'strength', 'swim', 'yoga', 'meditation');


CREATE TABLE users
(
    user_ID SERIAL PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_dob DATE NOT NULL,
    user_weight INT NOT NULL CHECK (user_weight > 0),
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL
);


CREATE TABLE friends
(
    user_ID INT,
    friend_ID INT,
    friend_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, friend_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (friend_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (user_ID <> friend_ID)
);


CREATE TABLE friend_requests
(
    sender_ID INT,
    receiver_ID INT,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sender_ID, receiver_ID),
    FOREIGN KEY (sender_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (receiver_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (sender_ID <> receiver_ID)
);


CREATE TABLE workouts
(
    workout_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_title VARCHAR(25) NOT NULL,
    workout_date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    workout_duration INT NOT NULL CHECK (workout_duration > 0),
    workout_calories_burnt INT NOT NULL CHECK (workout_calories_burnt >= 0),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

CREATE TABLE exercises
(
    exercise_ID SERIAL PRIMARY KEY,
    exercise_type VARCHAR(25) NOT NULL,
    exercise_name VARCHAR(25) NOT NULL
);


CREATE TABLE activities
(
    activity_ID SERIAL PRIMARY KEY,
    workout_ID INT NOT NULL,
    exercise_ID INT NOT NULL,
    activity_name VARCHAR(25) NOT NULL,
    activity_type activity_enum NOT NULL,
    activity_distance INT NOT NULL CHECK (activity_distance >= 0),
    activity_elevation INT NOT NULL CHECK (activity_elevation >= 0),
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (exercise_ID) REFERENCES exercises(exercise_ID) ON DELETE CASCADE
);


CREATE TABLE achievements
(
    achievements_ID SERIAL PRIMARY KEY,
    user_ID INT,
    achievement_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);


CREATE TABLE comments
(
    comment_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL,
    content TEXT NOT NULL,
    date_commented TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);


CREATE TABLE likes
(
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL,
    date_liked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    CONSTRAINT unique_like UNIQUE (user_ID, workout_ID)
);


CREATE TABLE users_achievements
(
    user_ID INT NOT NULL,
    achievements_ID INT NOT NULL,
    completed BOOL NOT NULL,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, achievements_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (achievements_ID) REFERENCES achievements(achievements_ID) ON DELETE CASCADE
);


CREATE TABLE workout_comments
(
    workout_ID INT,
    comment_ID INT,
    PRIMARY KEY (workout_ID, comment_ID),
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (comment_ID) REFERENCES comments(comment_ID) ON DELETE CASCADE
);


INSERT INTO users
    (user_name, user_dob, user_weight, user_email, user_password)
VALUES
    ('JohnDoe', '1995-06-15', 75, 'john@example.com', 'password123'),
    ('JaneSmith', '1998-02-20', 62, 'jane@example.com', 'pass1234'),
    ('MikeTyson', '1986-08-19', 80, 'mike@example.com', 'knockout'),
    ('AliceWonder', '1993-11-11', 55, 'alice@example.com', 'wonderland'),
    ('BobMarley', '1975-04-03', 70, 'bob@example.com', 'rastaman');


INSERT INTO workouts
    (user_ID, workout_title, workout_date_time, workout_duration, workout_calories_burnt)
VALUES
    (1, 'Morning Run', '2025-03-20 07:00:00', 30, 250),
    (2, 'Yoga Session', '2025-03-21 08:30:00', 45, 180),
    (3, 'Weightlifting', '2025-03-22 18:00:00', 60, 400),
    (4, 'Swimming', '2025-03-23 10:00:00', 40, 300),
    (5, 'Meditation', '2025-03-24 06:00:00', 20, 50);


INSERT INTO exercises
    (exercise_type, exercise_name)
VALUES
    ('cardio', 'Running'),
    ('strength', 'Bench Press'),
    ('swim', 'Freestyle'),
    ('yoga', 'Sun Salutation'),
    ('meditation', 'Mindfulness');


INSERT INTO activities
    (workout_ID, exercise_ID, activity_name, activity_type, activity_distance, activity_elevation)
VALUES
    (1, 1, 'Run at Park', 'cardio', 5, 30),
    (2, 4, 'Morning Yoga', 'yoga', 0, 0),
    (3, 2, 'Gym Session', 'strength', 0, 0),
    (4, 3, 'Pool Swim', 'swim', 1, 0),
    (5, 5, 'Relaxation', 'meditation', 0, 0);


INSERT INTO likes
    (user_ID, workout_ID, date_liked)
VALUES
    (2, 1, CURRENT_TIMESTAMP),
    -- Jane likes John's workout
    (3, 2, CURRENT_TIMESTAMP),
    -- Mike likes Jane's workout
    (1, 3, CURRENT_TIMESTAMP),
    -- John likes Mike's workout
    (4, 4, CURRENT_TIMESTAMP),
    -- Alice likes her own workout
    (5, 5, CURRENT_TIMESTAMP);
-- Bob likes his own workout


INSERT INTO comments
    (user_ID, workout_ID, content, date_commented)
VALUES
    (2, 1, 'Nice run, John!', CURRENT_TIMESTAMP),
    (3, 2, 'Yoga sounds peaceful!', CURRENT_TIMESTAMP),
    (1, 3, 'Strong lifts, Mike!', CURRENT_TIMESTAMP),
    (4, 4, 'Love swimming too!', CURRENT_TIMESTAMP),
    (5, 5, 'Meditation is life-changing.', CURRENT_TIMESTAMP);


INSERT INTO workout_comments
    (workout_ID, comment_ID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);


INSERT INTO friends
    (user_ID, friend_ID, friend_date)
VALUES
    (1, 2, CURRENT_TIMESTAMP),
    -- John and Jane are friends
    (2, 3, CURRENT_TIMESTAMP),
    -- Jane and Mike are friends
    (3, 4, CURRENT_TIMESTAMP),
    -- Mike and Alice are friends
    (4, 5, CURRENT_TIMESTAMP),
    -- Alice and Bob are friends
    (1, 5, CURRENT_TIMESTAMP);
-- John and Bob are friends


INSERT INTO friend_requests
    (sender_ID, receiver_ID, request_date)
VALUES
    (1, 3, CURRENT_TIMESTAMP),
    -- John sends request to Mike
    (2, 5, CURRENT_TIMESTAMP),
    -- Jane sends request to Bob
    (4, 1, CURRENT_TIMESTAMP),
    -- Alice sends request to John
    (5, 3, CURRENT_TIMESTAMP); -- Bob sends request to Mike
