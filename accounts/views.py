from django.shortcuts import render
from .serializers import *
from rest_framework.generics import CreateAPIView,ListAPIView
from rest_framework.views import APIView
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from .models import GuideProfile
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import FileUploadParser
from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.geos import fromstr,GEOSGeometry,Point
from django.contrib.gis import measure
import requests

def SENDSMS(to,message):
    url = 'http://beta.thesmscentral.com/api/v3/sms?token=fZxKwcV7cOqiURZT1242LB29HJupt0y4qQXf&sender=radiant&to={}&message={}'.format(to,message)
    response = requests.get(url)
    if response.status_code !=200:
        print('Status:',response,'Problem With the request')

class TouristCreateView(CreateAPIView):
    serializer_class = TouristSerializer

class GuideCreateView(CreateAPIView):
    serializer_class = GuideSerializer

class ProfileView(ListAPIView):
    permission_classes = [IsAuthenticated,]

    def get_serializer_class(self):
        try:
            if self.request.user.touristprofile.is_tourist == True:
                return TouristUserSerializer
        except:
            pass
        return GuideUserSerializer

    def get_queryset(self):
        return User.objects.filter(id=self.request.user.id)

class FlagView(ListAPIView):
    permission_classes = [IsAuthenticated,]

    def get_serializer_class(self):
        try:
            if self.request.user.touristprofile.is_tourist == True:
                return TouristPrfleSerializer
        except:
            pass
        return GuidePrfleSerializer

    def get_queryset(self):
        try:
            if self.request.user.touristprofile.is_tourist == True:
                return TouristProfile.objects.filter(user=self.request.user)
        except:
            pass
        return GuideProfile.objects.filter(user=self.request.user)


class GuideListView(ListAPIView):
    serializer_class = GuideListSerializer

    def get_queryset(self):
        latitude = self.request.query_params.get('latitude')
        longitude = self.request.query_params.get('longitude')
        current_point = fromstr('POINT(%s %s)' % (longitude,latitude))
        guides=GuideProfile.objects.filter(loc__distance_lte=(current_point, measure.D(km=10))).annotate(distance=Distance('loc', current_point)).order_by('distance')
        return guides

class ProfilePictureCreate(APIView):
    parser_class = (FileUploadParser,)
    def post(self, request, *args, **kwargs):
        file_serializer = ProfilePictureSerializer(data=self.request.data)

        if file_serializer.is_valid():
            file_serializer.save()
            return Response(file_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(file_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class RateGuideView(APIView):
    def get(self,request):
        guideid = self.request.query_params.get('guideid')
        rating = self.request.query_params.get('rating')
        guide = GuideProfile.objects.get(id=guideid)
        guide.rating = rating
        guide.save()
        return Response(guideid)

class TopGuideView(ListAPIView):
    serializer_class = GuideListSerializer

    def get_queryset(self):
        return GuideProfile.objects.all().order_by('rating')


class ReviewCreateView(CreateAPIView):
    permission_classes = [IsAuthenticated,]
    serializer_class = ReviewCreateSerializer

    def perform_create(self,serializer):
        serializer.save(user=self.request.user)

class ReviewListView(ListAPIView):
    serializer_class = ReviewListSerializer
    def get_queryset(self):
        guideid = self.request.query_params.get('guideid')
        return Reviews.objects.filter(guide=guideid).order_by('-id')

class EmergencyCase(ListAPIView):
    serializer_class = GuideListSerializer
    permission_classes = [IsAuthenticated,]

    def get_queryset(self):
        latitude = self.request.query_params.get('latitude')
        longitude = self.request.query_params.get('longitude')
        current_point = fromstr('POINT(%s %s)' % (longitude,latitude))
        guide=GuideProfile.objects.filter(loc__distance_lte=(current_point, measure.D(km=10))).annotate(distance=Distance('loc', current_point)).order_by('distance')[0]
        message = "There is an emergency near you.Please contact {}.Location Details: https://www.google.com/maps/@{},{},15z".format(self.request.user.touristprofile.phone_number,latitude,longitude)
        to = guide.phone_number
        SENDSMS(to,message)
        return message



