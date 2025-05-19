WITH monthly_transactions AS (
    -- Calculate transactions per customer per month (using EXTRACT/YEAR/MONTH)
    SELECT
        u.id AS customer_id,
        EXTRACT(YEAR FROM s.transaction_date) AS year,
        EXTRACT(MONTH FROM s.transaction_date) AS month,
        COUNT(*) AS transaction_count
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE
        s.transaction_status = 'successful'
    GROUP BY
        u.id, 
        EXTRACT(YEAR FROM s.transaction_date),
        EXTRACT(MONTH FROM s.transaction_date)
),

customer_metrics AS (
    -- Calculate average monthly transactions per customer
    SELECT
        customer_id,
        AVG(transaction_count) AS avg_transactions_per_month,
        CASE
            WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transaction_count) >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        monthly_transactions
    GROUP BY
        customer_id
)

-- Aggregate results by frequency category
SELECT
    frequency_category,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM
    customer_metrics
GROUP BY
    frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;