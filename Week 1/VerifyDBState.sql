-- Name: Kenneth Irving
-- 1. Check which users have access to the database
SELECT  USER_ID, 
        USERNAME, 
        CREATED, 
        PASSWORD_CHANGE_DATE 
FROM USER_USERS;

-- 2. Check what tables are present in the database
SELECT * FROM USER_TABLES;

-- 3. Examine the design of each table
DESCRIBE ORDERS;
DESCRIBE PRODUCTLIST;
DESCRIBE REVIEWS;
DESCRIBE STOREFRONT;
DESCRIBE USERBASE;
DESCRIBE USERLIBRARY;

-- 4. Display all data currently present in the database
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTLIST;
SELECT * FROM REVIEWS;
SELECT * FROM STOREFRONT;
SELECT * FROM USERBASE;
SELECT * FROM USERLIBRARY;

-- 5. Check what constraints are present in the database
SELECT  TABLE_NAME, 
        CONSTRAINT_NAME, 
        CONSTRAINT_TYPE, 
        STATUS 
FROM USER_CONSTRAINTS;

-- 6. Check what views are present in the database
SELECT  VIEW_NAME, 
        TEXT 
FROM USER_VIEWS;

-- 7. Display every USERNAME in alphabetical order
SELECT USERNAME 
FROM USERBASE 
ORDER BY USERNAME ASC;

-- 8. Display details of any user who has a yahoo email address
SELECT  FIRSTNAME, 
        LASTNAME,
        USERNAME, 
        PASSWORD, 
        EMAIL 
FROM USERBASE 
WHERE EMAIL LIKE '%@yahoo.com%';

-- 9. Display USERNAME, BIRTHDAY, and WALLETFUNDS of any user with less than $25
SELECT  USERNAME, 
        BIRTHDAY, 
        WALLETFUNDS
FROM USERBASE 
WHERE WALLETFUNDS < 25;

-- 10. Display USERID and PRODUCTCODE of any user with more than 100 HOURSPLAYED
SELECT  USERID, 
        PRODUCTCODE 
FROM USERLIBRARY 
WHERE HOURSPLAYED > 100;

-- 11. Display PRODUCTCODE of any game that has less than 10 HOURSPLAYED
SELECT PRODUCTCODE 
FROM USERLIBRARY 
WHERE HOURSPLAYED < 10;

-- 12. Display every unique PUBLISHER
SELECT DISTINCT PUBLISHER 
FROM PRODUCTLIST;

-- 13. Display PRODUCTNAME, RELEASEDATE, PUBLISHER, and GENRE, sorted by GENRE
SELECT  PRODUCTNAME, 
        RELEASEDATE, 
        PUBLISHER, 
        GENRE 
FROM PRODUCTLIST 
ORDER BY GENRE ASC;

-- 14. Display PRODUCTCODE and PUBLISHER of any product in the 'Strategy' GENRE
SELECT  PRODUCTCODE, 
        PUBLISHER 
FROM PRODUCTLIST 
WHERE GENRE = 'Strategy';

-- 15. Display PRODUCTCODE, DESCRIPTION, and PRICE for any product > $25, sorted by descending PRICE
SELECT  p.PRODUCTCODE, 
        DESCRIPTION, 
        s.PRICE 
FROM PRODUCTLIST p
JOIN STOREFRONT s ON p.PRODUCTCODE = s.PRODUCTCODE
WHERE s.PRICE > 25 
ORDER BY s.PRICE DESC; 

-- 16. Display INVENTORYID and PRICE of all products in STOREFRONT, sorted by ascending PRICE
SELECT  INVENTORYID, 
        PRICE 
FROM STOREFRONT 
ORDER BY PRICE ASC;

-- 17. Display PRODUCTCODE and REVIEW of any product with a RATING of 1
SELECT  PRODUCTCODE, 
        REVIEW 
FROM REVIEWS 
WHERE RATING = 1;

-- 18. Display PRODUCTCODE and REVIEW of any product with a RATING of 4 or higher
SELECT  PRODUCTCODE,
        REVIEW 
FROM REVIEWS 
WHERE RATING >= 4;

-- 19. Display every unique USERID from users who have placed an order
SELECT DISTINCT USERID 
FROM ORDERS;

-- 20. Display all order data, sorted by the earliest PURCHASEDATE
SELECT * FROM ORDERS 
ORDER BY PURCHASEDATE ASC;