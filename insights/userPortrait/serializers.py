from rest_framework.serializers import ModelSerializer, CharField
from .models import UserProfile
from django.contrib.auth.models import User
from login.serializers import UserSerializer

class ProfileSerializer(ModelSerializer):
    user_id = CharField(source="user.id")
    user = UserSerializer(many=False, read_only=True)

    class Meta:
        model = UserProfile
        fields = ["id", "picture", "user", "user_id"]
        depth = 2

    def create(self, validated_data):

        user = User.objects.get(pk=validated_data['user']['id'])
        if 'picture' in validated_data:
            new_profile = UserProfile.objects.create(
                user=user, picture=validated_data["picture"])
            return new_profile
        else:
            new_profile = UserProfile.objects.create(user=user)
            return new_profile

    def update(self, instance, validated_data):
        user_data = validated_data.get('user')
        if user_data:
            user = instance.user
            user.username = user_data.get('username', user.username)
            user.email = user_data.get('email', user.email)
            user.save()

        instance.picture = validated_data.get('picture', instance.picture)
        instance.save()
        return instance
