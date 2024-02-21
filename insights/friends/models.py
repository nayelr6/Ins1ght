from django.db import models
from userPortrait.models import UserProfile

# Create your models here.
class Friends(models.Model):
    friend_1 = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name="friend_1")
    friend_2 = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name="friend_2")
    blocked = models.BooleanField(default=False)