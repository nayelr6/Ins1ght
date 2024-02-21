from rest_framework.serializers import ModelSerializer, CharField, BooleanField
from .models import GroupMember
from userPortrait.models import UserProfile
from group.models import Group
from userPortrait.serializers import ProfileSerializer
from group.serializers import GroupSerializer
from rest_framework.response import Response
from grouprequest.models import GroupRequest

class GroupMemberSerializer(ModelSerializer):
    profile = ProfileSerializer(many=False, read_only=True)
    group = GroupSerializer(many=False, read_only=True)
    profile_id = CharField(source="profile.id")
    group_id = CharField(source="group.id")
    direct = BooleanField(default=False, write_only=True)

    class Meta:
        model = GroupMember
        fields = ["id", "profile", "group", "rank", "profile_id", "group_id", "direct"]

    def create(self, validated_data):
        print(validated_data)
        profile_id = validated_data["profile"]["id"]
        group_id = validated_data["group"]["id"]
        profile = UserProfile.objects.get(pk=profile_id)
        group = Group.objects.get(pk=group_id)

        queryset = GroupMember.objects.filter(group=group, profile=profile)
        if(len(queryset) == 0):
            instance = GroupMember.objects.create(group=group, profile=profile)
            if( ('direct' in validated_data) and (validated_data['direct'] == True)):
                pass
            else:
                user_request = GroupRequest.objects.get(group=group, sender=profile)
                user_request.delete()
            return instance
        else:
            return Response({"Error": "You have already sent a request ot this group"})