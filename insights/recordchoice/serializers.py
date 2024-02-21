from rest_framework.response import Response
from rest_framework import status
from rest_framework.serializers import ModelSerializer, CharField
from .models import ChoiceRecord
from groupmember.serializers import GroupMemberSerializer
from grouppolls.models import Choice, Question
from grouppolls.serializers import ChoiceSerializer, QuestionSerializer
from groupmember.models import GroupMember

class ChoiceRecordSerializer(ModelSerializer):
    question = QuestionSerializer(read_only=True)
    choice = ChoiceSerializer(read_only=True)
    owner = GroupMemberSerializer(read_only=True)
    question_id = CharField(source="question.id", write_only=True)
    choice_id = CharField(source="choice.id", write_only=True)
    owner_id = CharField(source="owner.id", write_only=True)

    class Meta:
        model = ChoiceRecord
        fields = ["id", "question", "question_id", "choice", "choice_id", "owner", "owner_id"]

    def create(self, validated_data):
        question_id = validated_data["question"]["id"]
        question = Question.objects.get(pk=question_id)
        choice_id = validated_data["choice"]["id"]
        choice = Choice.objects.get(pk=choice_id)
        owner_id = validated_data["owner"]["id"]
        owner = GroupMember.objects.get(pk=owner_id)
        return ChoiceRecord.objects.create(
            question=question, choice=choice, owner=owner
        )