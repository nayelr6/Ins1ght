from rest_framework.serializers import ModelSerializer, CharField
from .models import Post, PostLikes
from userPortrait.serializers import ProfileSerializer
from userPortrait.models import UserProfile

class PostSerializer(ModelSerializer):
    owner_id = CharField(source = "owner.id", write_only=True)
    owner = ProfileSerializer(many=False, read_only=True)
    username = CharField(source = "owner.user.username", read_only=True)

    class Meta:
        model = Post
        fields = ["id", "owner", "caption", "image", "date_posted", "likes", "dislikes", "owner_id", "username"]
    
    def create(self, validated_data):
        owner = UserProfile.objects.get(pk=validated_data["owner"]["id"])
        
        if('image' in validated_data and 'caption' in validated_data):
            insance = Post.objects.create(owner=owner, caption=validated_data['caption'], image=validated_data['image'])
            return insance
        
        elif('caption' in validated_data):
            insance = Post.objects.create(owner=owner, caption=validated_data['caption'])
            return insance

        elif('image' in validated_data):
            insance = Post.objects.create(owner=owner, image=validated_data['image'])
            return insance

        else:
            insance = Post.objects.create(owner=owner)
            return insance

    def update(self, instance, validated_data):
        if validated_data:
            post = instance
            if 'caption' in validated_data:
                post.caption = validated_data['caption']
            if 'image' in validated_data:
                post.image = validated_data['image']
            if 'likes' in validated_data:
                if validated_data["likes"] == 1:
                    post.likes = post.likes + 1
                elif validated_data["likes"] == 0:
                    post.likes = post.likes - 1
            if 'dislikes' in validated_data:
                if validated_data["dislikes"] == 1:
                    post.dislikes = post.dislikes + 1
                elif validated_data["dislikes"] == 0:
                    post.dislikes = post.dislikes - 1
                
            
            post.save()

        return instance
    
class PostLikesSerializer(ModelSerializer):
    profile_id = CharField(source="rated_by.id", write_only=True)
    post_id = CharField(source="post.id", write_only=True)
    post = PostSerializer(many=False, read_only=True)
    rated_by = ProfileSerializer(many=False, read_only=True)

    class Meta:
        model = PostLikes
        fields = ["id", "post", "rated_by", "profile_id", "post_id", "liked", "disliked"]

    def create(self, validated_data):
        rated_by = UserProfile.objects.get(pk=validated_data["rated_by"]["id"])
        post = Post.objects.get(pk=validated_data["post"]["id"])
        
        instance = PostLikes.objects.create(post=post, rated_by=rated_by, liked=validated_data["liked"], disliked=validated_data["disliked"])
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
