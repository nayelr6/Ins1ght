from django.urls import path
from .views import ChoiceRecordViewSet

app_name = "choicerecord"

urlpatterns = [
    path(
        "choicerecord/",
        ChoiceRecordViewSet.as_view({"get": "get", "post": "create"}),
        name="choicerecord-list",
    ),
    path(
        "choicerecord/<int:pk>/",
        ChoiceRecordViewSet.as_view({"get": "get", "put": "put", "delete": "delete"}),
        name="choicerecord-detail",
    ),
]
