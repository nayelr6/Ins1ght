from .models import Question, Choice
from rest_framework.serializers import ModelSerializer, CharField
from group.serializers import GroupSerializer
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile
from group.models import Group
from rest_framework.response import Response

class QuestionSerializer(ModelSerializer):
    owner = ProfileSerializer(many=False, read_only=True)
    group = GroupSerializer(many=False, read_only=True)
    owner_id = CharField(source="owner.id")
    group_id = CharField(source="group.id")

    class Meta:
        model = Question
        fields = ["id", "owner", "group", "question_text", "pub_date", "finished", "owner_id", "group_id"]

    def create(self, validated_data):
        owner = UserProfile.objects.get(pk=validated_data["owner"]["id"])
        group = Group.objects.get(pk=validated_data["group"]["id"])
        question_text = validated_data["question_text"]

        instance = Question.objects.create(group=group, owner=owner, question_text=question_text)
        return instance
    
class ChoiceSerializer(ModelSerializer):
    question = QuestionSerializer(many=False, read_only=True)
    question_id = CharField(source="question.id", write_only=True)

    class Meta:
        model = Choice
        fields = ["id", "question", "question_id", "choice_text", "votes"]

    def create(self, validated_data):
        question = Question.objects.get(pk=validated_data["question"]["id"])
        choice_text = validated_data["choice_text"]

        instance = Choice.objects.create(question=question, choice_text=choice_text)
        return instance