from rest_framework.serializers import ModelSerializer, CharField
from .models import Group
from userPortrait.views import ProfileSerializer
from userPortrait.models import UserProfile
from groupmember.models import GroupMember

class GroupSerializer(ModelSerializer):
    owner = ProfileSerializer(many=False, read_only=True)
    members = ProfileSerializer(many=True, read_only=True)
    owner_id = CharField(source="owner.id", write_only=True)

    class Meta:
        model = Group
        fields = ["id", "name", "description","members", "owner", "owner_id"]

    def create(self, validated_data):
        owner = UserProfile.objects.get(pk=validated_data["owner"]["id"])
        name = validated_data["name"]
        desc = validated_data["description"]

        instance = Group.objects.create(owner=owner, name=name, description=desc)
        GroupMember.objects.create(profile=owner, group=instance, rank=2)
        return instance
    
    def update(self, instance, validated_data):
        if validated_data:
            group = instance
            if "name" in validated_data:
                group.name = validated_data["name"]
            if "description" in validated_data:
                group.description = validated_data["description"]
            if "owner" in validated_data:
                current_owner = GroupMember.objects.get(profile=group.owner)
                current_owner.rank = 1
                owner = UserProfile.objects.get(pk=validated_data["owner"]["id"])
                group.owner = owner
            
            group.save()

        return instance