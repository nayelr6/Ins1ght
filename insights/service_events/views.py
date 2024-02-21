from django.shortcuts import render, get_object_or_404
from rest_framework.viewsets import ModelViewSet
from .models import ServiceEvent
from .serializers import EventSerializer
from rest_framework.response import Response
from services.models import Service
# Create your views here.

class EventViewSet(ModelViewSet):
    queryset = ServiceEvent.objects.all()
    serializer_class = EventSerializer

    def list(self, request):
        sid = request.query_params.get("sid")

        if(sid != None):
            service = Service.objects.get(pk=sid)
            
            events = ServiceEvent.objects.filter(service=service)
            serializer = EventSerializer(events, many=True)
            return Response(serializer.data)
        else:
            events = ServiceEvent.objects.all()
            serializer = EventSerializer(events, many=True)
            return Response(serializer.data)

        
    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = ServiceEvent.objects.get(pk=pk)
        serializer = EventSerializer(
            data=request.data, instance=query, partial=True)
        # serializer = PostSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = ServiceEvent.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The request was deleted"})