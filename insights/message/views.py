from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import MessageSerializer
from .models import Message
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import action
from userPortrait.models import UserProfile
from itertools import chain
from group.models import Group

# class MessageViewSet(ModelViewSet):
#     queryset = Message.objects.all()
#     serializer_class = MessageSerializer

#     def list(self, request):
#         if 'group_id' in request.query_params:
#             group_id = request.query_params["group_id"]
#             group = Group.objects.get(pk=group_id)
#             messages = Message.objects.filter(group=group)
#             instances = MessageSerializer(messages, many=True)
#             return Response(instances.data)
#         else:
#             messages = Message.objects.all()
#             instances = MessageSerializer(messages, many=True)
#             return Response(instances.data)

#     def destroy(self, request, *args, **kwargs):
#         instance = self.get_object()
#         self.perform_destroy(instance)
#         return Response({"message": "Message deleted"}, status=status.HTTP_204_NO_CONTENT)

#     @action(detail=True, methods=['PATCH'])
#     def partial_update(self, request, *args, **kwargs):
#         pk = request.data.get('pk')
#         instance = Message.objects.get(pk=pk)
#         serializer = MessageSerializer(
#             instance, data=request.data, partial=True)
#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data)

#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#     def update(self, request, *args, **kwargs):
#         instance = self.get_object()
#         serializer = self.get_serializer(instance, data=request.data)
#         serializer.is_valid(raise_exception=True)
#         self.perform_update(serializer)
#         return Response(serializer.data)


class MessageViewSet(ModelViewSet):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer

    def list(self, request):
        if 'oid' in request.query_params:
            print(request.query_params["oid"])
            oid = request.query_params["oid"]
            rid = request.query_params["rid"]

            friend_1 = UserProfile.objects.get(pk=oid)
            friend_2 = UserProfile.objects.get(pk=rid)

            messages1 = Message.objects.filter(
                owner=friend_1, recipient=friend_2)
            print(messages1)
            messages2 = Message.objects.filter(
                owner=friend_2, recipient=friend_1)
            print(messages2)

            messages = sorted(
                chain(messages1, messages2),
                key=lambda data: data.date_sent
            )

            instances = MessageSerializer(messages, many=True)
            return Response(instances.data)
        else:
            messages = Message.objects.all()
            instances = MessageSerializer(messages, many=True)
            return Response(instances.data)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response({"message": "Message deleted"}, status=status.HTTP_204_NO_CONTENT)
        # return Response(status=status.HTTP_204_NO_CONTENT)

    @action(detail=True, methods=['PATCH'])
    def partial_update(self, request, *args, **kwargs):
        pk = request.data.get('pk')
        instance = Message.objects.get(pk=pk)
        serializer = MessageSerializer(
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
