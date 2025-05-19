SELECT 
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = TRUE OR p.is_a_goal = TRUE OR p.is_emergency_plan = TRUE THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_fixed_investment = TRUE OR p.is_managed_portfolio = TRUE OR p.is_a_fund = TRUE THEN p.id END) AS investment_count,
    COALESCE(SUM(s.confirmed_amount), 0) AS total_deposits
FROM 
    users_customuser u
    INNER JOIN savings_savingsaccount s ON u.id = s.owner_id
    INNER JOIN plans_plan p ON s.plan_id = p.id
WHERE 
    s.confirmed_amount > 0
    AND s.transaction_status = 'successful'
GROUP BY 
    u.id, u.name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = TRUE OR p.is_a_goal = TRUE OR p.is_emergency_plan = TRUE THEN p.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_fixed_investment = TRUE OR p.is_managed_portfolio = TRUE OR p.is_a_fund = TRUE THEN p.id END) > 0
ORDER BY 
    total_deposits DESC;