from django.urls import path
from .views import GroupMessageViewSet

# path('groupmessage/<int:group_id>/',
# GroupMessageViewSet.as_view({'post': 'create'}), name='groupmessage-create'),
#     path('groupmessage/',
#          GroupMessageViewSet.as_view({'get': 'list'}), name='groupmessage-list'),
#     path('groupmessage/<int:pk>/', GroupMessageViewSet.as_view(
#         {'get': 'retrieve', 'put': 'update', 'patch': 'partial_update', 'delete': 'destroy'}), name='groupmessage-detail'),

# urlpatterns = [
#     path(
#         "groupmessage/<int:pk>/",
#         GroupMessageViewSet.as_view(
#             {"get": "retrieve", "post": "create", "put": "update", "delete": "destroy"}
#         ),
#         name="groupmessage-create",
#     ),
# ]

urlpatterns = [
    path(
        "groupmessagelist/<int:group_id>/",
        GroupMessageViewSet.as_view(
            {"get": "list", "put": "update", "delete": "destroy"}
        ),
        name="groupmessagelist-list",
    ),
    path(
        "groupmessage/<int:pk>/",
        GroupMessageViewSet.as_view(
            {
                "post": "create",
                "get": "retrieve",
                "put": "update",
                "patch": "partial_update",
                "delete": "destroy",
            }
        ),
        name="groupmessage-detail",
    ),
]
