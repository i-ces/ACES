from django.urls import path
from .views import *

urlpatterns = [
    path('request/',HiringCreateView.as_view(),name="requestguide"),
    path('pending/',HiresListPendingView.as_view(),name="pendinglist"),
    path('approved/',HiresListApprovedView.as_view(),name="approvedlist"),
    path('approve/',ApproveHireView.as_view(),name="approve"),
]