
select *
from student_assessment
select *
from assessments


-- Importing the code_module and weight columns into the studentent_assessment table
Select student_assessment.id_assessment,  date_submitted, is_banked, score, assessments.code_module, assessments.weight
From student_assessment
Left Outer Join assessments
On student_assessment.id_assessment = assessments.id_assessment
Order by id_assessment desc

Drop Table If Exists updated_student_assessment
Create Table updated_student_assessment (
id_assessment int,
id_student int,
date_submitted int,
is_banked int,
score int,
code_module varchar(100),
weight int,
)

-- Importing the data into the updated_studentent_assessment table
Insert into updated_student_assessment
Select student_assessment.id_assessment, id_student, date_submitted, is_banked, score, assessments.code_module, assessments.weight
From student_assessment
Left Outer Join assessments
On student_assessment.id_assessment =assessments.id_assessment
Order by id_assessment

Select * 
From updated_student_assessment
Order by id_assessment


--Calculating the weight_sums for the GPA
Select code_module, SUM(weight) as weight_sums
From assessments
Where code_module is not null
Group by code_module


Drop Table If Exists calculated_weight_sums
Create Table calculated_weight_sums (
code_module varchar(100),
weight_sums int,
)

--Importing the data into the calculated_weight_sums table
Insert into calculated_weight_sums
Select code_module, SUM(weight) as weight_sums
From assessments
Where code_module is not null
Group by code_module


Select *
From calculated_weight_sums


--Importing the weight_sums column into the updated_students_assessment table
Select id_assessment, id_student, date_submitted, is_banked, score, updated_student_assessment.code_module, weight, calculated_weight_sums.weight_sums
From updated_student_assessment
Left Outer Join calculated_weight_sums
On calculated_weight_sums.code_module = updated_student_assessment.code_module
Order by id_assessment


--Computing the product of the student's scores X the weight_sums
Select id_assessment, id_student, date_submitted, is_banked, score, code_module, weight, (score*weight) as scoreXweight
From updated_student_assessment 


Drop Table If Exists updated_student_assessment2
Create Table updated_student_assessment2 (
id_assessment int,
id_student int,
date_submitted int,
is_banked int,
score int,
code_module varchar(100),
weight int,
weight_sums int,
scoreXweight float,
)

-- Importing the data into the updated_studentent_assessment2 table
Insert into updated_student_assessment2
Select id_assessment, id_student, date_submitted, is_banked, score, updated_student_assessment.code_module, weight, calculated_weight_sums.weight_sums, (score*weight) as scoreXweight
From updated_student_assessment
Left Outer Join calculated_weight_sums
On calculated_weight_sums.code_module = updated_student_assessment.code_module
Order by id_assessment

Select * 
From updated_student_assessment2


--Computing Students GPAs which is scoreXweight divided by weight_sums
Select id_assessment, id_student, date_submitted, is_banked, score, code_module, weight, weight_sums, scoreXweight, (scoreXweight/weight_sums) as GPA
From updated_student_assessment2 


Drop Table If Exists updated_student_assessment3
Create Table updated_student_assessment3 (
id_assessment int,
id_student int,
date_submitted int,
is_banked int,
score int,
code_module varchar(100),
weight int,
weight_sums int,
scoreXweight float,
GPA float,
)

-- Importing the data into the updated_studentent_assessment3 table
Insert into updated_student_assessment3
Select id_assessment, id_student, date_submitted, is_banked, score, code_module, weight, weight_sums, scoreXweight, (scoreXweight/weight_sums) as GPA
From updated_student_assessment2 
Order by id_assessment


Select *
From updated_student_assessment3
Order by id_assessment


--Computing the GPAs for each student in each course
Select id_student, code_module, Sum(scoreXweight/weight_sums) as student_module_gpa
From updated_student_assessment3
Group by id_student, code_module
Order by code_module


--Count of final result grouped by Region
Select region, final_result, count(final_result) as count_of_final_result
From student_info
Where region is not null
Group by region, final_result
Order by region, final_result asc 


--Count of Female and Male
Select gender, count(gender)
From student_info
Where gender is not null
Group by gender


--Count of final result grouped by Gender
Select gender, final_result, count(final_result) as count_of_final_result
From student_info
Where gender is not null
Group by gender, final_result
Order by gender, final_result asc 


--Count of final result grouped by Disability
Select disability, final_result, count(final_result) as count_of_final_result
From student_info
Where disability is not null
Group by disability, final_result
Order by disability, final_result asc 


--Count of final result grouped by Highest Education
Select highest_education, final_result, count(final_result) as count_of_final_result
From student_info
Where highest_education is not null
Group by highest_education, final_result
Order by highest_education, final_result asc 


--Count of final result grouped by Age-band
Select age_band, final_result, count(final_result) as count_of_final_result
From student_info
Where age_band is not null
Group by age_band, final_result
Order by age_band, final_result asc 
