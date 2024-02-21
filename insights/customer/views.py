from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .models import Customer
from .serializers import CustomerSerializer
from specialist.models import Specialist
from rest_framework.response import Response
from userPortrait.models import UserProfile

# Create your views here.
class CustomerViewSet(ModelViewSet):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer

    def list(self, request):
        spid = request.query_params.get("spid")
        if(spid != None):
            specialist = Specialist.objects.get(pk=spid)
            customers = Customer.objects.filter(specialist=specialist)
            instances = CustomerSerializer(customers, many=True)
            return Response(instances.data)
        pid = request.query_params.get("pid")
        if(pid != None):
            profile = UserProfile.objects.get(pk=pid)
            customers = Customer.objects.filter(profile=profile)
            instances = CustomerSerializer(customers, many=True)
            return Response(instances.data)
        customers = Customer.objects.all()
        instances = CustomerSerializer(customers, many=True)
        return Response(instances.data)
        
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = Customer.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The request was deleted"})