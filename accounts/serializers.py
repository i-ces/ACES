from rest_framework import serializers
from django.contrib.auth.models import User
from django.core import exceptions
from django.contrib.auth.password_validation import validate_password
from .models import *

class GuidePrfleSerializer(serializers.ModelSerializer):
    class Meta:
        model = GuideProfile
        fields = ['is_tourist']

class TouristPrfleSerializer(serializers.ModelSerializer):
    class Meta:
        model = TouristProfile
        fields = ['is_tourist']


class TouristProfileSerializer(serializers.ModelSerializer):
    is_tourist = serializers.BooleanField(initial=True)
    class Meta:
        model = TouristProfile
        fields = ('phone_number','profile_pic','bio','is_tourist')


class TouristSerializer(serializers.ModelSerializer):
    touristprofile = TouristProfileSerializer(required=False)

    class Meta:
        model = User
        fields = ('first_name','last_name','email','username','password','touristprofile')

    def create(self, validated_data, instance=None):
        profile_data = validated_data.pop('touristprofile')
        user = User.objects.create(**validated_data)
        #user.validate_password(validated_data['password'])
        user.set_password(validated_data['password'])
        user.is_active = True
        user.save()
        TouristProfile.objects.update_or_create(user=user,**profile_data)
        return user

class GuideProfileSerializer(serializers.ModelSerializer):
    is_tourist = serializers.BooleanField(initial=False)
    rating = serializers.IntegerField(initial=0.0)
    class Meta:
        model = GuideProfile
        fields = ('phone_number','rating','profile_pic','bio','latitude','longitude','is_tourist','pricing')


class GuideSerializer(serializers.ModelSerializer):
    guideprofile = GuideProfileSerializer(required=False)

    class Meta:
        model = User
        fields = ('first_name','last_name','email','username','password','guideprofile')

    def create(self, validated_data, instance=None):
        profile_data = validated_data.pop('guideprofile')
        user = User.objects.create(**validated_data)
        #errors = dict()
        #try:
            #validate_password(validated_data['password'])
        #except exceptions.ValidationError as e:
            #errors['password'] = list(e.messages)
        #if errors:
            #raise serializers.ValidationError(errors)
        user.set_password(validated_data['password'])
        user.is_active = False
        user.save()
        GuideProfile.objects.update_or_create(user=user,**profile_data)

        return user

class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = '__all__'

class GuideListSerializer(serializers.ModelSerializer):

    user = UserSerializer(required=False,read_only=True)

    class Meta:
        model = GuideProfile
        fields = '__all__'

class GuideUserSerializer(serializers.ModelSerializer):
    guideprofile = GuideProfileSerializer(required=False,read_only=True)

    class Meta:
        model = User
        fields = ['username','first_name','last_name','email','guideprofile']

class TouristUserSerializer(serializers.ModelSerializer):
    touristprofile = TouristProfileSerializer(required=False,read_only=True)

    class Meta:
        model = User
        fields = ['username','first_name','last_name','email','touristprofile']

class ProfilePictureSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProfilePicture
        fields = '__all__'

class GuideViewSerializer(serializers.ModelSerializer):
    user = UserSerializer(required=False)
    class Meta:
        model = GuideProfile
        fields = '__all__'

class TouristViewSerializer(serializers.ModelSerializer):
    user = UserSerializer(required=False)
    class Meta:
        model = TouristProfile
        fields = '__all__'

class ReviewListSerializer(serializers.ModelSerializer):
    user = UserSerializer(required=False)
    class Meta:
        model = Reviews
        fields = '__all__'

class ReviewCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reviews
        fields = ['guide','review','rating']