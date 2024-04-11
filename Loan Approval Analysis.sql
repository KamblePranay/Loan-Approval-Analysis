use ETL5;
select*from `loan analysis`;

--                                               Loan Approval Analysis 

desc `Loan Analysis`;

-- Borrower Analysis:

-- 1.What is the distribution of loans across genders?
select Gender,count(*) as Loan_count 
from `Loan Analysis` 
group by Gender order by Loan_count desc; 

-- 2. what Loan approved rate ?
select Loan_status,count(loan_status) as `Number of Approved Loan Application` from `loan analysis` 
group by Loan_status having count(distinct(loan_status)); -- to see approved loan and non approved loan 

select round(389/563*100) as Loan_approved_rate;  -- 389 was number of application approved 
                                                  -- 563 was Total number of application 
                                                  
-- 3.Does the number of dependents affect the loan amount applicants qualify for?
select Dependents,Avg(loanAmount) as Avergae_Loan_Amount from `loan Analysis` 
group by Dependents order by Dependents desc;

-- 4.How does educational background influence loan approval?
select education,count(*) as `Total Application`,count( case when Loan_status = 'Y' then 1 end) 
as Approved_Loans from `loan Analysis` group by education order by `Total Application` desc; 
 
-- 5.Are self-employed individuals more likely to be approved for loans?
select self_employed,count(*) as `total application`,count( case when Loan_status = 'Y' then 1 end)
as Approved_loans from `Loan Analysis` group by self_employed order by `Total Application` desc;

-- Financial Analysis:

-- 6.What is the average income of loan applicants?
select round(Avg(ApplicantIncome)) as `avg income of loan Applicant` from `loan Analysis`; -- Remember that the Income are in Lakhs

-- 7.Does the ratio of applicant income to loan amount affect approval rates?
select case when LoanAmount = 0 then 0 -- avoide devision by zero for loans with no Amount
else round(applicantIncome/LoanAmount,2) end -- calcuating Loan Amount Ratio (round to 2 decimel)
as Income_to_ratio , count(*) as `Total Application`,
Count(case when Loan_status = 'Y' then 1 end) as Approved_Loans from `loan Analysis` 
group by Income_to_ratio order by Income_to_ratio ASC;

/* 8.How does the presence of a co-applicant with a high income influence loan approval? */
select case when CoapplicantIncome is null then 'No Co-applicant'
       else 'Has Co-applicant' end as Coapplicant_Presence,
  count(*) as Total_Applications,
  count(case when Loan_Status = 'Y' then 1 end) as Approved_Loans
from `loan Analysis`
group by Coapplicant_Presence
having Coapplicant_Presence <> 'No Co-applicant' -- Exclude rows with no co-applicant (might skew data)
order by Coapplicant_Presence;

-- 9.What is the most common loan amount requested?
select LoanAmount,count(LoanAmount) as `Most Common Loan Amount` from `Loan Analysis` 
group by LoanAmount having count(distinct(LoanAmount)) order by `Most Common Loan Amount` desc; 

-- Loan Performance Analysis:

-- 10.Does the property area impact the likelihood of loan approval? (assuming higher value properties are in better areas)
select Property_Area,count( case when Loan_status = 'Y' then 1 end ) as Loan_approved from `Loan Analysis` 
group by Property_Area order by Loan_approved desc;

