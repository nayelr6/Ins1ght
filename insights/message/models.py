from django.db import models
from userPortrait.models import UserProfile
from group.models import Group

# class Message(models.Model):
#     group = models.ForeignKey(Group, on_delete=models.CASCADE)
#     sender = models.ForeignKey(
#         UserProfile, related_name='writer', on_delete=models.CASCADE)
#     recipient = models.ForeignKey(
#         UserProfile, related_name='recipient', on_delete=models.CASCADE)
#     content = models.TextField()
#     image = models.ImageField(upload_to='message_images', null=True)
#     date_sent = models.DateTimeField(auto_now_add=True)

#     class Meta:
#         ordering = ["-date_sent"]

#     def __str__(self):
#         return self.content


class Message(models.Model):
    owner = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    recipient = models.ForeignKey(
        UserProfile, related_name='recipient', on_delete=models.CASCADE)
    content = models.TextField()
    image = models.ImageField(upload_to='message_images', null=True)
    date_sent = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-date_sent"]

    def __str__(self):
        return self.content
