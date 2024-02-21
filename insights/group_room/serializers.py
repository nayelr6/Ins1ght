from .models import Group_room
from rest_framework.serializers import ModelSerializer, CharField
# from userPortrait.views import ProfileSerializer
# from userPortrait.models import UserProfile
from groupmember.models import GroupMember
from rest_framework import serializers
from groupmember.serializers import GroupMemberSerializer
from group.serializers import GroupSerializer
from group.models import Group
from room_member.models import RoomMember

class GroupRoomSerializer(serializers.ModelSerializer):
    # room_name= CharField(max_length= 100)
    owner = GroupMemberSerializer(many=False, read_only=True)
    owner_id = CharField(source="owner.id", write_only=True)
    group = GroupSerializer(many=False, read_only=True)
    group_id = CharField(source="group.id", write_only=True)

    class Meta:
        model= Group_room
        fields = ('id', 'group', 'room_name', 'owner', 'owner_id', 'group_id')


    def create(self, validated_data):
        print(validated_data)
        room_name = validated_data["room_name"]
        room_owner = GroupMember.objects.get(pk=validated_data["owner"]["id"])
        group_id = validated_data["group"]["id"]
        group = Group.objects.get(pk=group_id)

        instance = Group_room.objects.create(room_name=room_name, owner=room_owner, group=group)
        RoomMember.objects.create(member=room_owner, group_room=instance)

        return instance
    
    def update(self, instance, validated_data):
        if validated_data:
            group_room= instance
            if "room_name" in validated_data:
                group_room.room_name = validated_data["room_name"]
        
            group_room.save()
            
        return instance 

            

            






    

