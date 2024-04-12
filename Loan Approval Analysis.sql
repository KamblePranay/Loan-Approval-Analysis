use ETL5;
select*from `loan analysis`;

--                                               Loan Approval Analysis

/* Objective : to find the Casue of Loan Application and how does it affect the Market */  

desc `Loan Analysis`;

-- Root Cause Analysis 

-- 1. Is there a gender bias in loan approvals?
-- approval rate affection
select gender,count(*) as `total application`,count( case when Loan_status='Y' then 1 end) as Approved_Loan, 
       round((SUM(case when Loan_Status = 'Y' then 1 else 0 end) / COUNT(*))* 100, 2) as Approval_Rate 
       from `loan Analysis` group by Gender order by Gender;
-- Investigate Rejection Reasons by Gender        
select Gender, Loan_Status, count(*) as count
from `loan Analysis`
where Loan_Status <> 'Y'
group by Gender, Loan_Status
order by Gender, Loan_Status;

/* Analyze approval rates by gender. Investigate reasons for rejections specific to genders.*/

-- 2. Does marital status affect loan eligibility?

-- Compare approval rates for married vs. unmarried applicants
select Married, count(*) AS Total_Applicants,
       sum(case when Loan_Status = 'Y' then 1 else 0 end) as Approved_Count,
       round((sum(case when Loan_Status = 'Y' then 1 else 0 end) / COUNT(*)) * 100, 2) as Approval_Rate
from `loan Analysis`
group by Married
order by Married;  

-- Investigate if marital status is correlated with income or creditworthiness.
select Married, avg(ApplicantIncome) AS Average_Income, AVG(Credit_History) AS Average_Credit_Score
from `loan Analysis`
group by Married
order by Married;
/* Compare approval rates for married vs. unmarried applicants. Investigate if marital status is correlated with
 income or creditworthiness. */
 
-- 3. How does the number of dependents impact loan approval and amount?
select Dependents, count(*) as Total_Applicants,
       sum(case when Loan_Status = 'Y' then 1 else 0 end) as Approved_Count,
       round((sum(case when Loan_Status = 'Y' then 1 else 0 end) / COUNT(*)) * 100, 2) as Approval_Rate,
       avg(LoanAmount) as Average_Loan_Amount
from `loan analysis`
group by Dependents
order by Dependents;

-- 4. Are self-employed applicants at a disadvantage?
select*from `loan Analysis`;
select self_employed,count(*) as `Total Application`,
count( case when Loan_status='Y' then 1 end) as `Loan Approved`,
count( case when Loan_status='N' then 0 end) as `Loan Not Approved`
from `loan Analysis` group by  self_employed having `Total Application`;

-- Customer Analysis:

-- 5.What is the distribution of loans across genders?
select Gender,count(*) as Loan_count 
from `Loan Analysis` 
group by Gender order by Loan_count desc; 

-- 6. what Loan approved rate ?
select Loan_status,count(loan_status) as `Number of Approved Loan Application` from `loan analysis` 
group by Loan_status having count(distinct(loan_status)); -- to see approved loan and non approved loan 

select round(389/563*100) as Loan_approved_rate;  -- 389 was number of application approved 
                                                  -- 563 was Total number of application 
                                                  
-- 7.Does the number of dependents affect the loan amount applicants qualify for?
select Dependents,Avg(loanAmount) as Avergae_Loan_Amount from `loan Analysis` 
group by Dependents order by Dependents desc;

-- 8.How does educational background influence loan approval?
select education,count(*) as `Total Application`,count( case when Loan_status = 'Y' then 1 end) 
as Approved_Loans from `loan Analysis` group by education order by `Total Application` desc; 
 
-- 9.Are self-employed individuals more likely to be approved for loans?
select self_employed,count(*) as `total application`,count( case when Loan_status = 'Y' then 1 end)
as Approved_loans from `Loan Analysis` group by self_employed order by `Total Application` desc;

-- Financial Analysis:

-- 10.What is the average income of loan applicants?
select round(Avg(ApplicantIncome)) as `avg income of loan Applicant` from `loan Analysis`; -- Remember that the Income are in Lakhs

-- 11.Does the ratio of applicant income to loan amount affect approval rates?
select case when LoanAmount = 0 then 0 -- avoide devision by zero for loans with no Amount
else round(applicantIncome/LoanAmount,2) end -- calcuating Loan Amount Ratio (round to 2 decimel)
as Income_to_ratio , count(*) as `Total Application`,
Count(case when Loan_status = 'Y' then 1 end) as Approved_Loans from `loan Analysis` 
group by Income_to_ratio order by Income_to_ratio ASC;

/* 12.How does the presence of a co-applicant with a high income influence loan approval? */
select case when CoapplicantIncome is null then 'No Co-applicant'
       else 'Has Co-applicant' end as Coapplicant_Presence,
  count(*) as Total_Applications,
  count(case when Loan_Status = 'Y' then 1 end) as Approved_Loans
from `loan Analysis`
group by Coapplicant_Presence
having Coapplicant_Presence <> 'No Co-applicant' -- Exclude rows with no co-applicant (might skew data)
order by Coapplicant_Presence;

-- 13.What is the most common loan amount requested?
select LoanAmount,count(LoanAmount) as `Most Common Loan Amount` from `Loan Analysis` 
group by LoanAmount having count(distinct(LoanAmount)) order by `Most Common Loan Amount` desc; 

-- Loan Performance Analysis:

-- 14.Does the property area impact the likelihood of loan approval? (assuming higher value properties are in better areas)
select Property_Area,count( case when Loan_status = 'Y' then 1 end ) as Loan_approved from `Loan Analysis` 
group by Property_Area order by Loan_approved desc;

