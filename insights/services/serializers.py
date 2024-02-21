from rest_framework.serializers import ModelSerializer, CharField, SerializerMethodField
from .models import Service
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile
from django.db.models import Avg

class ServiceSerializer(ModelSerializer):
    owner_id = CharField(source="owner.id", write_only=True)
    owner = ProfileSerializer(many=False, read_only=True)

    average_rating = SerializerMethodField(read_only=True)
    def get_average_rating(self, obj):
        return obj.average_rating

    class Meta:
        model = Service
        fields = ["id", "owner", "owner_id", "name", "option", "description", "average_rating"]

    def create(self, validated_data):
        owner_id = validated_data["owner"]["id"]
        owner = UserProfile.objects.get(pk=owner_id)

        instance = Service.objects.create(owner=owner, option=validated_data["option"], description=validated_data["description"], name=validated_data["name"])
        return instance