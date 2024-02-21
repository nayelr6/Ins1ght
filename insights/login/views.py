from rest_framework.viewsets import ModelViewSet
from rest_framework.generics import CreateAPIView
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth.models import User
from .serializers import UserSerializer
from rest_framework import filters
from rest_framework.authtoken.models import Token
from userPortrait.models import UserProfile
from userPortrait.serializers import ProfileSerializer
# search user


class UserViewSet(ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['username', 'email']

    def partial_update(self, request, format=None):
        pk = request.query_params['pk']
        query = User.objects.get(pk=pk)
        serializer = UserSerializer(data=request.data, instance=query, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        
        return Response(serializer.errors)

@api_view(['GET', 'POST'])
def firstAPI(request):
    if request.method == "POST":
        name = request.data['name']
        age = request.data['age']
        print(name, age)
        return Response({"name": name, "age": age})

    context = {
        "name": "Tahmim",
        "age": 22,
    }

    return Response(context)


@api_view(['POST'])
def registerAPI(request):
    if request.method == "POST":
        username = request.data["username"]
        email = request.data["email"]
        password_1 = request.data["password1"]
        password_2 = request.data["password2"]

        if User.objects.filter(username=username).exists():
            return Response({"error": "A user with that username already exists. "})
        if password_1 != password_2:
            return Response({"error": "The entered passwords do not match."})
    user = User()
    user.username = username
    user.email = email
    user.is_active = True

    print(user.username)

    user.set_password(raw_password=password_1)
    user.save()

    return Response({"Result": "Success"})

@api_view(['POST'])
def register(request):
    if request.method == "POST":
        username = request.data["username"]
        email = request.data["email"]
        password_1 = request.data["password1"]
        password_2 = request.data["password2"]

        if User.objects.filter(username=username).exists():
            return Response({"error": "A user with that username already exists. "})
        if password_1 != password_2:
            return Response({"error": "The entered passwords do not match."})
    user = User()
    user.username = username
    user.email = email
    user.is_active = True


    user.set_password(raw_password=password_1)
    user.save()
    print(user.pk)

    return Response({"id": user.pk, "username": user.username, "email": user.email})

@api_view(['GET'])
def get_userprofile(request):
    user_id = Token.objects.get(key=request.query_params["token"]).user_id
    profile = UserProfile.objects.get(user_id=user_id)

    instance = ProfileSerializer(profile)
    return Response(instance.data)