USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
ALTER TABLE actor
ADD actor_name VARCHAR(60) NOT NULL;

UPDATE actor 
SET 
    actor.actor_name = CONCAT(actor.first_name, ' ', actor.last_name);
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
-- What is one query would you use to obtain this information?
SELECT 
    *
FROM
    actor
WHERE
    first_name LIKE '%JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%Li%'
ORDER BY last_name , first_name;
    
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');



-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
--  so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB,
-- as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;

SELECT 
    *
FROM
    actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
    last_name, COUNT(*) AS Count
FROM
    actor
GROUP BY last_name;

SELECT 
    last_name, COUNT(*) AS Count
FROM
    actor
GROUP BY last_name
HAVING (Count > 1);

UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all!
--     In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT 
    staff.first_name, staff.last_name, address.address
FROM
    staff
        JOIN
    address ON staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT 
    s.first_name, s.last_name, p.amount
FROM
    staff s
        JOIN
    (SELECT 
        staff_id, SUM(amount) AS Amount
    FROM
        payment
    WHERE
        payment_date LIKE '2005-08%'
    GROUP BY staff_id) p ON s.staff_id = p.staff_id;
 
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT 
    film.title, COUNT(film_actor.actor_id)
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    inventory.film_id, COUNT(film.film_id)
FROM
    inventory
        JOIN
    film ON inventory.film_id = film.film_id
WHERE
    film.title = 'Hunchback Impossible';
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
--     List the customers alphabetically by last name:
SELECT 
    customer.first_name, customer.last_name, SUM(payment.amount)
FROM
    payment
        INNER JOIN
    customer ON payment.customer_id = customer.customer_id
GROUP BY customer.last_name
ORDER BY customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles
SELECT 
    title
FROM
    film
WHERE
    language_id = (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English')
        AND title LIKE 'K%'
        OR title LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    actor.first_name, actor.last_name
FROM
    actor
WHERE
    actor.actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- of all Canadian customers. Use joins to retrieve this information.
SELECT 
    c.first_name, c.last_name, c.email
FROM
    customer c
        JOIN
    address a ON a.address_id = c.address_id
        JOIN
    city ON a.city_id = city.city_id
        JOIN
    country ON country.country_id = city.country_id
WHERE
    country.country = 'Canada';
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT 
    title
FROM
    film
        JOIN
    film_category ON film.film_id = film_category.film_id
        JOIN
    category ON film_category.category_id = category.category_id
WHERE
    category.name = 'Family';
-- 7e. Display the most frequently rented movies in descending order.
SELECT 
    COUNT(rental.rental_id), title
FROM
    film
        JOIN
    inventory ON film.film_id = inventory.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY 1 DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    SUM(payment.amount), staff.store_id
FROM
    payment
        JOIN
    rental ON payment.rental_id = rental.rental_id
        JOIN
    staff ON rental.staff_id = staff.staff_id
        JOIN
    store ON store.store_id = staff.store_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT 
    store.store_id, city.city, country.country
FROM
    store
        JOIN
    address ON store.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    COUNTRY ON country.country_id = city.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT 
    category.name, SUM(payment.amount)
FROM
    category
        JOIN
    film_category USING (category_id)
        JOIN
    Film USING (film_id)
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
        JOIN
    payment USING (rental_id)
GROUP BY category.name
ORDER BY 2 DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres_by_gross_revenue AS
    SELECT 
        category.name, SUM(payment.amount)
    FROM
        category
            JOIN
        film_category USING (category_id)
            JOIN
        Film USING (film_id)
            JOIN
        inventory USING (film_id)
            JOIN
        rental USING (inventory_id)
            JOIN
        payment USING (rental_id)
    GROUP BY category.name
    ORDER BY 2 DESC
    LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT 
    *
FROM
    top_five_genres_by_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres_by_gross_revenue;