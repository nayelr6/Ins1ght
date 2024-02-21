from django.db import models
from userPortrait.models import UserProfile

# Create your models here.
class Post(models.Model):
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    caption = models.TextField(null=True)
    image = models.ImageField(upload_to='post_images', null=True)
    date_posted = models.DateTimeField(auto_now_add=True)
    likes = models.IntegerField(default=0)
    dislikes = models.IntegerField(default=0)

    class Meta:
        ordering = ["-date_posted"]

class PostLikes(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    rated_by = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    liked = models.BooleanField(default=False)
    disliked = models.BooleanField(default=True)
