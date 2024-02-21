from django.shortcuts import render
from .serializers import GroupSerializer
from .models import Group
from rest_framework.viewsets import ModelViewSet
from rest_framework import filters
from rest_framework.response import Response

# Create your views here.
class GroupViewSet(ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ["name", "description"]

    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = Group.objects.get(pk=pk)
        serializer = GroupSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)
    
    def destroy(self, request, format=None):
        pk = request.query_params["pk"]
        instance = Group.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The post was deleted"})