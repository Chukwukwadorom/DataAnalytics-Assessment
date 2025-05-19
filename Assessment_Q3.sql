WITH 
-- Get all active plans (savings or investments)
active_plans AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings THEN 'Savings'
            WHEN p.is_managed_portfolio THEN 'Investment'
            ELSE 'Other'
        END AS plan_type
    FROM plans_plan p
    WHERE 
        p.is_deleted = FALSE 
        AND p.is_archived = FALSE
        AND (p.is_regular_savings OR p.is_managed_portfolio)
),

-- Get the last transaction date for each plan
last_transactions AS (
    SELECT 
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE 
        s.transaction_status = 'successful'
        AND s.amount > 0  -- Inflow transactions only
    GROUP BY s.plan_id
)

-- Final result: inactive accounts
SELECT 
    ap.plan_id,
    ap.owner_id,
    ap.plan_type AS type,
    lt.last_transaction_date,
    CURRENT_DATE - lt.last_transaction_date AS inactivity_days
FROM active_plans ap
LEFT JOIN last_transactions lt ON ap.plan_id = lt.plan_id
WHERE 
    -- Accounts with no transactions at all
    lt.last_transaction_date IS NULL 
    OR 
    -- Accounts with no transactions in the last 365 days
    (CURRENT_DATE - lt.last_transaction_date) > 365
ORDER BY inactivity_days DESC;