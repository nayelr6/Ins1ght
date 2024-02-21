from rest_framework.serializers import ModelSerializer, CharField
from .models import Customer
from userPortrait.serializers import ProfileSerializer
from specialist.serializers import SpecialistSerializer
from services.serializers import ServiceSerializer
from services.models import Service
from userPortrait.models import UserProfile
from specialist.models import Specialist
from serviceRequests.models import ServiceRequests

class CustomerSerializer(ModelSerializer):
    service_id = CharField(source="service.id", write_only=True)
    specialist_id = CharField(source="specialist.id", write_only=True)
    profile_id = CharField(source="profile.id", write_only=True)
    service = ServiceSerializer(many=False, read_only=True)
    specialist = SpecialistSerializer(many=False, read_only=True)
    profile = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = Customer
        fields = ["id", "service", "specialist", "profile", "service_id", "specialist_id", "profile_id"]

    def create(self, validated_data):
        service_id = validated_data["service"]["id"]
        specialist_id = validated_data["specialist"]["id"]
        profile_id = validated_data["profile"]["id"]

        service = Service.objects.get(pk=service_id)
        specialist = Specialist.objects.get(pk=specialist_id)
        profile = UserProfile.objects.get(pk=profile_id)

        instance = Customer.objects.create(service=service, specialist=specialist, profile=profile)
        del_req = ServiceRequests.objects.get(service=service, sender=profile)
        del_req.delete()

        return instance