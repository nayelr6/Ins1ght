from django.db import models
from userPortrait.models import UserProfile
from services.models import Service

# Create your models here.
class Specialist(models.Model):
    profile = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)