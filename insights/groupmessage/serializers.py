from rest_framework.serializers import ModelSerializer, CharField, ImageField
from .models import GroupMessage
from userPortrait.serializers import ProfileSerializer
from group.serializers import GroupSerializer
from django.http import QueryDict
from userPortrait.models import UserProfile
from group.models import Group


class GroupMessageSerializer(ModelSerializer):
    owner_id = CharField(source="owner.id", write_only=True)
    owner = ProfileSerializer(many=False, read_only=True)
    group = GroupSerializer(many=False, read_only=True)
    group_id = CharField(source="group.id", write_only=True)
    username = CharField(source="owner.user.username", read_only=True)
    image = ImageField(required=False)

    class Meta:
        model = GroupMessage
        fields = ['id', 'username', 'owner', 'owner_id', 'group', 'group_id',
                  'content', 'image', 'date_sent']

    def create(self, validated_data):
        print(validated_data)
        if 'image' not in validated_data:
            validated_data['image'] = None

        owner = UserProfile.objects.get(pk=validated_data['owner']['id'])
        print('Owner', owner)
        group = Group.objects.get(pk=validated_data["group"]["id"])
        groupmessage = GroupMessage.objects.create(
            owner=owner, group=group, content=validated_data['content'], image=validated_data["image"])
        groupmessage.save()

        return groupmessage

    def update(self, instance, validated_data):
        if 'content' in validated_data:
            instance.content = validated_data['content']
        if 'image' in validated_data:
            instance.image = validated_data['image']
        instance.save()
        return instance
