from django.shortcuts import render
from .serializers import *
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Hirings
from rest_framework.views import APIView
from rest_framework.response import Response
# Create your views here.


class HiringCreateView(generics.CreateAPIView):
    permission_classes = [IsAuthenticated,]
    serializer_class = HiringSerializer

    def perform_create(self, serializer):
        serializer.save(tourist=self.request.user.touristprofile)

class HiresListApprovedView(generics.ListAPIView):
    permission_classes = [IsAuthenticated,]
    serializer_class = HiresListSerializer

    def get_queryset(self):
        user = self.request.user.id
        try:
            if self.request.user.touristprofile.is_tourist == True:
                return Hirings.objects.filter(tourist__user__id=user,is_approved=True).order_by('-id')
        except:
            pass
            return Hirings.objects.filter(guide__user__id=user,is_approved=True).order_by('-id')


class HiresListPendingView(generics.ListAPIView):
    permission_classes = [IsAuthenticated, ]
    serializer_class = HiresListSerializer

    def get_queryset(self):
        user = self.request.user.id
        try:
            if self.request.user.touristprofile.is_tourist == True:
                return Hirings.objects.filter(tourist__user__id=user,is_approved=False).order_by('-id')
        except:
            pass
            return Hirings.objects.filter(guide__user__id=user, is_approved=False).order_by('-id')

class ApproveHireView(APIView):

    def get(self,request):
        hireid = self.request.query_params.get('hireid')
        hire = Hirings.objects.get(id=hireid)
        income = hire.guide.pricing * 0.8 * int(hire.days)
        hire.guide.earning = int(income + hire.guide.earning)
        hire.guide.save()
        print(hire.guide.earning)
        hire.is_approved = True
        hire.save()
        return Response(hire.id)


