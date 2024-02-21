from django.forms import ValidationError
from rest_framework.serializers import ModelSerializer, CharField, ImageField
from .models import RoomMessage
from room_member.models import RoomMember
from room_member.serializers import RoomMemberSerializer
from group_room.models import Group_room
from group_room.serializers import GroupRoomSerializer

class RoomMessageSerializer(ModelSerializer):
    owner_id = CharField(source="owner.id", write_only=True)
    owner = RoomMemberSerializer(many=False, read_only=True)
    room_id = CharField(source="room.id", write_only=True)
    room = GroupRoomSerializer(many=False, read_only=True)
    username = CharField(source="owner.member.user.username", read_only=True)
    image = ImageField(required=False)

    class Meta:
        model = RoomMessage
        fields = ('id', 'username', 'owner', 'owner_id', 'room', 'room_id',
                  'content',  'image', 'date_sent')

    def create(self, validated_data):
        print(validated_data)
        if 'image' not in validated_data:
            validated_data["image"] = None
        owner = RoomMember.objects.get(pk=validated_data["owner"]["id"])
        print(owner)
        room = Group_room.objects.get(
            pk=validated_data["room"]["id"])
        print(room)
        message = RoomMessage.objects.create(
            owner=owner, room=room, content=validated_data['content'], image=validated_data["image"])
        message.save()  # Save the message object
        return message

    def update(self, instance, validated_data):
        if 'content' in validated_data:
            instance.content = validated_data['content']
        else:
            raise ValidationError("No changes to be made")
        instance.save()
        return instance

    def delete(self, instance):
        instance.delete()