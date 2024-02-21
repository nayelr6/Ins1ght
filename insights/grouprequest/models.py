from django.db import models
from userPortrait.models import UserProfile
from group.models import Group

# Create your models here.
class GroupRequest(models.Model):
    sender = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    group = models.ForeignKey(Group, on_delete=models.CASCADE)