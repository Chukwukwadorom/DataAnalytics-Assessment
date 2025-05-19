SELECT 
    u.id AS customer_id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.date_joined, '2025-05-19') AS tenure_months,
    COUNT(*) AS total_transactions,
    ROUND(
        (COUNT(*) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, '2025-05-19'), 0)) * 
        12 * 
        (0.001 * AVG(s.confirmed_amount)),
        2
    ) AS estimated_clv
FROM 
    users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    LEFT JOIN plans_plan p ON s.plan_id = p.id
WHERE 
    s.confirmed_amount > 0
    AND s.transaction_status = 'successful'
    AND p.name NOT LIKE 'DELETEDW%'
GROUP BY 
    u.id, u.name
HAVING 
    tenure_months > 0
    AND total_transactions > 0
ORDER BY 
    estimated_clv DESC;