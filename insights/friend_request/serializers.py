from rest_framework.serializers import ModelSerializer, CharField
from .models import FriendRequest
from userPortrait.models import UserProfile
from userPortrait.serializers import ProfileSerializer

class FriendRequestSerializer(ModelSerializer):
    sender_id = CharField(source='sender.id')
    receiver_id = CharField(source='receiver.id')
    sender = ProfileSerializer(many=False, read_only=True)
    receiver = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = FriendRequest
        fields =["id", "sender", "receiver", "sender_id", "receiver_id"]
        depth = 2

    def create(self, validated_data):
        sender = UserProfile.objects.get(pk=validated_data["sender"]["id"])
        receiver = UserProfile.objects.get(pk=validated_data["receiver"]["id"])
        instance = FriendRequest.objects.create(sender=sender, receiver=receiver)
        return instance