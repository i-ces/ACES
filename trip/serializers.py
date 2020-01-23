from rest_framework import serializers
from .models import *
from accounts.serializers import UserSerializer


class TripSerializer(serializers.ModelSerializer):
    class Meta:
        model = TripProfile
        fields = ('days', 'place', 'placeId', 'rating','image','description')


class FileSerializer(serializers.ModelSerializer):
    class Meta:
        model = TripImage
        fields = '__all__'


class TripViewSerializer(serializers.ModelSerializer):
    user = UserSerializer(required=False,read_only=True)
    class Meta:
        model = TripProfile
        fields = '__all__'