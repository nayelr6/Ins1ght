from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from .models import PostComments, CommentLikes
from .serializers import CommentSerializer, CommentLikesSerializer
from post.models import Post, PostLikes
from userPortrait.models import UserProfile
# from rest_framework.parsers import MultiPartParser, FormParser
# from friends.models import Friends
from rest_framework import filters
from django.db.models import Q


class PostCommentViewSet(ModelViewSet):
    queryset = PostComments.objects.all()
    serializer_class = CommentSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['posted_by__user__username', 'text']

    
    def list(self, request):
        pid = request.query_params.get('pid')
        search_query = request.query_params.get('search')
        if pid != None:
            pid = request.query_params['pid']
            post = Post.objects.get(pk=pid)

            if search_query != None:
                commentsList = PostComments.objects.filter(post=post)
                comments = commentsList.filter(
                    Q(posted_by__user__username__icontains=search_query) |
                    Q(text__icontains=search_query)
                )
                instances = CommentSerializer(comments, many=True)
                return Response(instances.data)
            else:
                comments = PostComments.objects.filter(post=post)
                instances = CommentSerializer(comments, many=True)
                return Response(instances.data)
        else:
            comments = PostComments.objects.all()
            instances = CommentSerializer(comments, many=True)
            return Response(instances.data)


        # instances = PostSerializer(posts, many=True)
        # return Response(instances.data)



    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = PostComments.objects.get(pk=pk)
        serializer = CommentSerializer(
            data=request.data, instance=query, partial=True)
        # serializer = PostSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)

    
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = PostComments.objects.get(pk=pk)
        instance.delete()
        return Response({"Deleted": "Comment was deleted"})

class CommentsLikeViewSet(ModelViewSet):
    queryset = CommentLikes.objects.all()
    serializer_class = CommentLikesSerializer

    def list(self, request):
        if "cid" in request.query_params:
            comment_id = request.query_params["cid"]
            profile_id = request.query_params["uid"]
            comment = PostComments.objects.get(pk=comment_id)
            profile = UserProfile.objects.get(pk=profile_id)
            query = CommentLikes.objects.filter(comment=comment, rated_by=profile)
            if len(query) == 0:
                instance = CommentLikesSerializer(query, many=True)
                return Response(instance.data)
            else:
                instance = CommentLikesSerializer(query[0], many=False)
                return Response(instance.data)

        else:
            query = CommentLikes.objects.all()
            instance = CommentLikesSerializer(query, many=True)
            return Response(instance.data)


    def partial_update(self, request, format=None):
        comment_id = request.query_params["cid"]
        profile_id = request.query_params["uid"]
        comment = PostComments.objects.get(pk=comment_id)
        profile = UserProfile.objects.get(pk=profile_id)
        query = CommentLikes.objects.get(comment=comment, rated_by=profile)

        serializer = CommentLikesSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)