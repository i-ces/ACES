from django.urls import path
from .views import *


urlpatterns = [
    path('create/',TripCreate.as_view(),name='trip_create'),
    path('image/', TripImageCreate.as_view(),name="upload_image"),
    path('view/', TripView.as_view(), name="trip_view"),
    path('userfeeds/',TripListView.as_view(),name="guidetrips"),
    path('delete/',TripDeleteView.as_view(),name="deletetrip"),
    path('placefeeds/',PlaceTripFilterView.as_view(),name="placefeeds"),
]

