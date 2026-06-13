-- Name: Kenneth Irving
/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q1: Display the USERID of any users who have not made an order. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT USERID FROM USERBASE
MINUS
SELECT USERID FROM ORDERS;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q2: Display the PRODUCTCODE of any products that have no reviews. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT PRODUCTCODE FROM PRODUCTLIST
MINUS
SELECT PRODUCTCODE FROM REVIEWS;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q3: Display all data in the USERBASE table. Show another column that states “Adult” for any user that is at least 18 years old, and “Minor'' for all other users. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT u.*, 'Adult' AS AGE_GROUP 
FROM USERBASE u 
WHERE MONTHS_BETWEEN(SYSDATE, BIRTHDAY) / 12 >= 18
UNION
SELECT u.*, 'Minor' AS AGE_GROUP 
FROM USERBASE u 
WHERE MONTHS_BETWEEN(SYSDATE, BIRTHDAY) / 12 < 18;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q4: Display all data in the PRODUCTLIST table. Show another column that states “On Sale” for any product that is priced at $20 or less, and “Base Price” for all other products. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT p.*, 'On Sale' AS PRICING_STATUS 
FROM PRODUCTLIST p 
WHERE PRICE <= 20
UNION
SELECT p.*, 'Base Price' AS PRICING_STATUS 
FROM PRODUCTLIST p 
WHERE PRICE > 20;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q5: Display the USERID of any user who has played the product with a PRODUCTCODE of GAME6 and has a user profile image. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT USERID 
FROM USERLIBRARY 
WHERE PRODUCTCODE = 'GAME6'
INTERSECT
SELECT USERID 
FROM USERPROFILE 
WHERE IMAGEFILE IS NOT NULL;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q6: Display any PRODUCTCODE from the intersect of the WISHLIST and REVIEWS table, where the product is in POSITION 1 or 2, and has a review RATING of 3 or higher. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT PRODUCTCODE 
FROM WISHLIST 
WHERE POSITION IN (1, 2)
INTERSECT
SELECT PRODUCTCODE 
FROM REVIEWS 
WHERE RATING >= 3;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q7: Display both user’s USERNAME and BIRTHDAY for any users who share the same BIRTHDAY. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u1.USERNAME AS USER1, 
        u1.BIRTHDAY, 
        u2.USERNAME AS USER2, 
        u2.BIRTHDAY
FROM USERBASE u1
JOIN USERBASE u2 ON u1.BIRTHDAY = u2.BIRTHDAY AND u1.USERID < u2.USERID;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q8: Display the Cartesian Product of the USERLIBRARY table cross joined with the WISHLIST table. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT * 
FROM USERLIBRARY 
CROSS JOIN WISHLIST;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q9: Perform a union all on the USERBASE and PRODUCTLIST tables to generate data on all users and products. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  TO_CHAR(USERID) AS RECORD_ID,
        USERNAME AS RECORD_NAME,
        EMAIL AS CONTACT_INFO,
        BIRTHDAY AS RECORD_DATE
FROM USERBASE
UNION ALL
SELECT  PRODUCTCODE AS RECORD_ID,
        PRODUCTNAME AS RECORD_NAME,
        PUBLISHER AS CONTACT_INFO,
        RELEASEDATE AS RECORD_DATE
FROM PRODUCTLIST;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q10: Perform a union all on the CHATLOG and USERPROFILE tables to generate data on user activity. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  CHATID AS ID,
        DATESENT AS ACTIVITY_DATE,
        CONTENT AS ACTIVITY_DETAILS
FROM CHATLOG
UNION ALL
SELECT  USERID AS ID,
        NULL AS ACTIVITY_DATE,
        DESCRIPTION AS ACTIVITY_DETAILS
FROM USERPROFILE;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q11: Display the USERNAME of all users who have not received an INFRACTION. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT USERNAME FROM USERBASE
MINUS
SELECT u.USERNAME 
FROM USERBASE u 
JOIN INFRACTIONS i ON u.USERID = i.USERID;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q12: Display the TITLE and DESCRIPTION of any COMMUNITYRULES that have not been broken. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT TITLE, DESCRIPTION FROM COMMUNITYRULES
MINUS
SELECT c.TITLE, c.DESCRIPTION 
FROM COMMUNITYRULES c 
JOIN INFRACTIONS i ON c.RULENUM = i.RULENUM;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q13: Display the USERNAME and EMAIL of all users who have received a penalty for their INFRACTION. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT USERNAME, EMAIL FROM USERBASE
INTERSECT
SELECT u.USERNAME, u.EMAIL 
FROM USERBASE u 
JOIN INFRACTIONS i ON u.USERID = i.USERID 
WHERE i.PENALTY IS NOT NULL;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q14: Display the dates where an INFRACTION was assigned and a USERSUPPORT ticket was submitted on the same day. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT TRUNC(DATEASSIGNED) AS EVENT_DATE FROM INFRACTIONS
INTERSECT
SELECT TRUNC(DATESUBMITTED) AS EVENT_DATE FROM USERSUPPORT;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q15: Display every COMMUNITYRULES TITLE and PENALTY. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT c.TITLE, i.PENALTY 
FROM COMMUNITYRULES c
JOIN INFRACTIONS i ON c.RULENUM = i.RULENUM;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q16: Display all data in the COMMUNITYRULES table. Show another column that states “Bannable'' for any rule with a 10 or higher SEVERITYPOINT, and “Appealable” for all other rules. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT c.*, 'Bannable' AS PENALTY_TYPE 
FROM COMMUNITYRULES c 
WHERE SEVERITYPOINT >= 10
UNION
SELECT c.*, 'Appealable' AS PENALTY_TYPE 
FROM COMMUNITYRULES c 
WHERE SEVERITYPOINT < 10;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q17: Display all data in the USERSUPPORT table. Show another column that states “High Priority” for any ticket that is not closed and has not been updated in the past week. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT u.*, 'High Priority' AS PRIORITY_LEVEL 
FROM USERSUPPORT u 
WHERE STATUS != 'CLOSED' AND DATEUPDATED < SYSDATE - 7
UNION
SELECT u.*, 'Normal Priority' AS PRIORITY_LEVEL 
FROM USERSUPPORT u 
WHERE STATUS = 'CLOSED' OR DATEUPDATED >= SYSDATE - 7;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q18: Display the Cartesian Product of the USERSUPPORT table cross joined with the INFRACTIONS table. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT * 
FROM USERSUPPORT 
CROSS JOIN INFRACTIONS;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q19: Display both TICKETIDs and DATEUPDATED for any support tickets that are ‘CLOSED’ and the last DATEUPDATED was on the same day. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  t1.TICKETID AS TICKET1, 
        t1.DATEUPDATED, 
        t2.TICKETID AS TICKET2, 
        t2.DATEUPDATED
FROM USERSUPPORT t1
JOIN USERSUPPORT t2 ON TRUNC(t1.DATEUPDATED) = TRUNC(t2.DATEUPDATED) AND t1.TICKETID < t2.TICKETID
WHERE t1.STATUS = 'CLOSED' AND t2.STATUS = 'CLOSED';

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q20: Perform a union all on the USERBASE and INFRACTIONS tables to generate data on user activity. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  USERID AS RECORD_ID,
        USERNAME AS RECORD_DETAILS,
        NULL AS EVENT_DATE,
        'User' AS RECORD_TYPE
FROM USERBASE
UNION ALL
SELECT  INFRACTIONID AS RECORD_ID,
        PENALTY AS RECORD_DETAILS,
        DATEASSIGNED AS EVENT_DATE,
        'Infraction' AS RECORD_TYPE
FROM INFRACTIONS;
