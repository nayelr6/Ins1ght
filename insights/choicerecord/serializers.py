from rest_framework import serializers
from .models import ChoiceRecord
from groupmember.serializers import GroupMemberSerializer
from polls.serializers import QuestionListPageSerializer, ChoiceSerializer
from polls.models import Question, Choice
from groupmember.models import GroupMember


class ChoiceRecordSerializer(serializers.ModelSerializer):
    question = QuestionListPageSerializer(read_only=True)
    choice = ChoiceSerializer(read_only=True)
    owner = GroupMemberSerializer(read_only=True)
    question_id = serializers.CharField(source="question.id", write_only=True)
    choice_id = serializers.CharField(source="choice.id", write_only=True)
    owner_id = serializers.CharField(source="owner.id", write_only=True)

    class Meta:
        model = ChoiceRecord
        fields = ["question", "question_id", "choice", "choice_id", "owner", "owner_id"]

    def create(self, validated_data):
        print(validated_data)
        question_id = validated_data["question"]["id"]
        question = Question.objects.get(pk=question_id)
        choice_id = validated_data["choice"]["id"]
        choice = Choice.objects.get(pk=choice_id)
        owner_id = validated_data["owner"]["id"]
        owner = GroupMember.objects.get(pk=owner_id)
        return ChoiceRecord.objects.create(
            question=question, choice=choice, owner=owner
        )

    def update(self, instance, validated_data):
        for key, value in validated_data.items():
            setattr(instance, key, value)
        instance.save()
        return instance
