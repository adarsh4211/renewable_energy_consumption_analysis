//drop integration PBI_Integration

CREATE database tableau;

create schema tableau_Data;

create table tableau_dataset (
Household_ID	string,Region	string,Country	string,Energy_Source	string,
Monthly_Usage_kWh	float,Year	int,Household_Size	int,Income_Level	string,
Urban_Rural	string,Adoption_Year	int,Subsidy_Received	string,Cost_Savings_USD float

);


select * from tableau_dataset;

//drop database tableau;

create stage tableau.tableau_Data.tableau_stage
url = 's3://awstableau.project'
storage_integration = tableau_Integration

//desc stage s1

//drop stage s1;


copy into tableau_dataset 
from @tableau_stage
file_format = (type=csv field_delimiter=',' skip_header=1 )
on_error = 'continue'

list @s1


//Selecting distinct regions
select region, count(*) from tableau_dataset group by region;

//Creating replica/copy of original dataset to make further changes without distubing original dataset

create table energy_consumption as
select * from tableau_dataset;

select * from energy_consumption;
select * from tableau_dataset;

//Selecting distinct Income levels
select income_level, count(*) from energy_consumption group by income_level;

//Selecting distinct regions
select region, count(*) from energy_consumption group by region;

//Increasing the energy consumption of Low income by 10% , Middle by 20% and High by 30%

//Update 1
update energy_consumption 
set monthly_usage_kwh = monthly_usage_kwh*1.1
where income_level = 'Low';

//Update 2
update energy_consumption 
set monthly_usage_kwh = monthly_usage_kwh*1.2
where income_level = 'Middle';

//Update 3
update energy_consumption 
set monthly_usage_kwh = monthly_usage_kwh*1.1
where income_level = 'High';

//We have to reduce the value of Cost_saving_USD by 
//10% for Low income 20% for Middle income and 30% for High income

//Update 1
update energy_consumption
set cost_savings_usd = cost_savings_usd*0.9
where income_level = 'Low';

//Update 2
update energy_consumption
set cost_savings_usd = cost_savings_usd*0.8
where income_level = 'Middle';

//Update 3
update energy_consumption
set cost_savings_usd = cost_savings_usd*0.7
where income_level = 'High';
