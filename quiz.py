class Student:
    name = "请输入姓名"

    def __init__(self, scores):
        self.scores = scores

    def print_average(self):
        average = sum(self.scores.values()) / len(self.scores.values())
        print(f"学生 {self.name} 的平均分是: {average:.2f}")

if __name__ == "__main__":
    score_dict = {"语文": 85, "数学": 90, "英语": 78}
    stu = Student(score_dict)
    stu.name = "meilin"
    stu.print_average()
