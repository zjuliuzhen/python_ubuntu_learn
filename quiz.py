
class Student:
    # 类变量，所有Student对象共享
    name = "请输入姓名"

    # 初始化方法，这里才是self和scores的合法位置
    def __init__(self, scores):
        # 给实例绑定scores属性
        self.scores = scores

    def print_average(self):
        # 计算平均分
        total = sum(self.scores.values())
        count = len(self.scores)
        average = total / count
        print(f"学生 {self.name} 的平均分是: {average:.2f}")

# 主程序入口
if __name__ == "__main__":
    # 定义成绩字典
    scores_dict = {"语文": 85, "数学": 90, "英语": 78}
    # 创建Student对象
    student1 = Student(scores_dict)
    # 设置学生姓名
    student1.name = "包耀维"
    # 调用方法打印平均分
    student1.print_average()
