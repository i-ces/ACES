from rest_framework import serializers
from .models import *
from accounts.serializers import GuideViewSerializer,TouristViewSerializer

class HiringSerializer(serializers.ModelSerializer):

    class Meta:
        model = Hirings
        fields = ['guide','hiringdetail','days']

class HiresListSerializer(serializers.ModelSerializer):
    tourist = TouristViewSerializer(required=False)
    guide = GuideViewSerializer(required=False)

    class Meta:
        model = Hirings
        fields = '__all__'