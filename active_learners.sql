#active learners
 SELECT 
    course_id,
    student_id,
    DATE(MAX(modified)) AS last_active_date,
    CASE
        WHEN
            MAX(modified) > DATE_ADD(CURRENT_TIMESTAMP(),
                INTERVAL - 7 DAY)
        THEN
            1
        ELSE 0
    END AS active_last_week,
    CASE
        WHEN
            MAX(modified) > DATE_ADD(CURRENT_TIMESTAMP(),
                INTERVAL - 1 MONTH)
        THEN
            1
        ELSE 0
    END AS active_last_month
FROM
    edxapp.courseware_studentmodule
GROUP BY course_id , student_id;
 
 
 #count active
 SELECT 
    course_id,
    COUNT(*) AS all_learners,
    SUM(active_last_month) AS active_last_month,
    SUM(active_last_week) AS active_last_week
FROM
    (SELECT 
        course_id,
            student_id,
            CASE
                WHEN MAX(modified) > DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL - 1 MONTH) THEN 1
                ELSE 0
            END AS active_last_month,
            CASE
                WHEN MAX(modified) > DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL - 7 DAY) THEN 1
                ELSE 0
            END AS active_last_week
    FROM
        edxapp.courseware_studentmodule
    GROUP BY course_id , student_id) A
GROUP BY course_id;
