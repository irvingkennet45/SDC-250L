-- Name: Kenneth Irving

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q1: Enforce referential integrity by adding foreign key constraints to: ORDERS, REVIEWS, and USERLIBRARY. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
ALTER TABLE ORDERS
    ADD CONSTRAINT fk_orders_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID);
ALTER TABLE ORDERS
    ADD CONSTRAINT fk_orders_product FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE);

ALTER TABLE REVIEWS
    ADD CONSTRAINT fk_reviews_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID);
ALTER TABLE REVIEWS
    ADD CONSTRAINT fk_reviews_product FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE);

ALTER TABLE USERLIBRARY
    ADD CONSTRAINT fk_userlibrary_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID);
ALTER TABLE USERLIBRARY
    ADD CONSTRAINT fk_userlibrary_product FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE);

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q2: Display the full name and USERNAME of every user who is at least 18 years old. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT FIRSTNAME || ' ' || LASTNAME AS "Full Name", USERNAME
FROM USERBASE
WHERE BIRTHDAY <= ADD_MONTHS(SYSDATE, -216); 

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q3: Find the maximum length of a USERNAME and the average length of a USERNAME in the USERBASE table. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT MAX(LENGTH(USERNAME)) AS MAX_LENGTH,
       AVG(LENGTH(USERNAME)) AS AVG_LENGTH
FROM USERBASE;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q4: Display every QUESTION that starts with ‘What is’ or ‘What was’ in the SECURITYQUESTION table. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT QUESTION
FROM SECURITYQUESTION
WHERE QUESTION LIKE 'What is%' OR QUESTION LIKE 'What was%';

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q5: Display the PRODUCTCODE, lowest RATING, and number of reviews for each product in the REVIEWS table. Order the results in descending order of the REVIEW count. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  PRODUCTCODE, 
        MIN(RATING) AS LOWEST_RATING, 
        COUNT(*) AS NUM_REVIEWS
FROM REVIEWS
GROUP BY PRODUCTCODE
ORDER BY NUM_REVIEWS DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q6: Display any PRODUCTCODE that is ranked at POSITION 1, as well as the number of users who have the product ranked at that position. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  PRODUCTCODE, 
        COUNT(USERID) AS NUM_USERS
FROM WISHLIST
WHERE POSITION = 1
GROUP BY PRODUCTCODE;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q7: Display the USERID and the total amount each user has spent in ORDERS. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  USERID, 
        SUM(PRICE) AS TOTAL_SPENT
FROM ORDERS
GROUP BY USERID; 

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q8: Determine the most profitable days of the site by showing the gross profits of all orders categorized by their PURCHASEDATE, sorted in descending order of profit. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  PURCHASEDATE, 
        SUM(PRICE) AS GROSS_PROFIT
FROM ORDERS
GROUP BY PURCHASEDATE
ORDER BY GROSS_PROFIT DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q9: Display the PRODUCTCODE and sum of HOURSPLAYED from the USERLIBRARY table. Limit the results to the top 5 games with the most play time and order them in descending order by HOURSPLAYED. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  PRODUCTCODE, 
        SUM(HOURSPLAYED) AS TOTAL_HOURS
FROM USERLIBRARY
GROUP BY PRODUCTCODE
ORDER BY TOTAL_HOURS DESC
FETCH FIRST 5 ROWS ONLY;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q10: Create a view showing a list of each USERID and the count of infractions they have received, sorted with the highest infraction count first. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_USER_INFRACTIONS AS
SELECT  USERID, 
        COUNT(*) AS INFRACTION_COUNT
FROM INFRACTIONS
GROUP BY USERID
ORDER BY INFRACTION_COUNT DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q11: Create a view showing a list of each USERID, RULENUM, and number of times the user broke that RULENUM, sorted by USERID. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_RULE_BREAKS AS
SELECT  USERID, 
        RULENUM, 
        COUNT(*) AS BREAK_COUNT
FROM INFRACTIONS
GROUP BY USERID, RULENUM
ORDER BY USERID;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q12: Display every RULENUM, PENALTY that has been assigned for breaking said rule, and the number of times that PENALTY has been assigned to that RULENUM. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  RULENUM, 
        PENALTY, 
        COUNT(*) AS PENALTY_COUNT
FROM INFRACTIONS
GROUP BY RULENUM, PENALTY;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q13: Display the average, maximum, and minimum time between the DATEUPDATED and DATESUBMITTED for all tickets with a STATUS of ‘CLOSED’. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT AVG(DATEUPDATED - DATESUBMITTED) AS AVG_TIME_DAYS,
       MAX(DATEUPDATED - DATESUBMITTED) AS MAX_TIME_DAYS,
       MIN(DATEUPDATED - DATESUBMITTED) AS MIN_TIME_DAYS
FROM USERSUPPORT
WHERE STATUS = 'CLOSED';

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q14: Display the EMAIL, ISSUE, and the count of times that ISSUE has been submitted, for all tickets with a STATUS of ‘NEW’, grouped by the DATESUBMITTED and ordered by the count. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  EMAIL, 
        ISSUE, 
        COUNT(*) AS ISSUE_COUNT
FROM USERSUPPORT
WHERE STATUS = 'NEW'
GROUP BY DATESUBMITTED, EMAIL, ISSUE
ORDER BY ISSUE_COUNT DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q15: Verify if any current users do not comply with these protocols by displaying any user who has their FIRSTNAME or LASTNAME in their PASSWORD. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT *
FROM USERBASE
WHERE PASSWORD LIKE '%' || FIRSTNAME || '%'
   OR PASSWORD LIKE '%' || LASTNAME || '%';

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q16: Display every PUBLISHER and average PRICE of their products, sorted in alphabetical order of PUBLISHER. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  PUBLISHER, 
        AVG(PRICE) AS AVG_PRICE
FROM PRODUCTLIST
GROUP BY PUBLISHER
ORDER BY PUBLISHER ASC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q17: Create a view that displays the PRODUCTNAME and PRICE for all products with a RELEASEDATE over 5 years ago. Apply a 25% discount to the PRICE. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_DISCOUNTED_GAMES AS
SELECT  PRODUCTNAME, 
        (PRICE * 0.75) AS DISCOUNTED_PRICE
FROM PRODUCTLIST
WHERE MONTHS_BETWEEN(SYSDATE, RELEASEDATE) > 60;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q18: Calculate the maximum and minimum PRICE of all products based on GENRE. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  GENRE, 
        MAX(PRICE) AS MAX_PRICE, 
        MIN(PRICE) AS MIN_PRICE
FROM PRODUCTLIST
GROUP BY GENRE;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q19: Create a view that displays everything in the CHATLOG table from any messages with a DATESENT between now and the previous week. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_RECENT_CHATS AS
SELECT *
FROM CHATLOG
WHERE DATESENT BETWEEN (SYSDATE - 7) AND SYSDATE;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q20: Create a view that displays the USERID, DATEASSIGNED, and PENALTY for any user whose PENALTY is not null and the infraction was assigned within the last month. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_RECENT_PENALTIES AS
SELECT  USERID, 
        DATEASSIGNED, 
        PENALTY
FROM INFRACTIONS
WHERE PENALTY IS NOT NULL
  AND DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);