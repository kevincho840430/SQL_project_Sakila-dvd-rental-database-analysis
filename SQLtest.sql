

/*Question 1
We want to understand more about the movies that families are watching.
The following categories are considered family
movies: Animation, Children, Classics, Comedy, Family and Music.
*/
WITH t1 AS (
    SELECT
        f.title,
        c.name,
        r.rental_id
    FROM
        Category c
        JOIN film_category fc ON c.category_id = fc.category_id
        JOIN film f ON fc.film_id = f.film_id
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE
        c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    GROUP BY
        1,
        2,
        3
)
SELECT
    title,
    name,
    count(*) AS rental_count
FROM
    t1
GROUP BY
    1,
    2
ORDER BY
    3 DESC;



/*
Question 2
Now we need to know how the length of rental duration of these
family-friendly movies compares to the duration that all movies
are rented for. Can you provide a table with the movie titles
and divide them into 4 levels (first_quarter, second_quarter,
third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also
indicate the category that these family-friendly movies fall into
*/

SELECT
    f.title,
    c.name,
    f.rental_duration,
    NTILE(4)
    OVER (
    ORDER BY
        f.rental_duration) AS standard_quartile
FROM
    film_category fc
    JOIN category c ON c.category_id = fc.category_id
    JOIN film f ON f.film_id = fc.film_id
WHERE
    c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY
    3;



/*
Question 3
Finally, provide a table with the family-friendly film category, each of the
quartiles, and the corresponding count of movies within each combination
of film category for each corresponding rental duration category.
The resulting table should have three columns:
Category
Rental length category
count
*/
WITH t1 AS (
    SELECT
        f.title,
        c.name,
        f.rental_duration,
        NTILE(4)
        OVER (
        ORDER BY
            f.rental_duration) AS standard_quartile
    FROM
        film_category fc
        JOIN category c ON c.category_id = fc.category_id
        JOIN film f ON f.film_id = fc.film_id
    WHERE
        c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))
SELECT
    t1.name, t1.standard_quartile, COUNT(*) AS count
FROM
    t1
GROUP BY
    1,
    2
ORDER BY
    1,
    2;



/*
Question 4:
We want to find out how the two stores compare in their
count of rental orders during every month for all the
years we have data for. Write a query that returns the
store ID for the store, the year and month and the number
of rental orders each store has fulfilled for that month.
Your table should include a column for each of the following:
year, month, store ID
and count of rental orders fulfilled during that month.
*/
SELECT
    DATE_PART('MONTH', r.rental_date) Rental_month,
    DATE_PART('YEAR', r.rental_date) Rental_year,
    sto.store_id,
    count(*) Count_rental
FROM
    rental r
    JOIN payment p ON p.rental_id = r.rental_id
    JOIN staff sta ON sta.staff_id = p.staff_id
    JOIN store sto ON sto.store_id = sta.store_id
GROUP BY
    1,
    2,
    3
ORDER BY
    4 desc;
