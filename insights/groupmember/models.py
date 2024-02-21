from django.db import models
from userPortrait.models import UserProfile
from group.models import Group

# Create your models here.
class GroupMember(models.Model):
    profile = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)
    rank = models.IntegerField(default=0)