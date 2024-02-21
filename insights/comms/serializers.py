from rest_framework.serializers import ModelSerializer, CharField
from .models import Comm
from customer.serializers import CustomerSerializer
from specialist.serializers import SpecialistSerializer
from customer.models import Customer
from specialist.models import Specialist
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile

class CommSerializer(ModelSerializer):
    customer_id = CharField(source="customer.id", write_only=True)
    specialist_id = CharField(source="specialist.id", write_only=True)
    owner_id = CharField(source="owner.id", write_only=True)
    customer = CustomerSerializer(many=False, read_only=True)
    specialist = SpecialistSerializer(many=False, read_only=True)
    owner = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = Comm
        fields = ["id", "customer", "specialist", "text", "customer_id", "specialist_id", "owner", "owner_id"]

    def create(self, validated_data):
        customer_id = validated_data["customer"]["id"]
        specialist_id = validated_data["specialist"]["id"]
        owner_id = validated_data["owner"]["id"]

        customer = Customer.objects.get(pk=customer_id)
        specialist = Specialist.objects.get(pk=specialist_id)
        owner = UserProfile.objects.get(pk=owner_id)

        instance = Comm.objects.create(customer=customer, specialist=specialist, owner=owner, text=validated_data["text"])
        return instance