from django.shortcuts import get_object_or_404

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .models import Question, Choice
from .serializers import (
    QuestionListPageSerializer,
    QuestionDetailPageSerializer,
    ChoiceSerializer,
    VoteSerializer,
    QuestionResultPageSerializer,
)


@api_view(["GET", "POST"])
def questions_view(request):
    if request.method == "GET":
        questions = Question.objects.all()
        serializer = QuestionListPageSerializer(questions, many=True)
        return Response(serializer.data)
    elif request.method == "POST":
        serializer = QuestionListPageSerializer(data=request.data)
        if serializer.is_valid():
            question = serializer.save()
            return Response(
                QuestionListPageSerializer(question).data,
                status=status.HTTP_201_CREATED,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET", "PATCH", "DELETE"])
def question_detail_view(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    if request.method == "GET":
        serializer = QuestionDetailPageSerializer(question)
        return Response(serializer.data)
    elif request.method == "PATCH":
        serializer = QuestionDetailPageSerializer(
            question, data=request.data, partial=True
        )
        if serializer.is_valid():
            question = serializer.save()
            return Response(QuestionDetailPageSerializer(question).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    elif request.method == "DELETE":
        question.delete()
        return Response("Question deleted", status=status.HTTP_204_NO_CONTENT)


@api_view(["GET", "POST"])
def choices_view(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    serializer = ChoiceSerializer(data=request.data)
    if request.method == "GET":
        choices = Choice.objects.filter(question=question)
        serializer = ChoiceSerializer(choices, many=True)
        return Response(serializer.data)
    elif serializer.is_valid():
        choice = serializer.save(question=question)
        return Response(ChoiceSerializer(choice).data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# def choices_view(request, question_id):
#     question = get_object_or_404(Question, pk=question_id)

#     if request.method == "GET":
#         group_member_id = request.query_params.get("pk")  # Retrieve the group member ID
#         choices = Choice.objects.filter(question=question, group_member=group_member_id)
#         serializer = ChoiceSerializer(choices, many=True)
#         return Response(serializer.data)
#     serializer = ChoiceSerializer(data=request.data)
#     if serializer.is_valid():
#         choice = serializer.save(question=question)
#         return Response(ChoiceSerializer(choice).data, status=status.HTTP_201_CREATED)
#     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["PATCH"])
def vote_view(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    serializer = VoteSerializer(data=request.data)
    if serializer.is_valid():
        choice = get_object_or_404(
            Choice, pk=serializer.validated_data["choice_id"], question=question
        )
        choice.votes += 1
        choice.save()
        return Response("Voted")
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET"])
def question_result_view(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    serializer = QuestionResultPageSerializer(question)
    return Response(serializer.data)


# from django.shortcuts import render
# from rest_framework.response import Response
# from rest_framework import viewsets, status
# from .models import Poll
# from .serializers import PollSerializer


# class PollViewSet(viewsets.ModelViewSet):
#     queryset = Poll.objects.all()
#     serializer_class = PollSerializer

#     def destroy(self, request, *args, **kwargs):
#         instance = self.get_object()
#         self.perform_destroy(instance)
#         return Response({"message": "Poll deleted"}, status=status.HTTP_204_NO_CONTENT)
