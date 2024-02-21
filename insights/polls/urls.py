# from .views import PollViewSet


from django.urls import path

from . import views

app_name = "polls"
urlpatterns = [
    path("questions/", views.questions_view, name="questions_view"),
    path(
        "questions/<int:question_id>/",
        views.question_detail_view,
        name="question_detail_view",
    ),
    path(
        "questions/<int:question_id>/choices/",
        views.choices_view,
        name="choices_view",
    ),
    path("questions/<int:question_id>/vote/", views.vote_view, name="vote_view"),
    path(
        "questions/<int:question_id>/result/",
        views.question_result_view,
        name="question_result_view",
    ),
]
# urlpatterns = [
#     path(
#         "polls/",
#         PollViewSet.as_view({"get": "list", "post": "create"}),
#         name="poll-list",
#     ),
#     path(
#         "polls/<int:pk>/",
#         PollViewSet.as_view({"get": "retrieve", "put": "update", "delete": "destroy"}),
#         name="poll-detail",
#     ),
# ]
