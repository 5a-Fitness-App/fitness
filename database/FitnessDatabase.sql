-- Create and connect to database
CREATE DATABASE fitnessdatabase;
\c fitnessdatabase;

-- ENUM types
CREATE TYPE user_profile_photo_enum AS ENUM ('fish', 'shark', 'crab', 'dolphin');
CREATE TYPE units_enum AS ENUM ('kg', 'lb');
CREATE TYPE activity_enum AS ENUM ('cardio', 'strength', 'swim', 'yoga', 'meditation');
CREATE TYPE exercise_type_enum AS ENUM ('legs', 'glutes', 'chest', 'back', 'shoulders', 'biceps', 'triceps', 'core', 'cardio');
CREATE TYPE distance_metric_enum AS ENUM ('Miles', 'km');

-- USERS table
CREATE TABLE users (
    user_ID SERIAL PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_profile_photo user_profile_photo_enum NOT NULL,
    user_bio TEXT,
    user_dob DATE NOT NULL,
    user_weight INT NOT NULL CHECK (user_weight > 0),
    user_units units_enum NOT NULL,
    users_account_creation_date DATE NOT NULL,
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL
);

-- FRIENDS table
CREATE TABLE friends (
    user_ID INT,
    friend_ID INT,
    friend_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, friend_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (friend_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (user_ID <> friend_ID)
);

-- FRIEND REQUESTS table
CREATE TABLE friend_requests (
    sender_ID INT,
    receiver_ID INT,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sender_ID, receiver_ID),
    FOREIGN KEY (sender_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (receiver_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (sender_ID <> receiver_ID)
);

-- WORKOUTS table
CREATE TABLE workouts (
    workout_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_title VARCHAR(25) NOT NULL,
    workout_date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    workout_public BOOL NOT NULL,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

-- EXERCISES table
CREATE TABLE exercises (
    exercise_ID SERIAL PRIMARY KEY,
    exercise_type exercise_type_enum NOT NULL,
    exercise_name VARCHAR(25) NOT NULL
);

-- ACTIVITIES table
CREATE TABLE activities (
    activity_ID SERIAL PRIMARY KEY,
    workout_ID INT NOT NULL,
    exercise_ID INT NOT NULL,
    activity_name VARCHAR(25) NOT NULL,
    activity_type activity_enum NOT NULL,
    activity_notes TEXT,
    activity_reps INT CHECK (activity_reps >= 0),
    activity_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activity_weight_metric units_enum,
    activity_incline INT,
    activity_distance_metric distance_metric_enum,
    activity_distance INT CHECK (activity_distance >= 0),
    activity_elevation INT CHECK (activity_elevation >= 0),
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (exercise_ID) REFERENCES exercises(exercise_ID) ON DELETE CASCADE
);

-- ACHIEVEMENTS table
CREATE TABLE achievements (
    achievements_ID SERIAL PRIMARY KEY,
    user_ID INT,
    achievement_name VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

-- COMMENTS table
CREATE TABLE comments (
    comment_ID SERIAL PRIMARY KEY,
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL,
    content TEXT NOT NULL,
    date_commented TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);

-- LIKES table
CREATE TABLE likes (
    user_ID INT NOT NULL,
    workout_ID INT NOT NULL,
    date_liked TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, workout_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);

-- USERS_ACHIEVEMENTS table
CREATE TABLE users_achievements (
    user_ID INT NOT NULL,
    achievements_ID INT NOT NULL,
    completed BOOL NOT NULL,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, achievements_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (achievements_ID) REFERENCES achievements(achievements_ID) ON DELETE CASCADE
);

-- WORKOUT_COMMENTS table
CREATE TABLE workout_comments (
    workout_ID INT,
    comment_ID INT,
    PRIMARY KEY (workout_ID, comment_ID),
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (comment_ID) REFERENCES comments(comment_ID) ON DELETE CASCADE
);

-- === INSERT EXERCISES ===
-- USERS
INSERT INTO users (user_name, user_profile_photo, user_bio, user_dob, user_weight, user_units, users_account_creation_date, user_email, user_password) VALUES
('Alice', 'fish', 'Loves swimming and strength training.', '1990-05-12', 65, 'kg', '2024-01-10', 'alice@example.com', 'password'),
('Bob', 'shark', 'Runner and yoga enthusiast.', '1985-09-30', 75, 'kg', '2024-02-15', 'bob@example.com', 'pass2'),
('Charlie', 'crab', 'Cardio king.', '1992-12-20', 80, 'lb', '2024-03-01', 'charlie@example.com', 'pass3'),
('Diana', 'dolphin', 'Weightlifter and foodie.', '1995-07-18', 70, 'kg', '2024-03-20', 'diana@example.com', 'pass4'),
('Eli', 'fish', 'Meditation and core master.', '1998-04-22', 60, 'kg', '2024-04-01', 'eli@example.com', 'pass5');

-- FRIENDS
INSERT INTO friends (user_ID, friend_ID) VALUES
(1, 2), (2, 1),
(1, 3), (3, 1),
(2, 4), (4, 2),
(3, 5), (5, 3);

-- EXERCISES (static set to use in activities)
INSERT INTO exercises (exercise_type, exercise_name) VALUES
('legs', 'Squats'),
('glutes', 'Hip Thrusts'),
('chest', 'Bench Press'),
('back', 'Deadlift'),
('shoulders', 'Overhead Press'),
('biceps', 'Bicep Curls'),
('triceps', 'Tricep Dips'),
('core', 'Plank'),
('cardio', 'Running');

-- WORKOUTS (5 per user, so 25 total)
-- Format: (user_ID, workout_title, workout_date_time, workout_public)
INSERT INTO workouts (user_ID, workout_title, workout_date_time, workout_public) VALUES
-- Alice
(1, 'Legs Day', '2025-04-01 09:00:00', true),
(1, 'Core + Cardio', '2025-04-02 10:00:00', false),
(1, 'Strength Push', '2025-04-03 11:00:00', true),
(1, 'Recovery Flow', '2025-04-04 12:00:00', false),
(1, 'Upper Body', '2025-04-05 13:00:00', true),

-- Bob
(2, 'Morning Run', '2025-04-01 07:00:00', true),
(2, 'Chest and Back', '2025-04-02 08:00:00', false),
(2, 'Leg Pump', '2025-04-03 09:00:00', true),
(2, 'Core Engage', '2025-04-04 10:00:00', false),
(2, 'Stretch Out', '2025-04-05 11:00:00', true),

-- Charlie
(3, 'Cardio Burn', '2025-04-01 17:00:00', true),
(3, 'Fast Core', '2025-04-02 17:30:00', true),
(3, 'Spin & Sprint', '2025-04-03 18:00:00', true),
(3, 'Stair Climb', '2025-04-04 18:30:00', true),
(3, 'Quick Run', '2025-04-05 19:00:00', true),

-- Diana
(4, 'Glute Blast', '2025-04-01 14:00:00', true),
(4, 'Upper Strength', '2025-04-02 15:00:00', true),
(4, 'Push Day', '2025-04-03 16:00:00', false),
(4, 'Deadlifts + Core', '2025-04-04 17:00:00', false),
(4, 'Mobility & Balance', '2025-04-05 18:00:00', true),

-- Eli
(5, 'Stretch + Core', '2025-04-01 10:00:00', true),
(5, 'Run & Reflect', '2025-04-02 11:00:00', true),
(5, 'Core Power', '2025-04-03 12:00:00', true),
(5, 'Shoulder Focus', '2025-04-04 13:00:00', false),
(5, 'Evening Calm', '2025-04-05 14:00:00', true);


-- Alice (workouts 1–5)
INSERT INTO activities VALUES
(DEFAULT, 1, 1, 'Squats', 'strength', 'Heavy sets', 10, '2025-04-01 09:10:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 1, 8, 'Plank', 'strength', 'Hold for 60s', 1, '2025-04-01 09:20:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 2, 9, 'Running', 'cardio', 'Outdoor jog', 1, '2025-04-02 10:10:00', 'kg', 0, 'km', 3, 50),
(DEFAULT, 2, 8, 'Plank', 'strength', 'Side plank', 1, '2025-04-02 10:20:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 3, 3, 'Bench Press', 'strength', '3x10', 10, '2025-04-03 11:10:00', 'kg', 0, 'km', 0, 0),

-- Bob (workouts 6–10)
(DEFAULT, 6, 9, 'Running', 'cardio', 'Morning tempo', 1, '2025-04-01 07:10:00', 'kg', 0, 'km', 5, 60),
(DEFAULT, 7, 3, 'Bench Press', 'strength', 'Flat press', 8, '2025-04-02 08:10:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 7, 4, 'Deadlift', 'strength', 'Focus on form', 6, '2025-04-02 08:20:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 8, 1, 'Squats', 'strength', 'High volume', 12, '2025-04-03 09:10:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 9, 8, 'Plank', 'strength', 'Variation holds', 2, '2025-04-04 10:10:00', 'kg', 0, 'km', 0, 0),

-- Charlie (workouts 11–15)
(DEFAULT, 11, 9, 'Running', 'cardio', 'Sprint intervals', 1, '2025-04-01 17:10:00', 'kg', 0, 'km', 4, 80),
(DEFAULT, 12, 8, 'Plank', 'strength', 'Plank to pushup', 3, '2025-04-02 17:40:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 13, 9, 'Running', 'cardio', 'Hill sprints', 1, '2025-04-03 18:10:00', 'kg', 2, 'km', 3, 100),

-- Diana (workouts 16–20)
(DEFAULT, 16, 2, 'Hip Thrusts', 'strength', 'Glute bridges', 15, '2025-04-01 14:10:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 17, 5, 'Overhead Press', 'strength', 'Standing press', 8, '2025-04-02 15:10:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 18, 7, 'Tricep Dips', 'strength', 'Bodyweight dips', 10, '2025-04-03 16:10:00', 'kg', 0, 'km', 0, 0),

-- Eli (workouts 21–25)
(DEFAULT, 21, 8, 'Plank', 'strength', '4 rounds of 45s', 4, '2025-04-01 10:10:00', 'kg', 0, 'km', 0, 0),
(DEFAULT, 22, 9, 'Running', 'cardio', 'Jog and cool down', 1, '2025-04-02 11:10:00', 'kg', 0, 'km', 2, 40),
(DEFAULT, 23, 8, 'Plank', 'strength', 'Side plank sets', 2, '2025-04-03 12:10:00', 'kg', 0, 'km', 0, 0);
