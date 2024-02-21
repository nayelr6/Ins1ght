from django.db import models
from userPortrait.models import UserProfile

# Create your models here.


class Group(models.Model):
    name = models.CharField(max_length=25)
    description = models.TextField()
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)

    def __str__(self):
        return self.name
