from django.contrib import admin
from django.urls import path, include
from .views import firstAPI, register, UserViewSet


urlpatterns= [
    path('register/', register),
    path('api/users/', UserViewSet.as_view({"get": "list", "post": "create", "put": "update"})),
]