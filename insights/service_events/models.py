from django.db import models
from services.models import Service

# Create your models here.
class ServiceEvent(models.Model):
    title = models.CharField(max_length=80)
    description = models.TextField()
    location = models.CharField(max_length=80)
    start_date = models.CharField(max_length=20)
    end_date = models.CharField(max_length=20)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)