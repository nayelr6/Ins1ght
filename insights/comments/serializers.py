from rest_framework.serializers import ModelSerializer, CharField
from .models import PostComments, CommentLikes
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile
from post.serializers import PostSerializer
from post.models import Post


class CommentSerializer(ModelSerializer):
    post_id = CharField(source="post.id", write_only=True)
    profile_id = CharField(source="posted_by.id", write_only=True)
    post = PostSerializer(many=False, read_only=True)
    posted_by = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = PostComments
        fields = ["id", "post", "text", "posted_by", "date_posted", "likes", "dislikes", "profile_id", "post_id"]

    def create(self, validated_data):
        print(validated_data)
        posted_by = UserProfile.objects.get(pk=validated_data["posted_by"]["id"])
        post = Post.objects.get(pk=validated_data["post"]["id"])

        instance = PostComments.objects.create(post=post, posted_by=posted_by, text = validated_data["text"])
        return instance
    
    def update(self, instance, validated_data):
        if validated_data:
            comment = instance
            if 'text' in validated_data:
                comment.text = validated_data["text"]
            if 'likes' in validated_data:
                if validated_data["likes"] == 1:
                    comment.likes = comment.likes + 1
                elif validated_data["likes"] == -1:
                    comment.likes = comment.likes - 1
            if 'dislikes' in validated_data:
                if validated_data["dislikes"] == 1:
                    comment.dislikes = comment.dislikes + 1
                elif validated_data["dislikes"] == -1:
                    comment.dislikes = comment.dislikes - 1


            comment.save()

        return instance

class CommentLikesSerializer(ModelSerializer):
    profile_id = CharField(source="rated_by.id", write_only=True)
    comment_id = CharField(source="comment.id", write_only=True)
    comment = CommentSerializer(many=False, read_only=True)
    rated_by = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = CommentLikes
        fields = ["id", "comment", "rated_by", "profile_id", "comment_id", "liked", "disliked"]

    def create(self, validated_data):
        rated_by = UserProfile.objects.get(pk=validated_data["rated_by"]["id"])
        comment = PostComments.objects.get(pk=validated_data["comment"]["id"])
        
        instance = CommentLikes.objects.create(comment=comment, rated_by=rated_by, liked=validated_data["liked"], disliked=validated_data["disliked"])
        return instance
    
    def update(self, instance, validated_data):
        if validated_data:
            postRecord = instance
            if 'liked' in validated_data:
                liked = validated_data.get("liked")
                postRecord.liked=liked
                if liked==True:
                    postRecord.disliked=False

            if 'disliked' in validated_data:
                disliked = validated_data.get('disliked')
                postRecord.disliked=disliked
                if disliked==True:
                    postRecord.liked=False

            postRecord.save()

        return instance


# class CommentSerializer(ModelSerializer):
#     profile_id = CharField(source="rated_by.id", write_only=True)
#     post_id = CharField(source="post.id", write_only=True)
#     post = PostSerializer(many=False, read_only=True)
#     posted_by = ProfileSerializer(many=False, read_only=True)

#     class Meta:
#         model = PostComments
#         fields = ["id", "post", "posted_by", "profile_id", "post_id"]

#     def create(self, validated_data):
#         rated_by = UserProfile.objects.get(pk=validated_data["rated_by"]["id"])
#         post = Post.objects.get(pk=validated_data["post"]["id"])

#         instance = PostComments.objects.create(post=post, rated_by=rated_by, liked=validated_data["liked"], disliked=validated_data["disliked"])
#         return instance

#     def update(self, instance, validated_data):
#         if validated_data:
#             postRecord = instance
#             if 'liked' in validated_data:
#                 liked = validated_data.get("liked")
#                 postRecord.liked=liked
#                 if liked==True:
#                     postRecord.disliked=False

#             if 'disliked' in validated_data:
#                 disliked = validated_data.get('disliked')
#                 postRecord.disliked=disliked
#                 if disliked==True:
#                     postRecord.liked=False

#             postRecord.save()

#         return instance