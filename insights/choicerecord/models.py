from django.db import models
from polls.models import Question, Choice
from groupmember.models import GroupMember

# Create your models here.

# question (question id)

# choice (choice id)

# groupmember (id)


class ChoiceRecord(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice = models.ForeignKey(Choice, on_delete=models.CASCADE)
    owner = models.ForeignKey(GroupMember, on_delete=models.CASCADE)

    def __str__(self):
        return f"Choice: {self.choice.choice_text}, Member: {self.member}"


# get method, filterwith group member ---> polls app
