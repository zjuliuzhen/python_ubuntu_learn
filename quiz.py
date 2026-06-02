class Student:
    # 填空1：定义类变量name，初始值为"请输入姓名"
         
    name = "请输入姓名"
    def __init__(self, scores):
        """
        初始化学生
        scores: 成绩字典，格式 {"语文": 85, "数学": 90, "英语": 78}
        """
        self.scores = scores
        # 填空2：将传入的scores赋值给self.scores
    

    def print_average(self):
        """
        计算并打印平均分
        """
        # 填空3：计算平均分，使用sum和len函数，并赋值给average
        average = sum(self.scores.values()) / len(self.scores)

        print(f"学生 {self.name} 的平均分是: {average:.2f}")


# 主程序
if __name__ == "__main__":
    # 填空4：创建成绩字典
    scores = {"语文": 85, "数学": 90, "英语": 78}
    # 填空5：创建Student对象，传入成绩字典，选择三门或三门以上你最好的课程成绩
    stu = Student(scores)
    # 填空6：设置学生姓名，用你自己的真名
    stu.name = "张三"
    # 填空7：调用打印平均分的方法
    stu.print_average()  
