from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from room_member.models import RoomMember
from room_member.serializers import RoomMemberSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.contrib.auth.models import User
from login.serializers import UserSerializer
from group_room.models import Group_room
from groupmember.models import GroupMember
from group.models import Group

class RoomMemberViewSet(ModelViewSet):
    queryset = RoomMember.objects.all()
    serializer_class= RoomMemberSerializer

    def list(self, request):
        pk = request.query_params.get("pk")
        rid = request.query_params.get("rid")
        mid = request.query_params.get("mid")

        if pk != None:
            instance = RoomMember.objects.get(pk=pk)
            serializer = RoomMemberSerializer(instance, many=False)
            return Response(serializer.data)

        elif rid != None:
            room = Group_room.objects.get(pk=rid)
            instances = RoomMember.objects.filter(group_room=room)
            serializer = RoomMemberSerializer(instances, many=True)
            return Response(serializer.data)

        elif mid != None:
            member = GroupMember.objects.get(pk=mid)
            instances = RoomMember.objects.filter(member=member)
            serializer = RoomMemberSerializer(instances, many=True)
            return Response(serializer.data)
        
        else:
            instances = RoomMember.objects.all()
            serializer = RoomMemberSerializer(instances, many=True)
            return Response(serializer.data)
    
    def partial_update(self, request):
        pk = request.query_params["pk"]
        instance = RoomMember.objects.get(pk=pk)
        serializer = RoomMemberSerializer(data=request.data, instance=instance, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)
    

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance =RoomMember.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Room Member Removed."})


@api_view(["GET"])
def getUsersForRoom(request):
    rid = request.query_params["rid"]
    gid = request.query_params["gid"]
    group_room = Group_room.objects.get(pk=rid)
    room_members = RoomMember.objects.filter(group_room=group_room)

    userIdList1 = []
    for room_member in room_members:
        userIdList1.append(room_member.member.profile.user.pk)

    userIdList2 = []
    group = Group.objects.get(pk=gid)
    groupmembers = GroupMember.objects.filter(group=group)

    for group_member in groupmembers:
        userIdList2.append(group_member.profile.user.pk)

    search = request.query_params.get("search")
    queryset = User.objects.filter(pk__in=userIdList2).exclude(pk__in=userIdList1)

    if search == None:
        instances = UserSerializer(queryset, many=True)
    else:
        searched_queryset = queryset.filter(username__contains=search)
        instances = UserSerializer(searched_queryset, many=True)

    return Response(instances.data)
    
    



