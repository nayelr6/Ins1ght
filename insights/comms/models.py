from django.db import models
from customer.models import Customer
from specialist.models import Specialist
from userPortrait.models import UserProfile

# Create your models here.
class Comm(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    specialist = models.ForeignKey(Specialist, on_delete=models.CASCADE)
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    text = models.TextField()