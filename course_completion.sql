#course completers

SELECT 
    enroll.user_id,
    enroll.course_id,
    created AS enroll_date,
    passed_timestamp AS pass_date,
    CASE
        WHEN passed_timestamp IS NOT NULL THEN 1
        ELSE 0
    END AS completed
FROM
    edxapp.student_courseenrollment AS enroll
        LEFT JOIN
    (SELECT 
        user_id, course_id, passed_timestamp
    FROM
        edxapp.grades_persistentcoursegrade
    WHERE
        passed_timestamp IS NOT NULL) AS grades ON grades.user_id = enroll.user_id
        AND grades.course_id = enroll.course_id;


#completion rates
SELECT 
    course_id,
    COUNT(*) AS enrolls,
    AVG(completed) AS completion_rate,
    SUM(completed) AS total_completions
FROM
    (SELECT 
        enroll.user_id,
            enroll.course_id,
            created AS enroll_date,
            passed_timestamp AS pass_date,
            CASE
                WHEN passed_timestamp IS NOT NULL THEN 1
                ELSE 0
            END AS completed
    FROM
        edxapp.student_courseenrollment AS enroll
    LEFT JOIN (SELECT 
        user_id, course_id, passed_timestamp
    FROM
        edxapp.grades_persistentcoursegrade
    WHERE
        passed_timestamp IS NOT NULL) AS grades ON grades.user_id = enroll.user_id
        AND grades.course_id = enroll.course_id) A
GROUP BY course_id	;
