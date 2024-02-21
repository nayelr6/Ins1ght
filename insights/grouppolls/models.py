from django.db import models
from group.models import Group
from userPortrait.models import UserProfile

# Create your models here.
class Question(models.Model):
    group = models.OneToOneField(Group, on_delete=models.CASCADE)
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField(auto_now_add=True)
    finished = models.BooleanField(default=False)


    # def was_published_recently(self):
    # now = timezone.now()
    # return now - datetime.timedelta(days=1) <= self.pub_date <= now


class Choice(models.Model):
    # group_member = models.ForeignKey(GroupMember, on_delete=models.CASCADE, null=True)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)