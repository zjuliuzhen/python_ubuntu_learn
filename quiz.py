class Student:
    def __init__(self, name, scores):
        self.name = name
        self.scores = scores

    def print_average(self):
        avg = sum(self.scores.values()) / len(self.scores)
        print(f"学生 {self.name} 的平均分是: {avg:.2f}")

if __name__ == "__main__":
    score_dict = {"语文": 85, "数学": 90, "英语": 78}
    stu = Student("liuchang", score_dict)
    stu.print_average()

