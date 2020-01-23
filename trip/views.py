from .serializers import *
from rest_framework.response import Response
from rest_framework.generics import CreateAPIView,ListAPIView
from rest_framework import status
from rest_framework.parsers import FileUploadParser
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated


class TripCreate(CreateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = TripSerializer

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class TripImageCreate(CreateAPIView):
    parser_class = (FileUploadParser,)
    def post(self, request, *args, **kwargs):

        file_serializer = FileSerializer(data=self.request.data)

        if file_serializer.is_valid():
            file_serializer.save()
            return Response(file_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class TripView(ListAPIView):
    permission_classes = [IsAuthenticated,]
    serializer_class = TripViewSerializer

    def get_queryset(self):
        return TripProfile.objects.filter(user=self.request.user)

class TripListView(ListAPIView):
    serializer_class = TripViewSerializer

    def get_queryset(self):
        userid = self.request.query_params.get('userid')
        return TripProfile.objects.filter(user__id=userid)

class TripDeleteView(APIView):

    def get(self,request):
        tripid = self.request.query_params.get('tripid')
        trip = TripProfile.objects.get(id=tripid)
        trip.delete()
        return Response('deleted')


class PlaceTripFilterView(ListAPIView):
    serializer_class = TripViewSerializer
    def get_queryset(self):
        placeid = self.request.query_params.get('placeid')
        return TripProfile.objects.filter(placeId=placeid)

