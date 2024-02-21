from rest_framework.serializers import ModelSerializer, CharField
from .models import ServiceEvent
from services.serializers import ServiceSerializer
from services.models import Service

class EventSerializer(ModelSerializer):
    service_id = CharField(source="service.id", write_only=True)
    service = ServiceSerializer(many=False, read_only=True)

    class Meta:
        model = ServiceEvent
        fields = ["id", "title", "description", "location", "start_date", "end_date", "service", "service_id"]

    def create(self, validated_data):
        service_id = validated_data["service"]["id"]

        service = Service.objects.get(pk=service_id)
        title = validated_data["title"]
        description = validated_data["description"]
        start_date = validated_data["start_date"]
        end_date = validated_data["end_date"]
        location = validated_data["location"]

        instance = ServiceEvent.objects.create(title=title, description=description, start_date=start_date, end_date=end_date, location=location, service=service)
        return instance