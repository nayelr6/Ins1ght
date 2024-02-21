from django.forms import ValidationError
from rest_framework.serializers import ModelSerializer, CharField, ImageField
from .models import Message
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile
from group.serializers import GroupSerializer

# class MessageSerializer(ModelSerializer):
#     group = GroupSerializer(many=False, read_only=True)
#     group_id = CharField(source="group.id", write_only=True)
#     sender = ProfileSerializer(many=False, read_only=True)
#     sender_id = CharField(source="sender.id", write_only=True)
#     recipient = ProfileSerializer(many=False, read_only=True)
#     recipient_id = CharField(source="recipient.id", write_only=True)
#     username = CharField(source="sender.user.username", read_only=True)
#     image = ImageField(required=False)

#     class Meta:
#         model = Message
#         fields = ('id', 'group', 'group_id', 'username', 'sender', 'sender_id', 'recipient', 'recipient_id',
#                   'content',  'image', 'date_sent')

#     def create(self, validated_data):
#         if 'image' not in validated_data:
#             validated_data["image"] = None
#         group = Group.objects.get(pk=validated_data["group"]["id"])
#         sender = UserProfile.objects.get(pk=validated_data["sender"]["id"])
#         recipient = UserProfile.objects.get(
#             pk=validated_data["recipient"]["id"])
#         message = Message.objects.create(
#             group=group, sender=sender, recipient=recipient, content=validated_data['content'], image=validated_data["image"])
#         message.save()
#         return message

#     def update(self, instance, validated_data):
#         if 'content' in validated_data:
#             instance.content = validated_data['content']
#         else:
#             raise ValidationError("No changes to be made")
#         instance.save()
#         return instance

#     def delete(self, instance):
#         instance.delete()


class MessageSerializer(ModelSerializer):
    owner_id = CharField(source="owner.id", write_only=True)
    owner = ProfileSerializer(many=False, read_only=True)
    recipient_id = CharField(source="recipient.id", write_only=True)
    recipient = ProfileSerializer(many=False, read_only=True)
    username = CharField(source="owner.user.username", read_only=True)
    image = ImageField(required=False)

    class Meta:
        model = Message
        fields = ('id', 'username', 'owner', 'owner_id', 'recipient', 'recipient_id',
                  'content',  'image', 'date_sent')

    def create(self, validated_data):
        print(validated_data)
        if 'image' not in validated_data:
            validated_data["image"] = None
        owner = UserProfile.objects.get(pk=validated_data["owner"]["id"])
        print(owner)
        recipient = UserProfile.objects.get(
            pk=validated_data["recipient"]["id"])
        print(recipient)
        message = Message.objects.create(
            owner=owner, recipient=recipient, content=validated_data['content'], image=validated_data["image"])
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
