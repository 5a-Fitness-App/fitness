CREATE DATABASE test1;
\c test1;

-- Users Table
CREATE TABLE users (
    user_ID SERIAL PRIMARY KEY,
    user_name VARCHAR(25) NOT NULL,
    user_dob DATE NOT NULL,
    user_weight INT NOT NULL CHECK (user_weight > 0),
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_phone_number BIGINT NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL
);

-- Friends Table
CREATE TABLE friends (
    user_ID INT,
    friend_ID INT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'blocked')), 
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_ID, friend_ID), 
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (friend_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    CHECK (user_ID <> friend_ID)  -- Prevent self-friendship
);

-- Workouts Table
CREATE TABLE workouts (
    workout_ID SERIAL PRIMARY KEY,
    workout_title VARCHAR(25) NOT NULL,
    workout_date_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    workout_duration INT NOT NULL CHECK (workout_duration > 0),
    workout_calories_burnt INT NOT NULL CHECK (workout_calories_burnt >= 0)
);

-- Create Enum Type for Activity
CREATE TYPE activity_enum AS ENUM ('cardio', 'strength', 'swim', 'yoga', 'meditation');

-- Activities Table
CREATE TABLE activities (
    activity_ID SERIAL PRIMARY KEY,
    activity_name VARCHAR(25) NOT NULL,
    activity_type activity_enum NOT NULL,
    activity_distance INT NOT NULL CHECK (activity_distance >= 0),
    activity_elevation INT NOT NULL CHECK (activity_elevation >= 0)
);

-- Achievements Table
CREATE TABLE achievements (
    achievements_ID SERIAL PRIMARY KEY,
    user_ID INT,
    achievement_name VARCHAR(255) NOT NULL, 
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE
);

-- Comments Table
CREATE TABLE comments (
    comment_ID SERIAL PRIMARY KEY,
    user_ID INT, 
    workout_ID INT,
    content TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);

-- Likes Table
CREATE TABLE likes (
    likes_ID SERIAL PRIMARY KEY,
    user_ID INT,
    activity_ID INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (activity_ID) REFERENCES activities(activity_ID) ON DELETE CASCADE,
    CONSTRAINT unique_like UNIQUE (user_ID, activity_ID)
);

-- Users-Achievements Table (Junction Table)
CREATE TABLE users_achievements (
    user_ID INT,
    achievements_ID INT, 
    PRIMARY KEY (user_ID, achievements_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (achievements_ID) REFERENCES achievements(achievements_ID) ON DELETE CASCADE
);

-- Users-Workouts Table (Junction Table)
CREATE TABLE users_workout (
    user_ID INT,
    workout_ID INT,
    PRIMARY KEY (user_ID, workout_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE
);

-- Workout-Likes Table
CREATE TABLE workout_likes (
    likes_ID INT,
    workout_ID INT,
    FOREIGN KEY (likes_ID) REFERENCES likes(likes_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE  
);

-- Workout-Comments Table
CREATE TABLE workout_comments (
    user_ID INT,
    workout_ID INT,
    comment_ID INT,
    PRIMARY KEY (user_ID, workout_ID, comment_ID),
    FOREIGN KEY (user_ID) REFERENCES users(user_ID) ON DELETE CASCADE,
    FOREIGN KEY (workout_ID) REFERENCES workouts(workout_ID) ON DELETE CASCADE,
    FOREIGN KEY (comment_ID) REFERENCES comments(comment_ID) ON DELETE CASCADE
);

-- Insert Data
INSERT INTO users (user_name, user_dob, user_weight, user_email, user_phone_number, user_password) VALUES
('John Doe', '1990-05-20', 75, 'john@example.com', 1234567890, 'hashed_password1'),
('Jane Smith', '1992-08-15', 65, 'jane@example.com', 9876543210, 'hashed_password2');

INSERT INTO friends (user_ID, friend_ID, status) VALUES 
(1, 2, 'accepted');

INSERT INTO workouts (workout_title, workout_date_time, workout_duration, workout_calories_burnt) VALUES 
('Morning Run', '2025-02-15 07:30:00', 45, 350),
('Evening Yoga', '2025-02-16 18:00:00', 60, 200);

INSERT INTO activities (activity_name, activity_type, activity_distance, activity_elevation) VALUES 
('5K Run', 'cardio', 5000, 50), 
('Bench Press', 'strength', 0, 0);

INSERT INTO achievements (user_ID, achievement_name) VALUES 
(1, 'Completed 10 Workouts'), 
(2, 'Ran 10KM in One Go');

INSERT INTO comments (user_ID, workout_ID, content) VALUES 
(1, 1, 'Great morning run! Felt amazing!'), 
(2, 2, 'Yoga was super relaxing today.');

INSERT INTO likes (user_ID, activity_ID) VALUES 
(1, 1), 
(2, 2);

INSERT INTO users_achievements (user_ID, achievements_ID) VALUES 
(1, 1), 
(2, 2);

INSERT INTO users_workout (user_ID, workout_ID) VALUES 
(1, 1), 
(2, 2);

INSERT INTO workout_likes (likes_ID, workout_ID) VALUES 
(1, 1), 
(2, 2);

INSERT INTO workout_comments (user_ID, workout_ID, comment_ID) VALUES 
(1, 1, 1), 
(2, 2, 2);