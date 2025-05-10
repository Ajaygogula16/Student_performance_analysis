use ajay;

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    gender VARCHAR(10),
    ethnicity VARCHAR(20),
    parental_education VARCHAR(50)
);


CREATE TABLE SocioEconomicFactors (
    factor_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT REFERENCES Students(student_id),
    lunch_type VARCHAR(20),
    test_preparation VARCHAR(20)
);


CREATE TABLE AcademicPerformance (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT REFERENCES Students(student_id),
    math_score INT,
    reading_score INT,
    writing_score INT,
    total_score INT GENERATED ALWAYS AS (math_score + reading_score + writing_score) STORED,
    performance_category VARCHAR(20)
);


INSERT INTO Students (gender, ethnicity, parental_education)
SELECT gender, `race/ethnicity`, `parental level of education`
FROM eda_dataset;


INSERT INTO SocioEconomicFactors (student_id, lunch_type, test_preparation)
SELECT s.student_id, e.lunch, e.`test preparation course`
FROM eda_dataset e
JOIN Students s ON e.gender = s.gender AND e.`race/ethnicity` = s.ethnicity;


INSERT INTO AcademicPerformance (student_id, math_score, reading_score, writing_score, performance_category)
SELECT s.student_id, e.`math score`, e.`reading score`, e.`writing score`, e.performance_category
FROM eda_dataset e
JOIN Students s ON e.gender = s.gender AND e.`race/ethnicity` = s.ethnicity;


-- CTE
WITH AvgScores AS (
    SELECT AVG(math_score) AS avg_math, 
           AVG(reading_score) AS avg_reading, 
           AVG(writing_score) AS avg_writing
    FROM AcademicPerformance
)
SELECT s.student_id, s.gender, s.ethnicity, ap.math_score, ap.reading_score, ap.writing_score
FROM AcademicPerformance ap
JOIN Students s ON ap.student_id = s.student_id
JOIN AvgScores a ON ap.math_score > a.avg_math 
                  AND ap.reading_score > a.avg_reading 
                  AND ap.writing_score > a.avg_writing;

-- JOINS
SELECT 
	   s.student_id,
	   A.total_score
from 
       students s
inner join 
      AcademicPerformance A
on
     s.student_id=A.student_id;



-- SUBQUERY
SELECT student_id, total_score
FROM AcademicPerformance
WHERE total_score = (SELECT MAX(total_score) FROM AcademicPerformance);

