from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import ProfileSerializer
from .models import UserProfile
from django.contrib.auth.models import User
from rest_framework.parsers import MultiPartParser, FormParser
# Create your views here.


class ProfileViewSet(ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = ProfileSerializer
    parsers = (MultiPartParser, FormParser,)

    def list(self, request):
        pk = request.query_params.get('pk')
        if pk != None:
            pk = request.query_params["pk"]
            instance = ProfileSerializer(UserProfile.objects.get(pk=pk), many=False)
            return Response(instance.data)
        else:
            request_list = ProfileSerializer(UserProfile.objects.all(), many=True)
            return Response(request_list.data)

    def update(self, request, format=None):
        pk = request.query_params["pk"]
        query = UserProfile.objects.get(pk=pk)
        serializer = ProfileSerializer(
            data=request.data, instance=query, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors)


@api_view(['GET'])
def get_friendProfile(request):
    profile = UserProfile.objects.get(user_id=request.query_params["user_id"])

    instance = ProfileSerializer(profile)
    return Response(instance.data)