from django.db import models
from services.models import Service
from specialist.models import Specialist
from userPortrait.models import UserProfile

# Create your models here.
class Customer(models.Model):
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    specialist = models.ForeignKey(Specialist, on_delete=models.CASCADE)
    profile = models.ForeignKey(UserProfile, on_delete=models.CASCADE)