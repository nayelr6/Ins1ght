from django.shortcuts import render
from rest_framework.response import Response
from django.http import JsonResponse
from rest_framework.viewsets import ModelViewSet
from .serializers import FriendRequestSerializer
from .models import FriendRequest
from userPortrait.models import UserProfile

# Create your views here.
class FriendRequestViewSet(ModelViewSet):
    queryset = FriendRequest.objects.all()
    serializer_class = FriendRequestSerializer

    def list(self, request):
        pk = request.query_params.get('pid')
        if pk != None:
            pk = request.query_params["pid"]
            receiver = UserProfile.objects.get(pk=pk)
            instance = FriendRequestSerializer(FriendRequest.objects.filter(receiver=receiver), many=True)
            return Response(instance.data)
        else:
            request_list = FriendRequestSerializer(FriendRequest.objects.all(), many=True)
            return Response(request_list.data)

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = FriendRequest.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Deletion successful"})