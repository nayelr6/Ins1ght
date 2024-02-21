from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from .models import Question, Choice
from .serializers import QuestionSerializer, ChoiceSerializer
from group.models import Group

# Create your views here.
class QuestionViewSet(ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer

    def list(self, request):
        gid = request.query_params.get("gid")
        if gid != None:
            group = Group.objects.get(pk=gid)
            questions = Question.objects.get(group=group)
            instance = QuestionSerializer(questions, many=False)
            return Response(instance.data)
        else:
            questions = Question.objects.all()
            instances = QuestionSerializer(questions, many=True)
            return Response(instances.data)
        
    def partial_update(self, request):
        pk = request.query_params.get("pk")
        instance = Question.objects.get(pk=pk)
        serializer = QuestionSerializer(data=request.data, instance=instance, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)
    
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance =Question.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Question Removed."})

class ChoiceViewSet(ModelViewSet):
    queryset = Choice.objects.all()
    serializer_class = ChoiceSerializer

    def list(self, request):
        qid = request.query_params.get("qid")
        if qid != None:
            question = Question.objects.get(pk=qid)
            choices = Choice.objects.filter(question=question)
            instance = ChoiceSerializer(choices, many=True)
            return Response(instance.data)
        else:
            choices = Choice.objects.all()
            instance = ChoiceSerializer(choices, many=True)
            return Response(instance.data)
        
    def partial_update(self, request):
        pk = request.query_params.get("pk")
        instance = Choice.objects.get(pk=pk)
        serializer = ChoiceSerializer(data=request.data, instance=instance, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)
    
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance =Choice.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Choice Removed."})