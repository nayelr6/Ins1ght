from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import GroupMemberSerializer
from .models import GroupMember
from rest_framework.response import Response
from group.models import Group
from rest_framework.decorators import api_view
from django.contrib.auth.models import User
from login.serializers import UserSerializer
from userPortrait.models import UserProfile

# Create your views here.

class GroupMemberViewSet(ModelViewSet):
    queryset = GroupMember.objects.all()
    serializer_class = GroupMemberSerializer

    def list(self, request):
        pk = request.query_params.get("pk")
        gid = request.query_params.get("gid")
        pid = request.query_params.get("pid")
        if pk != None:
            instance = GroupMember.objects.get(pk=pk)
            serializer = GroupMemberSerializer(instance, many=False)
            return Response(serializer.data)
        elif gid != None:
            group = Group.objects.get(pk=gid)
            instances = GroupMember.objects.filter(group=group)
            serializer = GroupMemberSerializer(instances, many=True)
            return Response(serializer.data)
        elif(pid != None):
            profile = UserProfile.objects.get(pk=pid)
            instances = GroupMember.objects.filter(profile=profile)
            serializer = GroupMemberSerializer(instances, many=True)
            return Response(serializer.data)
        else:
            instances = GroupMember.objects.all()
            serializer = GroupMemberSerializer(instances, many=True)
            return Response(serializer.data)
        
    def partial_update(self, request):
        pk = request.query_params["pk"]
        instance = GroupMember.objects.get(pk=pk)
        serializer = GroupMemberSerializer(data=request.data, instance=instance, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)
    
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = GroupMember.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Member Removed"})
    
@api_view(["GET"])
def getUsersForGroup(request):
    gid = request.query_params["gid"]
    group = Group.objects.get(pk=gid)
    groupmembers = GroupMember.objects.filter(group=group)

    userIdList = []
    for member in groupmembers:
        userIdList.append(member.profile.user.pk)

    search = request.query_params.get("search")
    queryset = User.objects.exclude(pk__in=userIdList)

    if search == None:
        instances = UserSerializer(queryset, many=True)
    else:
        searched_queryset = queryset.filter(username__contains=search)
        instances = UserSerializer(searched_queryset, many=True)

    return Response(instances.data)

@api_view(['GET'])
def get_groupMember(request):
    profile = UserProfile.objects.get(user_id=request.query_params["user_id"])
    group = Group.objects.get(pk=request.query_params["gid"])
    member = GroupMember.objects.get(profile=profile, group=group)
    instance = GroupMemberSerializer(member, many=False)
    return Response(instance.data)