from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import RoomMessageSerializer
from .models import RoomMessage
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import action
from group_room.models import Group_room

class RoomMessageViewSet(ModelViewSet):
    queryset = RoomMessage.objects.all()
    serializer_class = RoomMessageSerializer


    def list(self, request):
        if 'rid' in request.query_params:
            print(request.query_params["rid"])
            rid = request.query_params["rid"]

            room = Group_room.objects.get(pk=rid)

            messages = RoomMessage.objects.filter(room=room)            

            instances = RoomMessageSerializer(messages, many=True)
            return Response(instances.data)
        else:
            messages = RoomMessage.objects.all()
            instances = RoomMessageSerializer(messages, many=True)
            return Response(instances.data)


    def destroy(self, request, *args, **kwargs):
        pk = request.query_params.get("pk")
        instance = RoomMessage.objects.get(pk=pk)
        instance.delete()
        return Response({"message": "Room Message deleted"}, status=status.HTTP_204_NO_CONTENT)
        # return Response(status=status.HTTP_204_NO_CONTENT)

    @action(detail=True, methods=['PATCH'])
    def partial_update(self, request, *args, **kwargs):
        pk = request.query_params.get('pk')
        instance = RoomMessage.objects.get(pk=pk)
        serializer = RoomMessageSerializer(
            instance, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)