class Student:
    name="daishibing"
    def __init__(self,scores):
        self.scores = scores
    def print_average(self):
        average=sum(self.scores.values())/len(self.scores.values())
        print(f"student{self.name}:{average:.2f}")
if __name__ == "__main__":
    score_dict={"yuwen":85,"shuxue":90,"yingyu":78}
    stu=Student(score_dict)
    stu.name="daishibing"
    stu.print_average()
