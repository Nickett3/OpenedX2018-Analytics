
#enrolls data frame has the raw data
#run_query is a placeholder for whatever R function you will use to run the sql query and fetch the results
#consider using the RODBC package
enrolls = run_query(“
SELECT user_id, course_id
FROM wwc.student_courseenrollment”
#check the data
str(enrolls)
#building the matrix
user.fac = factor(enrolls[,1])
course.fac = factor(enrolls[,2])
cm = sparseMatrix(
	as.numeric(user.fac), as.numeric(course.fac),
	dimnames = list(as.character(levels(user.fac)),
as.character(levels(course.fac))),
  	x = 1)
# calculating co-occurrences (matrix times transpose of matrix)
cv = t(cm) %*% cm
# setting self references
diag(cv) = 0
dict = unique(enrolls[,2])
dict = sort(dict)
#you will want to replace these strings with your own course_ids
typed = c(
 	'UTAustinX/UT.7.01x/3T2014',
 	'UQx/Write101x/3T2014')
input = cv[typed, ]
#calculate the number of co-enrollments for each of our courses
unweighted = colSums(input)
#calculate the weighted # of co-enrollments 
weighted = unweighted/colSums(cv[,names(unweighted)])
#building sorted reference tables for both types 
un_dict = dict[order(unweighted, decreasing = T)]
#un_dict$score = sort(unweighted, decreasing = T)
w_dict = dict[order(weighted,decreasing = T)]
#view the top 6 for each category
head(un_dict)
head(w_dict)


