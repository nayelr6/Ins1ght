from django.db import models
from groupmember.models import GroupMember
from group_room.models import Group_room

class RoomMember(models.Model):
    member = models.ForeignKey(GroupMember, on_delete=models.CASCADE)
    group_room= models.ForeignKey(Group_room, on_delete=models.CASCADE)