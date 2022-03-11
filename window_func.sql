1. "Add a column with max weight by city"
SELECT
    p.*,
    MAX(weight) OVER (PARTITION BY city) AS maxwt_by_city

FROM patients p;

2. "Add a column with max weight over all"
SELECT
    p.*,
    MAX(weight) OVER () AS maxwt_overall

FROM patients p;

3. "Caculate a running total of the number of admission by date"
SELECT 
    a.*,
    COUNT(*) OVER(ORDER BY admission_date) AS rolling_ct_admits

FROM admission a
ORDER BY
    admission_date;

4. "Find the second youngest patients in each city"
with birth_dt_ct AS (
    SELECT
    p.*,
    row_number() OVER (PARTITION BY city ORDER BY birth_date desc) AS row_num
    FROM patients p
)

SELECT *
FROM birth_dt_ct
WHERE TRUE and row_num = 2;

5. "What are the difference in height for each patient compared to the next tallest person"
WITH height_diff AS (
    SELECT 
        p.*,
        LAG(height) OVER (ORDER BY height) AS lag_height
    
    FROM patients p
)

SELECT 
    h.*,
    height - lag_height AS height_diff
    
FROM height_diff h
ORDER BY height;

6. "RANK() - Get the row number and rank the rows"
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY job ORDER BY Salary) as 'row_number',
    RANK() OVER (PARTITION BY job ORDER BY Salary) AS 'rank_row'
FROM emp;

7. "DENSE_RANK() - doesn't skip any ranks when ranking rows"
SELECT *
    ROW_NUMBER() OVER (PARTITION BY job ORDER BY Salary) as 'row_number',
    RANK() OVER (PARTITION BY job ORDER BY Salary) AS 'rank_row'
    DENSE_RANK() OVER (PARTITION BY job ORDER BY Salary) AS 'dense_rank_row'
FROM emp;

8. "Nth_Value - retrieve the nth value from a window frame for an expression"
"output the third value from each partition"
SELECT *,
    NTH_VALUE(name, 3) OVER (PARTITION BY job ORDER BY salary 
                            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 'third'
FROM emp;

"output the first value from each partition"
SELECT *,
    NTH_VALUE(name, 1) OVER (PARTITION BY job ORDER BY salary ASC
                            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'first'
FROM emp;

"output the last value from each partition"
SELECT *,
    NTH_VALUE(name, 1) OVER (PARTITION BY job ORDER BY salary desc
                            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'last'
FROM emp;

9. "Ntile - sort te rows within the partition into a certain number of groups (percentile, quartile)"
SELECT *,
    NTILE(4) OVER (ORDER BY salary) AS 'quartile'
FROM emp;  
