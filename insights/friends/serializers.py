from rest_framework.serializers import ModelSerializer, CharField
from .models import Friends
from userPortrait.models import UserProfile
from friend_request.models import FriendRequest
from userPortrait.serializers import ProfileSerializer

class FriendSerializer(ModelSerializer):
    friend1_id = CharField(source = 'friend_1.id')
    friend2_id = CharField(source = 'friend_2.id')
    friend_1 = ProfileSerializer(many=False, read_only=True)
    friend_2 = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = Friends
        fields = ["id", "friend_1", "friend_2", "blocked","friend1_id", "friend2_id"]
        depth = 2       

    def create(self, validated_data):
        # print(validated_data)
        f1 = UserProfile.objects.get(pk=validated_data['friend_1']['id'])
        f2 = UserProfile.objects.get(pk=validated_data['friend_2']['id'])

        instance = Friends.objects.create(friend_1 = f1, friend_2 = f2)
        Friends.objects.create(friend_1 = f2, friend_2 = f1)
        del_req1 = FriendRequest.objects.get(sender=f2, receiver=f1)
        del_req1.delete()

        return instance