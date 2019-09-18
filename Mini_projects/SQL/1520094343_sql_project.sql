/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
Answer to Q1: 
SELECT name, membercost
FROM country_club.Facilities
WHERE membercost >0



/* Q2: How many facilities do not charge a fee to members? */
Answer to Q2: 
SELECT  COUNT(*)
FROM  `Facilities` 
WHERE  `membercost` =0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
Answer to Q3: 
SELECT `facid`, 
       `name`, 
       `membercost`,
        `monthlymaintenance`,
         `membercost`/`monthlymaintenance` *100 as cost_maintenance_ratio 
FROM `Facilities` 
WHERE `membercost` > 0 AND
`membercost`/`monthlymaintenance` < 20 --cost_maintenance_ratio is under 20%

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
Answer to Q4: 
SELECT * 
FROM  `Facilities` 
WHERE  `facid` IN ( 1, 5 ) 
ORDER BY  `facid`

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
Answer to Q5: 
SELECT  `name` ,  `monthlymaintenance` , 
CASE WHEN  `monthlymaintenance` >100
THEN  'EXPENSIVE'
ELSE  'CHEAP'
END AS FACILITIES_LIST
FROM  `Facilities` 
ORDER BY FACILITIES_LIST DESC 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
ANSWER TO Q6: 
SELECT `firstname`,`surname`
FROM `Members`
WHERE `joindate` = (SELECT MAX(`joindate`) FROM `Members`) --Selecting most recent date from member's table

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
Answer to Q7: 
SELECT name, CONCAT( surname,  ',', firstname ) AS  "Tennis Users"
FROM
 (SELECT DISTINCT Mem.surname, Mem.firstname, Fac.name
FROM  `Bookings` Bkk
JOIN Members Mem ON Bkk.memid = Mem.memid
JOIN 
(SELECT * 
FROM  `Facilities` 
WHERE name LIKE  "Tennis court%") Fac 
ON Bkk.facid = Fac.facid
ORDER BY Mem.surname, Mem.firstname, Fac.name)sub


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
Answer to Q8
SELECT Fac.name, CONCAT( Mem.firstname,  ' ', Mem.surname ) AS  "Member Name", 
CASE WHEN Bkk.memid =0
THEN Fac.guestcost * Bkk.slots
ELSE Fac.membercost * Bkk.slots
END AS Cost
FROM Bookings Bkk
JOIN Facilities Fac ON Bkk.facid = Fac.facid
JOIN Members Mem ON Bkk.memid = Mem.memid
WHERE LEFT( Bkk.starttime, 10 ) =  '2012-09-14'
AND CASE WHEN Bkk.memid =0
THEN Fac.guestcost * Bkk.slots
ELSE Fac.membercost * Bkk.slots
END >30
ORDER BY Cost DESC 


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
Answer to Q9
SELECT *
FROM
(SELECT Fac.name, CONCAT( Mem.firstname,  ' ', Mem.surname ) AS  "Member Name", 
CASE WHEN Bkk.memid =0
THEN Fac.guestcost * Bkk.slots
ELSE Fac.membercost * Bkk.slots
END AS Cost
FROM Bookings Bkk
JOIN Facilities Fac ON Bkk.facid = Fac.facid
JOIN Members Mem ON Bkk.memid = Mem.memid
WHERE LEFT( Bkk.starttime, 10 ) =  '2012-09-14') sub
WHERE sub.COST >30
ORDER BY Cost DESC 

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
Answer to Q10
SELECT name, revenue 
FROM
(SELECT Bkk.facid, Fac.name,
SUM(CASE WHEN Bkk.memid = 0 THEN Bkk.slots*Fac.guestcost
ELSE Bkk.slots*Fac.membercost END) AS revenue
FROM Bookings Bkk
JOIN Facilities Fac
ON Bkk.facid = Fac.facid
GROUP BY 1,2)sub
WHERE revenue < 1000
ORDER by revenue DESC

