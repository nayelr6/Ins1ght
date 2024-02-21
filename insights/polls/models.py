from django.db import models
from group.models import Group
from userPortrait.models import UserProfile
from pytz import timezone, datetime
from groupmember.models import GroupMember

# class Poll(models.Model):
#     group = models.ForeignKey(Group, on_delete=models.CASCADE)
#     owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
#     choice1 = models.CharField(max_length=100, default="")
#     choice2 = models.CharField(max_length=100, default="")
#     choice3 = models.CharField(max_length=100, default="")
#     choice4 = models.CharField(max_length=100, default="")
#     finished = models.BooleanField(default=False)


#     def __str__(self):
#         return self.choices
class Question(models.Model):
    group = models.OneToOneField(Group, on_delete=models.CASCADE)
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField("date published")

    def __str__(self):
        return self.question_text

    # def was_published_recently(self):
    # now = timezone.now()
    # return now - datetime.timedelta(days=1) <= self.pub_date <= now


class Choice(models.Model):
    # group_member = models.ForeignKey(GroupMember, on_delete=models.CASCADE, null=True)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    def __str__(self):
        return self.choice_text
