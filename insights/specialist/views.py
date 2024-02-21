from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import SpecialistSerializer
from .models import Specialist
from services.models import Service
from rest_framework.response import Response
from rest_framework.decorators import api_view
from userPortrait.models import UserProfile
from userPortrait.serializers import ProfileSerializer
# Create your views here.

class SpecialistViewSet(ModelViewSet):
    queryset = Specialist.objects.all()
    serializer_class = SpecialistSerializer

    def list(self, request):
        sid = request.query_params.get("sid")
        pid = request.query_params.get("pid")
        if sid != None:
            service = Service.objects.get(pk=sid)
            specialists = Specialist.objects.filter(service=service)

            instances = SpecialistSerializer(specialists, many=True)
            return Response(instances.data)
        if pid != None:
            profile = UserProfile.objects.get(pk=pid)
            specialists = Specialist.objects.filter(profile=profile)

            instances = SpecialistSerializer(specialists, many=True)
            return Response(instances.data)

        specialists = Specialist.objects.all()

        instances = SpecialistSerializer(specialists, many=True)
        return Response(instances.data)
        
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = Specialist.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The request was deleted"})
    
@api_view(["GET"])
def searchSpecialists(request):
    sid = request.query_params["sid"]
    service = Service.objects.get(pk=sid)
    specialists = Specialist.objects.filter(service=service)
    
    userIdList = []
    for specialist in specialists:
        userIdList.append(specialist.profile.pk)

    search = request.query_params.get("search")
    queryset = UserProfile.objects.exclude(pk__in=userIdList)

    if search == None:
        instances = ProfileSerializer(queryset, many=True)
    else:
        searched_queryset = queryset.filter(user__username__contains=search)
        instances = ProfileSerializer(searched_queryset, many=True)

    return Response(instances.data)