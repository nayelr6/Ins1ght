from django.shortcuts import render, get_object_or_404
from rest_framework.viewsets import ModelViewSet
from .models import RateService
from .serializers import RateServiceSerializer
from rest_framework.response import Response
from services.models import Service
from userPortrait.models import UserProfile
# Create your views here.

class RateServiceViewSet(ModelViewSet):
    queryset = RateService.objects.all()
    serializer_class = RateServiceSerializer

    def list(self, request):
        pid = request.query_params.get("pid")
        sid = request.query_params.get("sid")

        if(sid != None and pid != None):
            service = Service.objects.get(pk=sid)
            profile = UserProfile.objects.get(pk=pid)

            instance = RateService.objects.get(service=service, profile=profile)
            serializer = RateServiceSerializer(instance, many=False)
            return Response(serializer.data)
        elif(sid != None):
            service = Service.objects.get(pk=sid)

            instance = RateService.objects.filter(service=service)
            serializer = RateServiceSerializer(instance, many=True)
            return Response(serializer.data)
        else:
            instances = RateService.objects.all()
            serializer = RateServiceSerializer(instances, many=True)
            return Response(serializer.data)

        
    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = RateService.objects.get(pk=pk)
        serializer = RateServiceSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = RateService.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The request was deleted"})