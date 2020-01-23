from django.urls import path
from .views import *
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('tourist/signup/',TouristCreateView.as_view(),name='tourist_signup'),
    path('guide/signup/',GuideCreateView.as_view(),name='guide_signup'),
    path('login/',obtain_auth_token,name='api_token_auth'),
    path('profile/',ProfileView.as_view(),name='guideprofile'),
    path('profilepicture/',ProfilePictureCreate.as_view(),name='profilepicture'),
    path('flag/',FlagView.as_view(),name='flag'),
    path('guides/',GuideListView.as_view(),name='guides'),
    path('guides/rate/',RateGuideView.as_view(),name='rateguide'),
    path('topguides/',TopGuideView.as_view(),name='topguides'),
    path('review/create/',ReviewCreateView.as_view(),name='reviewcreate'),
    path('review/',ReviewListView.as_view(),name='reviewlist'),
    path('emergency/',EmergencyCase.as_view(),name='emergency'),
]