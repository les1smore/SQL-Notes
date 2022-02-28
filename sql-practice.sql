Fri Feb 25 2022
# 175
SELECT tb1.FirstName, tb1.LastName, tb2.City, tb2.State
FROM Person tb1 LEFT JOIN Address tb2 ON tb1.personId = tb2.personId;

# 176
SELECT Salary AS SecondHighestSalary
FROM Employee
WHERE Salary < (SELECT max(Salary) FROM Employee);

# 177
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N = N-1 ;
    RETURN(SELECT DISTINCT Salary 
           FROM Employee
           ORDER BY Salary DESC
           LIMIT 1 OFFSET N)
END;

# 603
SELECT tb1.seat_id
FROM cinema tb1 JOIN cinema tb2 ON abs(tb1.seat_id - tb2.seat_id = 1) 
WHERE tb1.free = 1 AND tb2.free = 2
ORDER BY tb1.seat_id DESC;

# 180
SELECT DISTINCT tb1.Num AS ConsecutiveNums
FROM Logs tb1, Logs tb2, Logs tb3
WHERE tb1.Id = tb2.Id - 1 AND tb2.Id = tb3.Id - 1
AND tb1.Num = tb2.Num AND tb2.Num = tb3.Num

# 184
SELECT tb1.Name AS Department, tb1.Name AS Employee, tb1.Salary AS Salary
FROM Employee AS tb1 JOIN Department AS tb2 ON tb1.department_id = tb2.Id
WHERE tb1.Salary = (SELECT MAX(SALARY) FROM tb1 WHERE tb1.department_id = tb2.Id)


Mon Feb 28 2022
# 185
SELECT tb2.Name AS Department, tb1.Name AS Employee, tb1.Salary AS Salary
FROM Employee tb1 INNER JOIN Department tb2 ON tb1.department_id = tb2.department_id
WHERE (SELECT COUNT(DISTINCT salary 
       FROM Employee tb3
       WHERE tb3.department_id = tb2_id AND
       tb3.Salary > tb1.Salary)
       ) < 3
ORDER BY Salary DESC;

# 595
SELECT name, population, area
FROM World
WHERE area > 3000000 OR area > 25000000;

# 196
DELETE tb2
SELECT * 
FROM Person tb1, Person tb2
WHERE tb1.Email = tb2.Email
AND tb1.Id < tb2.Id

# 626
SELECT (CASE WHEN mod(seat.id,2) <> 0 AND seat.id = (SELECT COUNT(*) FROM seat) THEN seat.id
        WHEN mod(seat.id,2) = 1 THEN seat.id + 1
        ELSE seat.id - 1
END) AS id, student
FROM seat
ORDER BY id;


Jan 28 Fri 2022

# 569 Median Employee Salary "In general, the median's frequency should be equal or greater than the asbolute difference
 of its bigger elements and small ones in an array no matter whether it has odd or even 
 amout of numbers and whether they are distinct"

 "The SIGN() function returns a value indicating  the sign of a number, this function will return one of the following:
 - if number > 0, it returns 1
 - if number = 0, it returns 0
 - if number < 0, it returns -1"
SELECT tb1.Id, tb1.Compnay, tb1.Salary
FROM Employee AS tb1, Employee as tb2
WHERE tb1.Company = tb2.Company
GROUP BY tb1.Company, tb1.Salary
HAVING SUM(CASE WHEN tb1.Salary = tb2.Salary THEN 1
           ELSE 0
           END) >= ABS(SUM(SIGN(tb1.Salary - tb2.Salary)))
ORDER BY tb1.id
--------------------
Feb 6 Sun 2022 
# 615 Average Salary
"1. Calculate the average salary of the company in each month
 2. Calculate the average salary of the department in each month
 3. Join the two query results using pay_month"
SELECT department_salary.pay_month, department_id, 
(CASE WHEN AvgDepartment > AvgCompany THEN 'higher'
      WHEN AvgDeparment < AvgCompany THEN 'lower'
      ELSE 'same'
END) AS comparison
FROM (SELECT avg(amount) AS AvgCompany, date_format(pay_date, '%Y-%m') AS pay_month
      FROM salary  GROUP BY date_format(pay_date, '%Y-%m') AS company_salary
      JOIN   
      (SELECT department_id, avg(amount) AS AvgDepartment, date_format(pay_date, '%Y-%m') AS pay_month
       FROM salary JOIN employee on salary.employee_id = employee.employee_id
       GROUP BY department_id, pay_month) AS department_salary
       ON department_salary.pay_month = company.pay_month
ORDER BY department_salary.pay_month, department_id;
--------------------
Feb 7 Mon 2022
# 570 "Managers with at least 5 direct reports"
SELECT Name
FROM Employee AS tb1 
JOIN (SELECT ManagerId FROM 
      Employee 
      GROUP BY ManagerId
      HAVING COUNT(ManagerId) >= 5) AS tb2 
ON tb1.Id = tb2.ManagerId;

# 597 "Friend Requests |: Overall Acceptance Rate"
SELECT ifnull (ROUND(COUNT(DISTINCT requester_id, accepter_id) 
/ COUNT(DISTINCT sender_id, send_to_id),2), 0) AS accept_rate
FROM friend_request, request_accepted
----------------------
Feb 8 Tue 2022

# 574 "Winning Candidate"
SELECT Name 
FROM Candidate JOIN 
(SELECT CandidateId FROM Vote
GROUP BY CandidateId COUNT(*) DESC LIMIT 1)AS winner
ON Vote.id = winner.CandidateId;

# 178 "Rank Scores"
"Rank = (the # of score that is distinctly greater than the column itself) + 1"
"Add quotation mark to rank as it'd conflict with the built-in function rank otherwise"
SELECT tb1.Score AS Score,
(SELECT COUNT(DISTINCT tb2.Score) FROM Score AS tb2 WHERE tb2.Score > tb1.Score)
)+1 AS 'Rank'
FROM Scores AS tb1
ORDER BY tb1.Score DESC

"window function"
SELECT score, DENSE_RANK() OVER (ORDER BY Score DESC) AS 'Rank'
FROM Scores;
--------------------
Feb 9 Wed 2022
# 579 "Find Cumulative Salary of an Employee"
SELECT tb1.Id, tb2.Month AS Month, SUM(tb2.Salary) AS Salary
FROM Employee AS tb1 JOIN Employee AS tb2 ON tb1.Id = tb2.Id
WHERE tb2.Month BETWEEN MAX(tb1.Month-3) AND MAX(tb1.Month-1)
GROUP BY tb2.Id, tb2.Month
ORDER BY ID, Month DESC;

# 608 "Tree Node"
SELECT tb1.id,
IF(isnull(tb1.p_id),'Root', IF(tb1.id in (SELECT p_id FROM tb1),'Inner','Leaf')) AS Type
FROM tree AS tb1
--------------------------
Feb 13 Sun 2022
# 610 "Triangle judgement"
SELECT x, y, z,
(CASE WHEN x+y <= z OR x+z<=y OR y+z<= x THEN 'No'
ELSE 'Yes' 
END) AS 'triangle'
FROM triangle;

# 180 "Consecutive Numbers"
SELECT (DISTINCT tb1.Id) AS ConsecutiveNums
FROM Logs AS tb1, Logs AS tb2, Logs AS tb3
WHERE tb1.Id = tb2.Id - 1, tb2.Id = tb3.Id - 1
AND tb1.Num = tb2.Num = tb3.Num;

# 181 "Employees Earning More Than Their Managers"
SELECT tb2.Name AS Employee
FROM Employee AS tb1,Employee AS tb2 
WHERE tb1.Id = tb2.ManagerId AND tb1.Salary < tb2.Id
AND tb2.ManagerId IS NOT NULL;

# 182 "Duplicate Emails"
SELECT DISTINCT Email
FROM Person 
GROUP BY Email
HAVING COUNT(*) > 1;

# 183 "Customer Who Never Order"
SELECT tb1.Name AS Customers 
FROM Customers AS tb1
WHERE tb1.Id NOT IN (SELECT tb2.CustomerId FROM Orders AS tb2);
--------------------
Feb 15 Tue 2022
# 196 "Delete Duplicate Emails"
DELETE tb1
FROM Person tb1, Person tb2
WHERE tb1.Email = tb2.Email AND tb1.Id > tb2.Id

# 197 "Rising Temperature"
SELECT tb1.Id
FROM Weather tb1, Weather tb2
WHERE tb1.Temperature > tb2.Temperature
AND TO_DAYS(tb1.RecordDate) - TO_DAYS(tb2.RecordDate) = 1;

# 262 "Trips and Users"
SELECT Request_at AS "Day", 
(Round((SUM(CASE WHEN Status LIKE 'cancelled%' THEN 1 ELSE 0 END)) / COUNT(*), 2)) AS "Cancellation Rate"
FROM (SELECT * FROM Trips tb1 WHERE
      tb1.Client_Id NOT IN (SELECT Users_Id FROM Users WHERE Banned = 'YES') AND
      tb1.Driver_ID NOT IN (SELECT Users_ID FROM Users WHERE Banned = 'YES') AND
      tb1.Request_at BETWEEN '2013-10-01' AND '2013-10-03') as tb2
GROUP BY Request_at;

# 571 "Find Median Given Frequency of Numbers"
SELECT Avg(tb1.Number) AS median
FROM Numbers tb1
WHERE tb1.Frequency >= abs((SELECT SUM(Frequency) FROM Numbers WHERE Number >= tb1.Number)- 
                            SELECT SUM(Frequency) FROM Numbers WHERE Number <= tb1.Number))


# 577 "Employee Bonus"
SELECT tb1.name, tb2.bonus
FROM Employee tb1 LEFT JOIN Bonus tb2 ON tb1.empId = tb2.empId 
WHERE tb2.bonus < 1000 OR bonus IS NULL 

# 578 "Get Highest Answer Rate Question"
SELECT (question_id) AS survey_log
FROM (
      SELECT question_id, SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) AS num_show,
      SUM(CASE WHEN action = 'answer' THEN 1 THEN 0) AS num_answer
      FROM survey_log
      GROUP BY question_id) AS tb1
ORDER BY (num_answer / num_show) DESC LIMIT 1;

# 580 "Count Stdent Number in Departments"
SELECT tb2.dept_name, (COUNT(tb1.student_id)) AS student_number
FROM student tb1 RIGHT JOIN department tb2 ON tb1.dept_id = tb2.dept_id
GROUP BY tb2.dept_name
ORDER BY student_number DESC, tb2.dept_name;

# 584 "Find Customer Referee"
SELECT name
FROM customer
WHERE referee_id <> 2 OR referee_id IS NULL;

# 585 "Investments in 2016"
"1 means we want unique rows with unique lattitude and longitude
 > 1 means we want find rows that share the same tiv_2015 values"
SELECT ROUND(SUM(TIV_2016), 2) AS TIV_2016
FROM insurance tb1
WHERE (SELECT COUNT(*) FROM insurance tb2 WHERE tb1.LAT = tb2.LAT AND 
       tb1.LON = tb2.LON) = 1 AND 
      (SELECT COUNT(*) FROM insurance tb3 WHERE tb1.TIV_2015 = tb2.TIV_2015);

# 586 "Customer Placing the Largest Number of Orders"
SELECT customer_number 
FROM orders
GROUP BY customer_number
ORDER BY COUNT(*) DESC LIMIT 1; 
--------------------
Feb 16 Wed 2022
# 596 "Classes More Than 5 Students"
SELECT class 
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >=5;

# 601 "Human Traffic of Stadium"
"consider the three conditions where the row is in the top, middle, and the bottom."
SELECT distinct tb1.id, tb1.date, tb1.people
FROM stadium AS tb1, stadium AS tb2, stadium AS tb3
WHERE tb1.people >= 100 
      AND tb2.people >= 100 
      AND tb3.people >= 100
      AND ((tb1.id + 1 = tb2.id AND tb1.id + 2 = tb3.id) OR 
            (tb1.id - 1 = tb2.id AND tb1.id + 1 = tb3.id) OR
            (tb1.id - 1 = tb2.id AND tb1.id - 2 = tb3.id)) 
ORDER BY tb1.id;

# 602 "Friend Requests ||: Who Has the Most Friends"
"Union the requester and accepter to count the number of the occurence of each person
Being friends is bidirectional, so if one person accepts a request from another person, both of them will have one more friend
"
SELECT id1 as id, COUNT(*) AS num
FROM (SELECT requester_id as id1, accepter_id as id2 FROM request_accepted
      UNION 
      SELECT accepter_id as id1, requester_id as id2 FROM request_accepted) AS tb1
)AS tb1
GROUP BY id1
ORDER BY num DESC LIMIT 1;

# 607 "Sales Person"
SELECT tb1.name AS name
FROM salesperson AS tb1
WHERE tb1.sales_id NOT IN 
      (SELECT sales_id FROM orders tb2 LEFT JOIN company tb3 
      ON tb2.com_id = tb3.com_id WHERE tb3.name = 'RED');

--------------------
Feb 19 Sat 2022
# 612 "Shortest Distance in a Plane"
SELECT (ROUND(sqrt(min(pow(tb1.x-tb2.x,2)+pow(tb1.y-tb2.y,2))), 2) AS shortest
FROM point_2d AS tb1, point_2d AS tb2
WHERE (tb1.x, tb1.y) != (tb2.x, tb2.y);

# 613 "Shortest Distance in a Line"
SELECT (min(abs(tb1.x - tb2.x))) AS shortest
FROM point as tb1, point as tb2
WHERE tb1.x != tb2.x

# 614 "Second Degree Follower"
SELECT distinct tb1.follower, COUNT(tb2.follower) AS num
FROM follow tb1 JOIN follow tb2 ON tb1.follower = tb2.followee
GROUP BY tb1.follower
ORDER BY tb1.follower;

--------------------
Feb 21 Mon 2022
# 619 "Biggest Single Number"
SELECT (SELECT num FROM number 
        GROUP BY num HAVING COUNT(*) = 1
        ORDER BY num DESC LIMIT 1   ) as num;

# 620 "Not Boring Movies"
SELECT *
FROM cinema
WHERE (description <> "boring") AND (id % 2 = 1)
ORDER BY rating DESC;

# 627 "Swap Salary"
UPDATE salary
SET sex = (CASE WHEN sex = 'm' THEN 'f' ELSE 'm'
           END)

# 175 "Combine Two Tables"
SELECT tb1.firstName, tb1.lastName, tb2.city, tb2.state
FROM Person AS tb1 LEFT JOIN Address AS tb2 
ON tb1.personId = tb2.personId;




