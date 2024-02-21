from django.db import models
from group.models import Group
from groupmember.models import GroupMember

class Group_room(models.Model):
    group= models.ForeignKey(Group, on_delete=models.CASCADE)
    room_name= models.CharField(max_length= 100)
    owner = models.ForeignKey(GroupMember, on_delete=models.CASCADE)