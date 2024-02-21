from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from .serializers import GroupRoomSerializer
from .models import Group_room
from group.models import Group
from groupmember.models import GroupMember

class GroupRoomViewSet(ModelViewSet):
    queryset = Group_room.objects.all()
    serializer_class = GroupRoomSerializer

    def list(self, request, format=None):
        gid = request.query_params.get('gid')
        uid = request.query_params.get('uid')
        if gid != None:
            group = Group.objects.get(pk=gid)
            owner = GroupMember.objects.get(pk=uid)
            queryset = Group_room.objects.filter(group=group, owner=owner)
            instances = GroupRoomSerializer(queryset, many=True)
            return Response(instances.data)

        else:
            rooms = Group_room.objects.all()
            instances = GroupRoomSerializer(rooms, many=True)
            return Response(instances.data)

    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = Group_room.objects.get(pk=pk)
        serializer = GroupRoomSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)
    

    def destroy(self, request, format=None):
        pk = request.query_params["pk"]
        instance = Group_room.objects.get(pk=pk)
        instance.delete()
        return Response({"Suceess": "The room was deleted successfully"})


