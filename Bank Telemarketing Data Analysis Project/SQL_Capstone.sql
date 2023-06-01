create schema bank;
use bank;
SELECT * FROM bank.bank_data;
ALTER TABLE `bank`.`bank_data` 
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT FIRST,     -- adding id column
ADD PRIMARY KEY (`id`);


-- Write an SQL query to identify the age group which is taking more loan and then calculate the sum of all of the balances of it?
select age, sum(balance), loan, max(X) as max_loan      -- maximum of counted loan as X and sum of balances grouped by age.
from (select age, balance, loan,count(loan) as X 
from bank_data where loan='yes'group by age) as L;      -- subquery to get count of loan, where loan = yes.


-- Write an SQL query to calculate for each record if a loan has been taken less than 100, then calculate the fine of 15% of the current balance and create a temp table and then add the amount for each month from that temp table?

select month, balance, X<100 as Loan_taken               -- results for loan taken are 1 where counted loan where it's less than 100 and 0 where loan greater than 100. 
from (select month, balance, loan,count(loan) as X 
from bank_data where loan='yes' group by month) as L;    -- subquery to get count of loan, where loan = yes.

create temporary table bank_temp                        -- creating temporary table from bank_data with column month and fine of balance's 15%.
select month,balance * 0.15 as fine 
from bank_data 
group by month;
select * from bank_temp;

select T1.month as month,T1.balance+T2.fine as total_amount  -- adding fine from temp table to main balance in the main table
from bank_data as T1  
left join bank_temp as T2  
on T1.month = T2.month;


-- Write an SQL query to calculate each age group along with each department's highest balance record?
select age, job, sum(balance) from bank_data                -- highest balance according tom each age group
group by age
order by age;
select job, age, sum(balance) from bank_data                -- highest balance according tom each department
group by job
order by job;


-- Write an SQL query to find the secondary highest education, where duration is more than 150. The query should contain only married people, and then calculate the interest amount? (Formula interest => balance 15%).
select education, duration, marital, balance * 0.15 as interest  -- selecting education, duration, marital and interest 15% of balance
from bank_data
where education= 'secondary' and  marital= 'married'             -- filtering with where clause education as secondary, marital as married 
having duration >150;                                            -- with having clause for duration more than 150.

-- Write an SQL query to find which profession has taken more loan along with age?
select job,age,loan, max(X) as max_loan                         -- maximum of counted loan as X and sum of balances grouped by job.
from (select job,age,balance, loan,count(loan) as X 
from bank_data where loan='yes' group by job)as L;             -- subquery to get count of loan, where loan = yes.

-- Write an SQL query to calculate each month's total balance and then calculate in which month the highest amount of transaction was performed?
select month, sum(balance)                                    -- selecting month and sum of all balance
from bank_data
group by month                                                -- and grouped by month to get all months total balance
order by month;

select month, max(X) as max_balance                           -- using max to get maximum of sum of balance as X         
from (select month,sum(balance) as X                          -- assigning sum of balances as X 
from bank_data 
group by month) as P;                                         -- group by month