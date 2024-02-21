from rest_framework import status, viewsets
from rest_framework.response import Response
from .models import ChoiceRecord
from .serializers import ChoiceRecordSerializer
from group.models import Group
from grouppolls.models import Question
from groupmember.models import GroupMember

class ChoiceRecordViewSet(viewsets.ViewSet):
    queryset = ChoiceRecord.objects.all()
    serializer_class = ChoiceRecordSerializer

    def list(self, request):
        oid = request.query_params.get("oid")
        gid = request.query_params.get("gid")
        if oid is not None:
            group = Group.objects.get(pk=gid)
            print(group)
            question = Question.objects.get(group=group)
            owner = GroupMember.objects.get(pk=oid)
            try:
                choice_record = self.queryset.get(owner=owner, question=question)
                serializer = self.serializer_class(choice_record)
                return Response(serializer.data)
            except ChoiceRecord.DoesNotExist:
                return Response(
                    {"error": "ChoiceRecord not found"},
                    status=status.HTTP_404_NOT_FOUND,
                )

        choice_records = self.queryset.all()
        serializer = self.serializer_class(choice_records, many=True)
        return Response(serializer.data)
    
    def create(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            choice_record = serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def destroy(self, request):
        pk = request.query_params["pk"]
        instance =ChoiceRecord.objects.get(pk=pk)
        instance.delete()
        return Response({"Success": "Choice Removed."})