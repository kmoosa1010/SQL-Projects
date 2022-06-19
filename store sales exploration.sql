SELECT *
FROM store

----Calculate total sales per city and state

SELECT city, state, ROUND(SUM(sales),2)"Total Sales"
FROM store
GROUP BY city, state
ORDER BY "Total Sales" desc;

----calculating total sales of cities  having more sales than Seattle

SELECT city, ROUND(SUM(sales),2)"Total sales"
FROM store
HAVING SUM(sales) >ALL (SELECT SUM(sales)
                                    FROM store
                                    WHERE city ='Seattle'
                                    GROUP BY city )
GROUP BY city

----Calculate sales of product category

SELECT  category, sub_category, ROUND(SUM(sales),2) "Product Category Sales"
FROM store
GROUP BY category, sub_category
ORDER BY "Product Sales" desc;

--Count total quantity of purchased product in each sub- category

SELECT productid, productname,sub_category, COUNT(quantity)"Total quantity sold"
FROM store
GROUP BY ROLLUP(productid,productname,sub_category)
ORDER BY sub_category,"Total quantity sold" desc;

SELECT category ,sub_category, COUNT(quantity)"Total quantity sold"
FROM store
GROUP BY ROLLUP(category,sub_category)
ORDER BY category,sub_category,"Total quantity sold" desc;

--Calculate the total number of customers per city

SELECT city, COUNT(DISTINCT customerid)"Total customers per city"
FROM store
GROUP BY city
ORDER BY "Total customers per city" desc;

---calculating segment with more sales

SELECT segment, ROUND(SUM(sales),2)"Highest sales"
FROM store
GROUP BY  segment
ORDER BY "Highest sales" desc;

---creating view for cities with more sales than Seattle

CREATE VIEW city_sales
AS SELECT city, ROUND(SUM(sales),2)"Total sales"
FROM store
HAVING SUM(sales) >ALL (SELECT SUM(sales)
                                    FROM store
                                    WHERE city ='Seattle'
                                    GROUP BY city )
GROUP BY city

SELECT *
FROM city_sales

---creating view for quantity of product sold
CREATE VIEW product_subcategory
AS SELECT productid, productname,sub_category, COUNT(quantity)"Total quantity sold"
FROM store
GROUP BY ROLLUP(productid,productname,sub_category)
ORDER BY sub_category,"Total quantity sold" desc;

SELECT productname, sub_category, "Total quantity sold"
FROM product_subcategory
