"""insights URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from .views import *
from rest_framework.authtoken import views
from login.views import register, UserViewSet, get_userprofile
from userPortrait.views import ProfileViewSet, get_friendProfile
from django.conf import settings
from django.conf.urls.static import static
from friend_request.views import FriendRequestViewSet
from friends.views import FriendViewSet
from post.views import PostViewSet, PostLikeViewSet
from comments.views import PostCommentViewSet, CommentsLikeViewSet
from group.views import GroupViewSet
from grouprequest.views import GroupRequestViewset
from groupmember.views import GroupMemberViewSet, getUsersForGroup, get_groupMember
from group_room.views import GroupRoomViewSet
from room_member.views import RoomMemberViewSet, getUsersForRoom
from room_message.views import RoomMessageViewSet
from grouppolls.views import QuestionViewSet, ChoiceViewSet
from recordchoice.views import ChoiceRecordViewSet
from services.views import ServiceViewSet
from serviceRequests.views import ServiceRequestViewSet
from specialist.views import SpecialistViewSet, searchSpecialists
from customer.views import CustomerViewSet
from comms.views import CommViewSet
from service_events.views import EventViewSet
from rate_service.views import RateServiceViewSet

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api-token-auth/", views.obtain_auth_token),
    path("register/", register),
    path(
        "api/users/",
        UserViewSet.as_view({"get": "list", "post": "create", "put": "partial_update"}),
    ),
    path(
        "api/profile/",
        ProfileViewSet.as_view({"get": "list", "post": "create", "put": "update"}),
    ),
    path(
        "api/requests/",
        FriendRequestViewSet.as_view(
            {"get": "list", "post": "create", "delete": "destroy"}
        ),
    ),
    path(
        "api/friends/",
        FriendViewSet.as_view(
            {
                "get": "list",
                "post": "create",
                "put": "partial_update",
                "delete": "destroy",
            }
        ),
    ),
    path("api/get_profile/", get_userprofile),
    path("api/friend_profile/", get_friendProfile),
    path(
        "api/posts/",
        PostViewSet.as_view(
            {
                "get": "list",
                "post": "create",
                "put": "partial_update",
                "delete": "destroy",
            }
        ),
    ),
    path("api/", include("message.urls")),
    path(
        "api/postlikes/",
        PostLikeViewSet.as_view(
            {"get": "list", "post": "create", "put": "partial_update"}
        ),
    ),
    path(
        "api/comments/",
        PostCommentViewSet.as_view(
            {
                "get": "list",
                "post": "create",
                "put": "partial_update",
                "delete": "destroy",
            }
        ),
    ),
    path(
        "api/commentlikes/",
        CommentsLikeViewSet.as_view(
            {"get": "list", "post": "create", "put": "partial_update"}
        ),
    ),
    path(
        "api/groups/",
        GroupViewSet.as_view(
            {
                "get": "list",
                "post": "create",
                "put": "partial_update",
                "delete": "destroy",
            }
        ),
    ),
    path(
        "api/grouprequest/",
        GroupRequestViewset.as_view(
            {"get": "list", "post": "create", "delete": "destroy"}
        ),
    ),
    path(
        "api/groupmember/",
        GroupMemberViewSet.as_view(
            {
                "get": "list",
                "post": "create",
                "put": "partial_update",
                "delete": "destroy",
            }
        ),
    ),
    path("api/searchformembers/", getUsersForGroup),
    path("api/", include("groupmessage.urls")),
    # path("api/", include("polls.urls")),
    # path("api/", include("choicerecord.urls")),
    path("api/group_room/", GroupRoomViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path("api/room_member/", RoomMemberViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path("api/searchforroommembers/", getUsersForRoom),
    path("api/getgroupmember/", get_groupMember),
    path('api/room_message/', RoomMessageViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path('api/polls/', QuestionViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path('api/choices/', ChoiceViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path("api/choicerecord/", ChoiceRecordViewSet.as_view({"get": "list", "post": "create"})),
    path("api/services/", ServiceViewSet.as_view({"get": "list", "post": "create", "put": "partial_update"})),
    path("api/servicerequests/", ServiceRequestViewSet.as_view({"get": "list", "post": "create", "delete": "destroy"})),
    path("api/specialists/", SpecialistViewSet.as_view({"get": "list", "post": "create", "delete": "destroy"})),
    path("api/searchSpecialists/", searchSpecialists),
    path("api/customers/", CustomerViewSet.as_view({"get": "list", "post": "create", "delete": "destroy"})),
    path("api/comms/", CommViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path("api/events/", EventViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
    path("api/rateService/", RateServiceViewSet.as_view({"get": "list", "post": "create", "put": "partial_update", "delete": "destroy"})),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
