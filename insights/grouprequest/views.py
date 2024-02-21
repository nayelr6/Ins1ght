from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import GroupRequestSerializer
from .models import GroupRequest
from rest_framework.response import Response
from group.models import Group

# Create your views here.
class GroupRequestViewset(ModelViewSet):
    queryset = GroupRequest.objects.all()
    serializer_class = GroupRequestSerializer

    def list(self, request, format=None):
        gid = request.query_params.get("gid")
        if gid != None:
            group = Group.objects.get(pk=gid)
            queryset = GroupRequest.objects.filter(group=group)
            serializer = GroupRequestSerializer(queryset, many=True)
            return Response(serializer.data)

        else:
            queryset = GroupRequest.objects.all()
            serializer = GroupRequestSerializer(queryset, many=True)
            return Response(serializer.data)


    def destroy(self, request, format=None):
        pk = request.query_params["pk"]
        instance = GroupRequest.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Request was deleted"})