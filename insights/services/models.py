from django.db import models
from userPortrait.models import UserProfile
from django.db.models import Avg

# Create your models here.
class Service(models.Model):
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    option = models.CharField(max_length=25)
    name = models.CharField(max_length=70)
    description = models.TextField()

    @property
    def average_rating(self):
        if hasattr(self, '_average_rating'):
            return self._average_rating
        return self.reviews.aggregate(Avg('rating'))