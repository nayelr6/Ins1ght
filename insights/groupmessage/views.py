from django.shortcuts import render, get_object_or_404
from rest_framework.viewsets import ModelViewSet
from .serializers import GroupMessageSerializer
from .models import GroupMessage
from rest_framework.response import Response
from rest_framework import status
from group.models import Group


class GroupMessageViewSet(ModelViewSet):
    queryset = GroupMessage.objects.all()
    serializer_class = GroupMessageSerializer

    # def create(self, request, group_id):
    #     # Retrieve the group based on the group_id
    #     group = Group.objects.get(id=group_id)

    #     # Add the group to the request data
    #     request.data['group'] = group.id

    #     serializer = self.get_serializer(data=request.data)
    #     serializer.is_valid(raise_exception=True)
    #     serializer.save()
    #     return Response(serializer.data, status=status.HTTP_201_CREATED)
    def list(self, request, group_id):
        group = get_object_or_404(Group, id=group_id)
        messages = GroupMessage.objects.filter(group=group)
        serializer = self.get_serializer(messages, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(
            {"message": "Group message deleted"}, status=status.HTTP_204_NO_CONTENT
        )
