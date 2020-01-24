from django.db import models
from accounts.models import GuideProfile,TouristProfile
from django.contrib.auth.models import User

# Create your models here.
class Hirings(models.Model):
    tourist = models.ForeignKey(TouristProfile,on_delete=models.CASCADE)
    guide = models.ForeignKey(GuideProfile,on_delete=models.CASCADE)
    is_approved = models.BooleanField(default=False)
    days = models.CharField(max_length=30,default=0)
    hiringdetail = models.TextField(default="I want to hire you on this day.")

    class Meta:
        verbose_name_plural = 'Hirings'

    def __str__(self):
        return '{} with {}'.format(self.tourist.user.username,self.guide.user.username)