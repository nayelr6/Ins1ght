from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .models import Service
from .serializers import ServiceSerializer
from rest_framework.response import Response
from django.db.models import Avg
from userPortrait.models import UserProfile
# Create your views here.

class ServiceViewSet(ModelViewSet):
    queryset = Service.objects.all()
    serializer_class = ServiceSerializer

    def list(self, request):
        option = request.query_params.get("op")
        pid = request.query_params.get("pid")

        if pid != None:
            owner = UserProfile.objects.get(pk=pid)
            instances = Service.objects.filter(owner=owner, option=option).annotate(_average_rating=Avg('reviews__rating'))
            serializer = ServiceSerializer(instances, many=True)
            return Response(serializer.data)
        
        if option != None:
            instances = Service.objects.filter(option=option).annotate(_average_rating=Avg('reviews__rating'))
            serializer = ServiceSerializer(instances, many=True)
            return Response(serializer.data)

        instances = Service.objects.all().annotate(_average_rating=Avg('reviews__rating'))
        serializer = ServiceSerializer(instances, many=True)
        return Response(serializer.data)
        
    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = Service.objects.get(pk=pk)
        serializer = ServiceSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)