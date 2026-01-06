SELECT
    name,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.customer_id = customers.id
    ) AS order_count
FROM customers;
