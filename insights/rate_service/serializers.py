from rest_framework.serializers import ModelSerializer, CharField
from .models import RateService
from services.serializers import ServiceSerializer
from services.models import Service
from userPortrait.models import UserProfile
from userPortrait.serializers import ProfileSerializer

class RateServiceSerializer(ModelSerializer):
    service_id = CharField(source="service.id", write_only=True)
    profile_id = CharField(source="profile.id", write_only=True)
    profile = ProfileSerializer(many=False, read_only=True)
    service = ServiceSerializer(many=False, read_only=True)

    class Meta:
        model = RateService
        fields = ["id", "profile", "service", "profile_id", "service_id", "rating", "review"]

    def create(self, validated_data):
        service_id = validated_data["service"]["id"]
        profile_id = validated_data["profile"]["id"]

        service = Service.objects.get(pk=service_id)
        profile = UserProfile.objects.get(pk=profile_id)
        rating = validated_data["rating"]
        review = validated_data["review"]

        instance = RateService.objects.create(rating=rating, review=review, service=service, profile=profile)
        return instance