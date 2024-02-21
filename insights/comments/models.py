from django.db import models
from post.models import Post
from userPortrait.models import UserProfile

class PostComments(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    text = models.CharField(max_length=50)
    posted_by = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    date_posted = models.DateTimeField(auto_now_add=True)
    likes = models.IntegerField(default=0)
    dislikes = models.IntegerField(default=0)


class CommentLikes(models.Model):
    comment = models.ForeignKey(PostComments, on_delete=models.CASCADE)
    rated_by = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    liked = models.BooleanField(default=False)
    disliked = models.BooleanField(default=True)