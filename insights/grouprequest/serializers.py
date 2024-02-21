from rest_framework.serializers import ModelSerializer, CharField
from .models import GroupRequest
from group.serializers import GroupSerializer
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile
from group.models import Group
from rest_framework.response import Response
from groupmember.models import GroupMember

class GroupRequestSerializer(ModelSerializer):
    sender = ProfileSerializer(many=False, read_only=True)
    group = GroupSerializer(many=False, read_only=True) 
    sender_id = CharField(source="sender.id", write_only=True)
    group_id = CharField(source="group.id", write_only=True)

    class Meta:
        model = GroupRequest
        fields = ["id", "sender", "group", "sender_id", "group_id"]

    def create(self, validated_data):
        sender_id = validated_data["sender"]["id"]
        group_id = validated_data["group"]["id"]

        sender = UserProfile.objects.get(pk=sender_id)
        group = Group.objects.get(pk=group_id)

        queryset = GroupRequest.objects.filter(sender=sender, group=group)
        queryset2 = GroupMember.objects.filter(profile=sender, group=group)
        if(len(queryset) == 0 and len(queryset2) == 0):
            instance = GroupRequest.objects.create(sender=sender, group=group)
            return instance
        else:
            return Response({"Error": "You have already sent a request ot this group"})