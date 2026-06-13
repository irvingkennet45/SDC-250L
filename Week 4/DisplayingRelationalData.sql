-- Name: Kenneth Irving
/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q1: Display every USERNAME and the lowest RATING they have left in a review. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERNAME, 
        MIN(r.RATING) AS LOWEST_RATING
FROM USERBASE u
JOIN REVIEWS r ON u.USERID = r.USERID
GROUP BY u.USERNAME;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q2: Display every user’s EMAIL, QUESTION, and ANSWER */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.EMAIL, 
        s.QUESTION, 
        s.ANSWER
FROM USERBASE u
JOIN SECURITYQUESTION s ON u.USERID = s.USERID;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q3: Display the FIRSTNAME, EMAIL, and WALLETFUNDS of every user that does not have a WISHLIST. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  FIRSTNAME, 
        EMAIL, 
        WALLETFUNDS
FROM USERBASE
WHERE USERID NOT IN (SELECT USERID FROM WISHLIST);

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q4: Display every USERNAME and number of products they have ordered. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERNAME, 
        COUNT(o.PRODUCTCODE) AS ORDER_COUNT
FROM USERBASE u
LEFT JOIN ORDERS o ON u.USERID = o.USERID
GROUP BY u.USERNAME;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q5: Display the age of any user who has ordered a product within the last 6 months. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  DISTINCT TRUNC(MONTHS_BETWEEN(SYSDATE, u.BIRTHDAY) / 12) AS AGE
FROM USERBASE u
JOIN ORDERS o ON u.USERID = o.USERID
WHERE MONTHS_BETWEEN(SYSDATE, o.PURCHASEDATE) <= 6;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q6: Display the USERNAME and BIRTHDAY of the user who has the highest friend count. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERNAME, 
        u.BIRTHDAY
FROM USERBASE u
JOIN FRIENDSLIST f ON u.USERID = f.USERID
GROUP BY u.USERID, u.USERNAME, u.BIRTHDAY
ORDER BY COUNT(f.FRIENDID) DESC
FETCH FIRST 1 ROWS ONLY;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q7: Display the PRODUCTNAME, RELEASEDATE, PRICE, and DESCRIPTION for any product found in the WISHLIST table. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  DISTINCT p.PRODUCTNAME, 
        p.RELEASEDATE, 
        p.PRICE, 
        p.DESCRIPTION
FROM PRODUCTLIST p
JOIN WISHLIST w ON p.PRODUCTCODE = w.PRODUCTCODE;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q8: Display the PRODUCTNAME, highest RATING, and number of reviews for each product in the REVIEWS table. Order the results in descending order of the RATING. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  p.PRODUCTNAME, 
        MAX(r.RATING) AS HIGHEST_RATING, 
        COUNT(r.RATING) AS NUM_REVIEWS
FROM PRODUCTLIST p
JOIN REVIEWS r ON p.PRODUCTCODE = r.PRODUCTCODE
GROUP BY p.PRODUCTNAME
ORDER BY HIGHEST_RATING DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q9: Create a view that displays the PRODUCTNAME, GENRE, and RATING for every product with a 5 or a 1 RATING. Order the results in ascending order of the RATING. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_EXTREME_RATINGS AS
SELECT  p.PRODUCTNAME, 
        p.GENRE, 
        r.RATING
FROM PRODUCTLIST p
JOIN REVIEWS r ON p.PRODUCTCODE = r.PRODUCTCODE
WHERE r.RATING IN (1, 5)
ORDER BY r.RATING ASC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q10: Display the count of products ordered, grouped by GENRE. Order the results in alphabetical order of GENRE. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  p.GENRE, 
        COUNT(o.PRODUCTCODE) AS PRODUCTS_ORDERED
FROM PRODUCTLIST p
JOIN ORDERS o ON p.PRODUCTCODE = o.PRODUCTCODE
GROUP BY p.GENRE
ORDER BY p.GENRE ASC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q11: Create a view that displays each PUBLISHER, the average PRICE, and the sum of HOURSPLAYED for their products. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_PUBLISHER_STATS AS
SELECT  p.PUBLISHER, 
        AVG(p.PRICE) AS AVG_PRICE, 
        SUM(ul.HOURSPLAYED) AS TOTAL_HOURS
FROM PRODUCTLIST p
JOIN USERLIBRARY ul ON p.PRODUCTCODE = ul.PRODUCTCODE
GROUP BY p.PUBLISHER;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q12: Display the sum of money spent on products and their corresponding PUBLISHER, from the ORDERS table. Order the results in descending order of the sum of money spent. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  p.PUBLISHER, 
        SUM(o.PRICE) AS TOTAL_SPENT
FROM PRODUCTLIST p
JOIN ORDERS o ON p.PRODUCTCODE = o.PRODUCTCODE
GROUP BY p.PUBLISHER
ORDER BY TOTAL_SPENT DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q13: Display the TICKETID, USERNAME, EMAIL, and ISSUE only for tickets with a STATUS of ‘NEW’ or ‘IN PROGRESS’, sorted by the latest DATEUPDATED. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  s.TICKETID, 
        u.USERNAME, 
        s.EMAIL, 
        s.ISSUE
FROM USERSUPPORT s
LEFT JOIN USERBASE u ON s.EMAIL = u.EMAIL
WHERE s.STATUS IN ('NEW', 'IN PROGRESS')
ORDER BY s.DATEUPDATED DESC;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q14: Display the USERNAME and count of TICKETID that users have submitted for user support. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERNAME, 
        COUNT(s.TICKETID) AS TICKET_COUNT
FROM USERBASE u
JOIN USERSUPPORT s ON u.EMAIL = s.EMAIL
GROUP BY u.USERNAME;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q15: Display the USERID and EMAIL of any user who has submitted a support ticket that used their FIRSTNAME, LASTNAME, or combination of the two in their EMAIL address. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT DISTINCT u.USERID, 
                s.EMAIL
FROM USERBASE u
JOIN USERSUPPORT s ON u.EMAIL = s.EMAIL
WHERE s.EMAIL LIKE '%' || u.FIRSTNAME || '%' 
   OR s.EMAIL LIKE '%' || u.LASTNAME || '%';

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q16: Display the EMAIL address of any user who has a ‘NEW’ or ‘IN PROGRESS’ support ticket STATUS, where the EMAIL is not currently saved in the USERBASE table. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  EMAIL
FROM USERSUPPORT
WHERE STATUS IN ('NEW', 'IN PROGRESS')
  AND EMAIL NOT IN (SELECT EMAIL FROM USERBASE);

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q17: Display the TICKETID, FIRSTNAME, LASTNAME, and USERNAME of any user whose USERNAME is mentioned in the ISSUE of a support ticket. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  s.TICKETID, 
        u.FIRSTNAME, 
        u.LASTNAME, 
        u.USERNAME
FROM USERBASE u
JOIN USERSUPPORT s ON s.ISSUE LIKE '%' || u.USERNAME || '%';

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q18: Display the USERNAME and PASSWORD associated with the EMAIL address provided in the support tickets. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT DISTINCT u.USERNAME, 
                u.PASSWORD
FROM USERBASE u
JOIN USERSUPPORT s ON u.EMAIL = s.EMAIL;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q19: Create a view that displays the USERNAME, DATEASSIGNED, and PENALTY for any user whose PENALTY is not null and the infraction was assigned within the last month. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW V_RECENT_USER_PENALTIES AS
SELECT  u.USERNAME, 
        i.DATEASSIGNED, 
        i.PENALTY
FROM USERBASE u
JOIN INFRACTIONS i ON u.USERID = i.USERID
WHERE i.PENALTY IS NOT NULL
  AND i.DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q20: Display the USERNAME and EMAIL of any user who is at least 18 years old and has not received an infraction within the last 4 months. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  USERNAME, 
        EMAIL
FROM USERBASE
WHERE BIRTHDAY <= ADD_MONTHS(SYSDATE, -216)
  AND USERID NOT IN (
      SELECT USERID 
      FROM INFRACTIONS 
      WHERE DATEASSIGNED >= ADD_MONTHS(SYSDATE, -4)
  );

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q21: Display the USERNAME, DATEASSIGNED, and full guideline name (RULENUM and TITLE with a blank space inbetween) for any user who has violated the community rules. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERNAME, 
        i.DATEASSIGNED, 
        c.RULENUM || ' ' || c.TITLE AS FULL_GUIDELINE
FROM USERBASE u
JOIN INFRACTIONS i ON u.USERID = i.USERID
JOIN COMMUNITYRULES c ON i.RULENUM = c.RULENUM;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q22: Display the USERID, USERNAME, EMAIL, and sum of all SEVERITYPOINTS each user has received. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERID, 
        u.USERNAME, 
        u.EMAIL, 
        SUM(c.SEVERITYPOINT) AS TOTAL_SEVERITYPOINTS
FROM USERBASE u
JOIN INFRACTIONS i ON u.USERID = i.USERID
JOIN COMMUNITYRULES c ON i.RULENUM = c.RULENUM
GROUP BY u.USERID, u.USERNAME, u.EMAIL;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q23: Display the TITLE, DESCRIPTION, and PENALTY for all infractions assigned. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  c.TITLE, 
        c.DESCRIPTION, 
        i.PENALTY
FROM COMMUNITYRULES c
JOIN INFRACTIONS i ON c.RULENUM = i.RULENUM;

/* -------------------------------------------------------------------------------------------------------------------------------------- */
/* Q24: Display the USERNAME and count of infractions for users who have violated the community rules at least 15 times. */
/* -------------------------------------------------------------------------------------------------------------------------------------- */
SELECT  u.USERNAME, 
        COUNT(i.INFRACTIONID) AS INFRACTION_COUNT
FROM USERBASE u
JOIN INFRACTIONS i ON u.USERID = i.USERID
GROUP BY u.USERNAME
HAVING COUNT(i.INFRACTIONID) >= 15;