class Student:
    # 填空1：定义类变量name，初始值为"请输入姓名"
         
    name = "QiGong"
    def __init__(self, scores):
        self.scores = scores
    def print_average(self):
        average =   sum(self.scores.values())/len(self.scores)
        print(f"学生 {self.name}的平均分是：{average:.2f}")
if  __name__ == "__main__":
    scores_dict =   {"语文":    98, "数学": 99,  "英语":    93,  "物理":    90}
    stu =   Student(scores_dict)
    stu.name    =   "QiGong"
    stu.print_average()
