from django.db import models
# from groupmember.models import GroupMember
from group_room.models import Group_room
from room_member.models import RoomMember

# Create your models here.
class RoomMessage(models.Model):
    owner = models.ForeignKey(RoomMember, on_delete=models.CASCADE)
    room = models.ForeignKey(Group_room, on_delete=models.CASCADE)
    content = models.TextField()
    image = models.ImageField(upload_to='room_message_images', null=True)
    date_sent = models.DateTimeField(auto_now_add=True)