from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .models import ServiceRequests
from .serializers import ServiceRequestSerializer
from services.models import Service
from rest_framework.response import Response

# Create your views here.
class ServiceRequestViewSet(ModelViewSet):
    queryset = ServiceRequests.objects.all()
    serializer_class = ServiceRequestSerializer

    def list(self, request):
        sid = request.query_params.get("sid")
        if sid != None:
            service = Service.objects.get(pk=sid)
            instances = ServiceRequests.objects.filter(service=service)
            serializer = ServiceRequestSerializer(instances, many=True)
            return Response(serializer.data)
        else:
            instances = ServiceRequests.objects.all()
            serializer = ServiceRequestSerializer(instances, many=True)
            return Response(serializer.data)
        

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = ServiceRequests.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The request was deleted"})