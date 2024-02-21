from django.db import models
from grouppolls.models import Question, Choice
from groupmember.models import GroupMember

# Create your models here.
class ChoiceRecord(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice = models.ForeignKey(Choice, on_delete=models.CASCADE)
    owner = models.ForeignKey(GroupMember, on_delete=models.CASCADE)

    def __str__(self):
        return f"Choice: {self.choice.choice_text}, Member: {self.member}"