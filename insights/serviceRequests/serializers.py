from rest_framework.serializers import ModelSerializer, CharField
from .models import ServiceRequests
from userPortrait.serializers import ProfileSerializer
from services.serializers import ServiceSerializer
from userPortrait.models import UserProfile
from services.models import Service
from rest_framework.response import Response

class ServiceRequestSerializer(ModelSerializer):
    sender_id = CharField(source="sender.id", write_only=True)
    service_id = CharField(source="service.id", write_only=True)
    sender = ProfileSerializer(many=False, read_only=True)
    service = ServiceSerializer(many=False, read_only=True)

    class Meta:
        model = ServiceRequests
        fields = ["id", "sender", "service", "description", "sender_id", "service_id"]

    def create(self, validated_data):
        sender_id = validated_data["sender"]["id"]
        service_id = validated_data["service"]["id"]
        sender = UserProfile.objects.get(pk=sender_id)
        service = Service.objects.get(pk=service_id)

        queryset = ServiceRequests.objects.filter(sender=sender, service=service)
        if(len(queryset) == 0):
            instance = ServiceRequests.objects.create(sender=sender, service=service, description=validated_data["description"])
            return instance
        else:
            return Response({"Error": "You have already added this person"})
        