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
INSERT INTO users (user_name, user_dob, user_weight, user_email, user_phone_number, user_password)
VALUES 
('Alice Johnson', '1990-05-14', 68, 'alice.johnson@example.com', 1234567890, 'Password123!'),
('Brian Smith', '1985-09-22', 82, 'brian.smith@example.com', 2345678901, 'SecurePass456$'),
('Catherine Lee', '1993-12-03', 55, 'catherine.lee@example.com', 3456789012, 'CatLee789@'),
('David Thompson', '2000-03-18', 75, 'david.thompson@example.com', 4567890123, 'DThompson321#'),
('Emily Davis', '1995-07-29', 60, 'emily.davis@example.com', 5678901234, 'EmilyPass654%');

INSERT INTO friends (user_ID, friend_ID, status)
VALUES 
(1, 2, 'accepted'),
(1, 3, 'pending'),
(2, 4, 'accepted'),
(3, 5, 'accepted'),
(4, 5, 'blocked');

INSERT INTO workouts (workout_title, workout_date_time, workout_duration, workout_calories_burnt)
VALUES 
('Morning Run', '2024-02-15 06:30:00', 45, 400),
('Evening Yoga', '2024-02-16 18:00:00', 60, 200),
('HIIT Session', '2024-02-17 07:00:00', 30, 500),
('Swimming Laps', '2024-02-18 09:00:00', 50, 350),
('Strength Training', '2024-02-19 17:00:00', 40, 450);

INSERT INTO activities (activity_name, activity_type, activity_distance, activity_elevation)
VALUES 
('Park Run', 'cardio', 5, 50),
('Mountain Hike', 'strength', 10, 500),
('Pool Swim', 'swim', 1, 0),
('Sunrise Yoga', 'yoga', 0, 0),
('Mindful Meditation', 'meditation', 0, 0);

INSERT INTO achievements (user_ID, achievement_name)
VALUES 
(1, 'First 5K Run'),
(2, '100 Workouts Completed'),
(3, 'Swam 10 Miles Total'),
(4, 'Meditation Streak - 30 Days'),
(5, 'Climbed 1,000 Meters');

INSERT INTO comments (user_ID, workout_ID, content)
VALUES 
(2, 1, 'Great run! How was the weather?'),
(3, 2, 'Yoga sessions are the best for relaxation.'),
(1, 3, 'HIIT is killer! Well done.'),
(5, 4, 'Swimming is my favorite too!'),
(4, 5, 'Strength training is so rewarding!');

INSERT INTO likes (user_ID, activity_ID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 3),
(2, 1),
(5, 2);

INSERT INTO users_achievements (user_ID, achievements_ID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 2),
(2, 5);

INSERT INTO users_workout (user_ID, workout_ID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 3),
(3, 4);

INSERT INTO workout_likes (likes_ID, workout_ID)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO workout_comments (user_ID, workout_ID, comment_ID)
VALUES 
(2, 1, 1),
(3, 2, 2),
(1, 3, 3),
(5, 4, 4),
(4, 5, 5);