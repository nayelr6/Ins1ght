from rest_framework import status, viewsets
from rest_framework.response import Response
from .models import ChoiceRecord
from .serializers import ChoiceRecordSerializer


class ChoiceRecordViewSet(viewsets.ViewSet):
    queryset = ChoiceRecord.objects.all()
    serializer_class = ChoiceRecordSerializer

    def get(self, request, pk=None):
        if pk is not None:
            try:
                choice_record = self.queryset.get(pk=pk)
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

    def put(self, request, pk):
        try:
            choice_record = self.queryset.get(pk=pk)
            serializer = self.serializer_class(choice_record, data=request.data)
            if serializer.is_valid():
                choice_record = serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except ChoiceRecord.DoesNotExist:
            return Response(
                {"error": "ChoiceRecord not found"}, status=status.HTTP_404_NOT_FOUND
            )

    def delete(self, request, pk):
        try:
            choice_record = self.queryset.get(pk=pk)
            choice_record.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except ChoiceRecord.DoesNotExist:
            return Response(
                {"error": "ChoiceRecord not found"}, status=status.HTTP_404_NOT_FOUND
            )


# from django.shortcuts import render

# # Create your views here.
# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework import status
# from .serializers import ChoiceRecordSerializer
# from .models import ChoiceRecord
# from django.shortcuts import get_object_or_404


# class ChoiceRecordViewSet(APIView):
#     # def get(self, request, format=None):
#     def get(self, request, *args, **kwargs):
#         pk = kwargs.get("pk")
#         choice_record = get_object_or_404(ChoiceRecord, pk=pk)
#         # choice_record = ChoiceRecord.objects.filter(id__exact=int(pk))
#         # choicerecords = ChoiceRecord.objects.all()
#         serializer = ChoiceRecordSerializer(choice_record, many=True)
#         return Response(serializer.data)

#     def post(self, request, format=None):
#         serializer = ChoiceRecordSerializer(data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data, status=status.HTTP_201_CREATED)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#     def put(self, request, pk, format=None):
#         choicerecord = get_object_or_404(ChoiceRecord, pk=pk)
#         serializer = ChoiceRecordSerializer(choicerecord, data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#     def delete(self, request, pk, format=None):
#         choicerecord = get_object_or_404(ChoiceRecord, pk=pk)
#         choicerecord.delete()
#         return Response(status=status.HTTP_204_NO_CONTENT)
