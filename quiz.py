class Student:
    # 填空1：定义类变量name，初始值为"请输入姓名"
    name = "请输入姓名"
    def __init__(self, scores):
        self.scores = scores
        

    def print_average(self):
        average = sum(self.scores.values())/len(self.scores.values())
        print(f"学生 {self.name}的平均分是:{average:.2f}")



# 主程序
if __name__ == "__main__":
    score_dict = {"语文":85,"数学":90,"英语":78}
    stu = Student(score_dict)
    stu.name ="huangyibin"
    stu.print_average()
    
    # 填空4：创建成绩字典
    
    # 填空5：创建Student对象，传入成绩字典，选择三门或三门以上你最好的课程成绩
    
    # 填空6：设置学生姓名，用你自己的真名
    
    # 填空7：调用打印平均分的方法