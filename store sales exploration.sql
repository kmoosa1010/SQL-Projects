

/*
In this project, i used a retail store sales data to demonstrate data exploration.
i am to calculate measures such as sales, total quantity sold, and create views
*/

--Calculate total sales per city and state

SELECT city, state, ROUND(SUM(sales),2)"Total Sales"
FROM store
GROUP BY city, state
ORDER BY "Total Sales" desc;

---calculate total sales of cities  having more sales than Seattle

SELECT city, ROUND(SUM(sales),2)"Total sales"
FROM store
HAVING SUM(sales) >ALL (SELECT SUM(sales)
                                    FROM store
                                    WHERE city ='Seattle'
                                    GROUP BY city )
GROUP BY city

--Calculate sales of product category

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

--calculate segment with more sales

SELECT segment, ROUND(SUM(sales),2)"Highest sales"
FROM store
GROUP BY  segment
ORDER BY "Highest sales" desc;

--create view for cities with more sales than Seattle

CREATE VIEW city_sales
AS SELECT city, ROUND(SUM(sales),2)"Total sales"
FROM store
HAVING SUM(sales) >ALL (SELECT SUM(sales)
                                    FROM store
                                    WHERE city ='Seattle'
                                    GROUP BY city )
GROUP BY city;


--create view for quantity of product sold
CREATE VIEW product_subcategory
AS SELECT productid, productname,sub_category, COUNT(quantity)"Total quantity sold"
FROM store
GROUP BY ROLLUP(productid,productname,sub_category)
ORDER BY sub_category,"Total quantity sold" desc;

