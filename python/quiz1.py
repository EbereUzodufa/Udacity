# studentName = input('Enter names:')
# studentAssignment = eval(input('Enter Assignment:'))
# studentGrade = eval(input('Enter Grades:'))
# remainder = studentGrade + (studentAssignment*2)

studentName = input('Enter names:').title().split(",")
studentAssignment = (input('Enter Assignment:')).title().split(",")
studentGrade = (input('Enter Grades:')).title().split(",")

message = "Hi {},\n\nThis is a reminder that you have {} assignments left to \
submit before you can graduate. You're current grade is {} and can increase \
to {} if you submit all assignments before the due date.\n\n"

for name, assignment, grade in zip(studentName,studentAssignment,studentGrade):
	print (message.format(name, assignment, grade, int(grade) + int(assignment)*2))