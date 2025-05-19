Question 1:

Approach:

1. Join the users_customuser, savings_savingsaccount, and plans_plan tables to link customers to their funded plans.

2. Categorize plans as savings or investments using appropriate fields from plans_plan.

3. Count distinct plans for savings_count and investment_count using conditional aggregation.

4. Sum funded amounts for total_deposits.

5. Filter customers with at least one savings and one investment plan using a HAVING clause.

6. Sort results by total_deposits in descending order.

Challenges:

Plan Type Definitions was ambigous.

it had 4 distinct values: 1,2,3,4 without an easy way knowing what each number meant.
overcoming challenges:

I wrote this query: SELECT DISTINCT plan_type_id, name, description
                    FROM plans_plan
                    WHERE plan_type_id IS NOT NULL;
then  i infered the meaning of each values from the descriptions. i arrived at this:
plan_type_id = 1: Mixed savings and investments.

plan_type_id = 2: Investments (‘Fixed Investment’).

plan_type_id = 3: Savings (‘Vacation’, ‘Home’).

plan_type_id = 4: Savings (‘Emergency’).





Question 4:

Approach:

1. Join users_customuser and savings_savingsaccount.

2. Calculate tenure_months using date difference.

3. Count valid transactions (confirmed_amount > 0, transaction_status = 'successful').

4. Compute avg_profit_per_transaction as 0.001 × average confirmed_amount.

5. Estimate CLV per formula.

6. Filter non-zero tenure/transactions.

7. Sort by estimated_clv descending.




Question 3:

Approach:
1. Identify Active Savings/Investment Plans
    Filter plans_plan for:

    is_deleted = FALSE (not deleted)

    is_archived = FALSE (not archived)

    Either is_regular_savings = TRUE (savings) or is_managed_portfolio = TRUE (investment)

    Classify plan type using CASE:

    sql
    CASE 
        WHEN is_regular_savings THEN 'Savings'
        WHEN is_managed_portfolio THEN 'Investment'
    END AS type

2. Find Last Successful Inflow Transaction per Plan
    Query savings_savingsaccount for:

    transaction_status = 'successful' (only completed transactions)

    amount > 0 (only deposits, not withdrawals)

    Use MAX(transaction_date) to get the most recent activity.

3. Calculate Inactivity Period
    Join active plans with their last transaction dates.

    Compute inactivity days:

    sql
    CURRENT_DATE - last_transaction_date AS inactivity_days
    Flag accounts where:

    No transactions ever (last_transaction_date IS NULL)

    No transactions in >365 days (inactivity_days > 365)

4. Return Results
    Columns:

    plan_id, owner_id, type (Savings/Investment)

    last_transaction_date, inactivity_days

    Sort by inactivity_days DESC (most inactive first).






Question 2:

Approach:
1. Data Collection & Monthly Aggregation
    Extracted transaction data by joining users_customuser and savings_savingsaccount
    Filtered for successful transactions only (transaction_status = 'successful')

2. Customer-Level Metrics Calculation
    Calculated average monthly transactions per customer (AVG(transaction_count))
    Categorized customers based on business rules:

    High Frequency: ≥10 transactions/month

    Medium Frequency: 3-9 transactions/month

    Low Frequency: ≤2 transactions/month

3. Final Aggregation & Reporting
    Counted customers in each category
    Calculated average transactions per month per segment
    Ordered results logically (High → Medium → Low)



