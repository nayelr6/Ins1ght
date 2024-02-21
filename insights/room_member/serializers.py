from rest_framework.serializers import ModelSerializer, CharField
from .models import GroupMember
from userPortrait.models import UserProfile
from group.models import Group
from userPortrait.serializers import ProfileSerializer
from group.serializers import GroupSerializer
from rest_framework.response import Response
from grouprequest.models import GroupRequest
from group_room.serializers import GroupRoomSerializer 
from room_member.models import RoomMember 
from group_room.models import Group_room
from groupmember.serializers import GroupMemberSerializer

class RoomMemberSerializer(ModelSerializer):
    member = GroupMemberSerializer(many=False, read_only=True)
    group_room= GroupRoomSerializer(many=False, read_only=True)
    member_id = CharField(source="member.id", write_only=True)
    room_id = CharField(source="room.id", write_only=True)

    class Meta:
        model = RoomMember
        fields = ["id", "member", "group_room", "member_id", "room_id"]


    def create(self, validated_data):
        member_id = validated_data["member"]["id"]
        room_id= validated_data["room"]["id"]
        member = GroupMember.objects.get(pk=member_id)
        room= Group_room.objects.get(pk= room_id)

        instance = RoomMember.objects.create(member=member, group_room=room)
        return instance