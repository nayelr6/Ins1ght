from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from rest_framework.response import Response
from .models import Post, PostLikes
from userPortrait.models import UserProfile
from .serializers import PostSerializer, PostLikesSerializer
from rest_framework.parsers import MultiPartParser, FormParser
from friends.models import Friends
from rest_framework import filters
from django.db.models import Q
# Create your views here.


class PostViewSet(ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    parsers = (MultiPartParser, FormParser)
    filter_backends = [filters.SearchFilter]
    search_fields = ['owner__user__username', 'caption']

    def list(self, request, *args, **kwargs):
        pid = request.query_params.get('pid')
        search_query = request.query_params.get('search')

        if pid is not None:
            pid = request.query_params['pid']
            id_list = [int(pid)]
            friends = Friends.objects.filter(friend_2=pid, blocked=False)
            for friend in friends:
                id_list.append(friend.friend_1.pk)

            posts = Post.objects.filter(owner_id__in=id_list)
        else:
            posts = Post.objects.all()

        if search_query:
            posts = posts.filter(
                Q(owner__user__username__icontains=search_query) |
                Q(caption__icontains=search_query)
            )

        instances = PostSerializer(posts, many=True)
        return Response(instances.data)

    # def list(self, request):
    #     pid = request.query_params.get('pid')
    #     if pid != None:
    #         pid = request.query_params['pid']
    #         id_list = [int(pid)]
    #         friends = Friends.objects.filter(friend_2=pid).filter(blocked=False)
    #         for friend in friends:
    #             id_list.append(friend.friend_1.pk)
    #         posts = Post.objects.filter(owner_id__in=id_list)
    #         instances = PostSerializer(posts, many=True)
    #         return Response(instances.data)
    #     else:
    #         posts = Post.objects.all()
    #         instances = PostSerializer(posts, many=True)
    #         return Response(instances.data)

    def partial_update(self, request, format=None):
        pk = request.query_params["pk"]
        query = Post.objects.get(pk=pk)
        serializer = PostSerializer(
            data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)

    def destroy(self, request):
        pk = request.query_params["pk"]
        instance = Post.objects.get(pk=pk)
        instance.delete()
        return Response({"Deleted": "Post was deleted"})


class PostLikeViewSet(ModelViewSet):
    queryset = PostLikes.objects.all()
    serializer_class = PostLikesSerializer

    def list(self, request):
        if "pid" in request.query_params:
            post_id = request.query_params["pid"]
            profile_id = request.query_params["uid"]
            post = Post.objects.get(pk=post_id)
            profile = UserProfile.objects.get(pk=profile_id)
            query = PostLikes.objects.filter(post=post, rated_by=profile)
            if len(query) == 0:
                instance = PostLikesSerializer(query, many=True)
                return Response(instance.data)
            else:
                instance = PostLikesSerializer(query[0], many=False)
                return Response(instance.data)

        else:
            query = PostLikes.objects.all()
            instance = PostLikesSerializer(query, many=True)
            return Response(instance.data)

    def partial_update(self, request, format=None):
        post_id = request.query_params["pid"]
        profile_id = request.query_params["uid"]
        post = Post.objects.get(pk=post_id)
        profile = UserProfile.objects.get(pk=profile_id)
        query = PostLikes.objects.get(post=post, rated_by=profile)
        # pk = request.query_params["pk"]
        # query = Post.objects.get(pk=pk)
        serializer = PostLikesSerializer(
            data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors)
