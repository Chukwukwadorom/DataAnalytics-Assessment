Question 1:

Approach:
Join the users_customuser, savings_savingsaccount, and plans_plan tables to link customers to their funded plans.

Categorize plans as savings or investments using appropriate fields from plans_plan.

Count distinct plans for savings_count and investment_count using conditional aggregation.

Sum funded amounts for total_deposits.

Filter customers with at least one savings and one investment plan using a HAVING clause.

Sort results by total_deposits in descending order.

challenges:
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



