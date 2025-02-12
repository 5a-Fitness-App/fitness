

CREATE TABLE users (
    user_ID SERIAL PRIMARY KEY,
    
);

CREATE TABLE friends (
    user_ID SERIAL PRIMARY KEY,
);

CREATE TABLE workouts (
    workout_ID SERIAL PRIMARY KEY,
);

CREATE TABLE activities (
    activities_ID SERIAL PRIMARY KEY,
);

CREATE TABLE achievements (
    achievements_ID SERIAL PRIMARY KEY,
);

CREATE TABLE comments (
    comments_ID SERIAL PRIMARY KEY,
);

CREATE TABLE likes (
    likes_ID SERIAL PRIMARY KEY,

);

CREATE TABLE users_friends (

);

CREATE TABLE users_achievements (

);

CREATE TABLE users_workout (

);

CREATE TABLE workout_likes (

);

CREATE TABLE workout_comments (

);




-- CREATE TABLE rooms (
--     room_id SERIAL PRIMARY KEY
-- );

-- CREATE TABLE counrties (
--     counrty_id SERIAL PRIMARY KEY
-- );

-- CREATE TABLE courses (
--     course_id SERIAL PRIMARY KEY,
--     dpt_id int not null,
--     FOREIGN KEY (dpt_id) REFERENCES departments(dpt_id)
-- );

-- CREATE TABLE students (
--     stu_id SERIAL PRIMARY KEY,
--     tutor_id int not null,
--     course_id int not null,
--     FOREIGN KEY (tutor_id) REFERENCES staff(staff_id),
--     FOREIGN KEY (course_id) REFERENCES courses(course_id)
-- );

-- CREATE TABLE adresses (
--     adr_id SERIAL PRIMARY KEY,
--     counrty_id int not null,
--     FOREIGN KEY (counrty_id) REFERENCES counrties(counrty_id)
-- );


-- CREATE TABLE modules (
--     mod_id SERIAL PRIMARY KEY
-- );

-- CREATE TABLE teaching_sessions (
--     session_id SERIAL PRIMARY KEY,
--     mod_id int not null,
--     room_id int not null,
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (room_id) REFERENCES rooms(room_id)
-- );
-- -------- intersection tables

-- CREATE TABLE modules_courses (
--     mod_id int not null,
--     course_id int not null,
--     PRIMARY KEY (mod_id, course_id),
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (course_id) REFERENCES courses(course_id)
-- );

-- CREATE TABLE student_addresses (
--     stu_id int not null,
--     adr_id int not null,
--     PRIMARY KEY (stu_id, adr_id),
--     FOREIGN KEY (stu_id) REFERENCES students(stu_id),
--     FOREIGN KEY (adr_id) REFERENCES adresses(adr_id)
-- );
-- CREATE TABLE staff_teaching (
--     mod_id int not null,
--     course_id int not null,
--     PRIMARY KEY (mod_id, course_id),
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (course_id) REFERENCES courses(course_id)
-- );

-- CREATE TABLE modules_results (
--     submition_id SERIAL PRIMARY KEY,
--     mod_id int not null,
--     stu_id int not null,
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (stu_id) REFERENCES students(stu_id)
-- );
-- CREATE TABLE staff_modules (
--     staff_id int not null,
--     mod_id int not null,
--     PRIMARY KEY (staff_id, mod_id),
--     FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id)
-- );
-- CREATE TABLE students_teaching (
--     stu_id int not null,
--     session_id int not null,
--     PRIMARY KEY (stu_id, session_id),
--     FOREIGN KEY (stu_id) REFERENCES students(stu_id),
--     FOREIGN KEY (session_id) REFERENCES teaching_sessions(session_id)
-- );
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------

-- CREATE TABLE departments (
--     dpt_id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL
-- );

-- CREATE TABLE staff (
--     staff_id SERIAL PRIMARY KEY,
--     dpt_id INT NOT NULL,
--     name VARCHAR(100) NOT NULL,
--     position VARCHAR(100) NOT NULL,
--     email VARCHAR(100) NOT NULL,
--     phone VARCHAR(20) NOT NULL,
--     FOREIGN KEY (dpt_id) REFERENCES departments(dpt_id)
-- );

-- CREATE TABLE rooms (
--     room_id SERIAL PRIMARY KEY,
--     room_number VARCHAR(20) NOT NULL,
--     capacity INT NOT NULL
-- );

-- CREATE TABLE countries (
--     country_id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL
-- );

-- CREATE TABLE courses (
--     course_id SERIAL PRIMARY KEY,
--     dpt_id INT NOT NULL,
--     name VARCHAR(100) NOT NULL,
--     description TEXT NOT NULL,
--     credit_hours INT NOT NULL,
--     FOREIGN KEY (dpt_id) REFERENCES departments(dpt_id)
-- );

-- CREATE TABLE students (
--     stu_id SERIAL PRIMARY KEY,
--     tutor_id INT NOT NULL,
--     course_id INT NOT NULL,
--     name VARCHAR(100) NOT NULL,
--     date_of_birth DATE NOT NULL,
--     gender VARCHAR(10) NOT NULL,
--     email VARCHAR(100) NOT NULL,
--     FOREIGN KEY (tutor_id) REFERENCES staff(staff_id),
--     FOREIGN KEY (course_id) REFERENCES courses(course_id)
-- );

-- CREATE TABLE addresses (
--     adr_id SERIAL PRIMARY KEY,
--     country_id INT NOT NULL,
--     street VARCHAR(255) NOT NULL,
--     city VARCHAR(100) NOT NULL,
--     postcode VARCHAR(20) NOT NULL,
--     latitude NUMERIC(10, 6) NOT NULL,
--     longitude NUMERIC(10, 6) NOT NULL,
--     FOREIGN KEY (country_id) REFERENCES countries(country_id)
-- );

-- CREATE TABLE modules (
--     mod_id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     description TEXT NOT NULL,
--     start_date DATE NOT NULL,
--     end_date DATE NOT NULL
-- );

-- CREATE TABLE teaching_sessions (
--     session_id SERIAL PRIMARY KEY,
--     mod_id INT NOT NULL,
--     room_id INT NOT NULL,
--     date DATE NOT NULL,
--     start_time TIME NOT NULL,
--     end_time TIME NOT NULL,
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (room_id) REFERENCES rooms(room_id)
-- );

-- CREATE TABLE modules_courses (
--     mod_id INT NOT NULL,
--     course_id INT NOT NULL,
--     PRIMARY KEY (mod_id, course_id),
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (course_id) REFERENCES courses(course_id)
-- );

-- CREATE TABLE student_addresses (
--     stu_id INT NOT NULL,
--     adr_id INT NOT NULL,
--     PRIMARY KEY (stu_id, adr_id),
--     FOREIGN KEY (stu_id) REFERENCES students(stu_id),
--     FOREIGN KEY (adr_id) REFERENCES addresses(adr_id)
-- );

-- CREATE TABLE staff_teaching (
--     mod_id INT NOT NULL,
--     staff_id INT NOT NULL,
--     PRIMARY KEY (mod_id, staff_id),
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
-- );

-- CREATE TABLE modules_results (
--     submission_id SERIAL PRIMARY KEY,
--     mod_id INT NOT NULL,
--     stu_id INT NOT NULL,
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id),
--     FOREIGN KEY (stu_id) REFERENCES students(stu_id)
-- );

-- CREATE TABLE staff_modules (
--     staff_id INT NOT NULL,
--     mod_id INT NOT NULL,
--     PRIMARY KEY (staff_id, mod_id),
--     FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
--     FOREIGN KEY (mod_id) REFERENCES modules(mod_id)
-- );

-- CREATE TABLE students_teaching (
--     stu_id INT NOT NULL,
--     session_id INT NOT NULL,
--     PRIMARY KEY (stu_id, session_id),
--     FOREIGN KEY (stu_id) REFERENCES students(stu_id),
--     FOREIGN KEY (session_id) REFERENCES teaching_sessions(session_id)
-- );