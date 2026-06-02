class Student:
	name =   "请输入姓名"
	def __init__(self, scores):
		self.scores	=	scores
	def print_average(self):
        	average	=   sum(self.scores.values())/len(self.scores.values())
        	print(f"学生 {self.name} 的平均分是: {average:.2f}")
if __name__ == "__main__":
    scores  =   {"语文": 90, "数学": 95, "英语": 88}
    student =   Student(scores)
    student.name    =   "yangxiangcheng"
    student.print_average()
