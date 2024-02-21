from django.shortcuts import render, get_object_or_404
from rest_framework.viewsets import ModelViewSet
from .models import Comm
from .serializers import CommSerializer
from customer.models import Customer
from specialist.models import Specialist
from rest_framework.response import Response
# Create your views here.

class CommViewSet(ModelViewSet):
    queryset = Comm.objects.all()
    serializer_class = CommSerializer

    def list(self, request):
        cid = request.query_params.get("cid")
        sid = request.query_params.get("sid")

        if(cid != None and sid != None):
            customer = Customer.objects.get(pk=cid)
            specialist = Specialist.objects.get(pk=sid)
            
            messages = Comm.objects.filter(customer=customer, specialist=specialist)
            serializer = CommSerializer(messages, many=True)
            return Response(serializer.data)
        else:
            messages = Comm.objects.all()
            serializer = CommSerializer(messages, many=True)
            return Response(serializer.data)
        
    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = Comm.objects.get(pk=pk)
        serializer = CommSerializer(
            data=request.data, instance=query, partial=True)
        # serializer = PostSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = Comm.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "The request was deleted"})