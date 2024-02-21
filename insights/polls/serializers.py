from group.models import Group
from userPortrait.models import UserProfile
from userPortrait.serializers import ProfileSerializer
from rest_framework import serializers
from rest_framework.serializers import CharField, ImageField, ModelSerializer
from group.serializers import GroupSerializer
from .models import Question, Choice


class ChoiceSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    choice_text = serializers.CharField(max_length=200)

    # memberid = serializers.PrimaryKeyRelatedField(queryset=UserProfile.objects.all())
    class Meta:
        model = Choice
        fields = ["id", "choice_text"]

    def create(self, validated_data):
        return Choice.objects.create(**validated_data)


class ChoiceSerializerWithVotes(ChoiceSerializer):
    votes = serializers.IntegerField(read_only=True)


class QuestionListPageSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    question_text = serializers.CharField(max_length=200)
    pub_date = serializers.DateTimeField()
    was_published_recently = serializers.BooleanField(read_only=True)
    group = serializers.PrimaryKeyRelatedField(queryset=Group.objects.all())
    owner = serializers.PrimaryKeyRelatedField(queryset=UserProfile.objects.all())

    def create(self, validated_data):
        group = validated_data.pop("group")
        owner = validated_data.pop("owner")
        question = Question.objects.create(group=group, owner=owner, **validated_data)
        return question

    def update(self, instance, validated_data):
        for key, value in validated_data.items():
            setattr(instance, key, value)
        instance.save()
        return instance


# class QuestionListPageSerializer(serializers.Serializer):
#     id = serializers.IntegerField(read_only=True)
#     question_text = serializers.CharField(max_length=200)
#     pub_date = serializers.DateTimeField()
#     was_published_recently = serializers.BooleanField(read_only=True)

#     def create(self, validated_data):
#         return Question.objects.create(**validated_data)

#     def update(self, instance, validated_data):
#         for key, value in validated_data.items():
#             setattr(instance, key, value)
#         instance.save()
#         return instance


class QuestionDetailPageSerializer(QuestionListPageSerializer):
    choices = ChoiceSerializer(many=True, read_only=True)


class QuestionResultPageSerializer(QuestionListPageSerializer):
    choices = ChoiceSerializerWithVotes(many=True, read_only=True)


class VoteSerializer(serializers.Serializer):
    choice_id = serializers.IntegerField()


# class PollSerializer(serializers.ModelSerializer):
#     owner_id = CharField(source="owner.id", write_only=True)
#     owner = ProfileSerializer(many=False, read_only=True)
#     group = GroupSerializer(many=False, read_only=True)
#     group_id = CharField(source="group.id", write_only=True)
#     username = CharField(source="owner.user.username", read_only=True)

#     class Meta:
#         model = Poll
#         fields = [
#             "id",
#             "username",
#             "owner",
#             "owner_id",
#             "group",
#             "group_id",
#             "choice1",
#             "choice2",
#             "choice3",
#             "choice4",
#             "finished",
#         ]

#     def create(self, validated_data):
#         choices_data = validated_data.pop("choices")
#         poll = Poll.objects.create(**validated_data)
#         for choice_data in choices_data:
#             poll.choices.create(**choice_data)
#         return poll

#     def update(self, instance, validated_data):
#         choices_data = validated_data.pop("choices", [])
#         choices = instance.choices.all()
#         choices = list(choices)

#         instance.title = validated_data.get("title", instance.title)
#         instance.finished = validated_data.get("finished", instance.finished)
#         instance.save()

#         for choice_data in choices_data:
#             if "id" in choice_data:
#                 choice = next((c for c in choices if c.id == choice_data["id"]), None)
#                 if choice:
#                     choice.choice_text = choice_data.get(
#                         "choice_text", choice.choice_text
#                     )
#                     choice.votes = choice_data.get("votes", choice.votes)
#                     choice.save()
#             else:
#                 instance.choices.create(**choice_data)

#         return instance
