from rest_framework.serializers import ModelSerializer, CharField
from .models import Specialist
from userPortrait.models import UserProfile
from services.models import Service
from userPortrait.serializers import ProfileSerializer
from services.serializers import ServiceSerializer
from rest_framework.response import Response

class SpecialistSerializer(ModelSerializer):
    profile_id = CharField(source="profile.id", write_only=True)
    service_id = CharField(source="service.id", write_only=True)
    profile = ProfileSerializer(many=False, read_only=True)
    service = ServiceSerializer(many=False, read_only=True)

    class Meta:
        model = Specialist
        fields = ["id", "profile", "service", "profile_id", "service_id"]

    def create(self, validated_data):
        profile_id = validated_data["profile"]["id"]
        service_id = validated_data["service"]["id"]
        
        profile = UserProfile.objects.get(pk=profile_id)
        service = Service.objects.get(pk=service_id)

        queryset = Specialist.objects.filter(profile=profile, service=service)
        if(len(queryset) == 0):
            instance = Specialist.objects.create(profile=profile, service=service)

            return instance
        else:
            return Response({"Error": "You have already added this person"})