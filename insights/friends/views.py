from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .models import Friends
from .serializers import FriendSerializer
from rest_framework.response import Response
from userPortrait.models import UserProfile

# Create your views here.
class FriendViewSet(ModelViewSet):
    queryset = Friends.objects.all()
    serializer_class = FriendSerializer

    def list(self, request):
        pk = request.query_params.get('pid')
        if pk != None:
            if 'fid' not in request.query_params:
                pk = request.query_params["pid"]
                friend_1 = UserProfile.objects.get(pk=pk)
                instance = FriendSerializer(Friends.objects.filter(friend_1=friend_1), many=True)
                return Response(instance.data)
            else:
                fid = request.query_params["fid"]
                friend_1 = UserProfile.objects.get(pk=pk)
                friend_2 = UserProfile.objects.get(pk=fid)
                instance = FriendSerializer(Friends.objects.filter(friend_1=friend_2, friend_2=friend_1)[0], many=False)
                return Response(instance.data)
        else:
            request_list = FriendSerializer(Friends.objects.all(), many=True)
            return Response(request_list.data)

    def partial_update(self, request, format=None):
        pk = request.query_params['pk']
        query = Friends.objects.get(pk=pk)
        serializer = FriendSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)
    
    def destroy(self, request, format=None):
        pk = request.query_params['pk']
        instance = Friends.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Deletion successful"})