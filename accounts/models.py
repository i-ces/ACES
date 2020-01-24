from django.db import models
from django.contrib.auth.models import User
from phonenumber_field.modelfields import PhoneNumberField
from django.contrib.gis.db import models

class TouristProfile(models.Model):
    user = models.OneToOneField(User,on_delete=models.CASCADE,related_name="touristprofile")
    profile_pic = models.TextField()
    is_tourist = models.BooleanField(default=True)
    bio = models.TextField()
    phone_number = PhoneNumberField()

    def __str__(self):
        return self.user.username

class GuideProfile(models.Model):
    user = models.OneToOneField(User,on_delete=models.CASCADE,related_name="guideprofile")
    profile_pic = models.TextField()
    is_tourist = models.BooleanField(default=False)
    rating = models.FloatField(default=0.0)
    bio = models.TextField()
    pricing = models.IntegerField(default=1000)
    earning = models.IntegerField(default=0)
    phone_number = PhoneNumberField()
    location = models.CharField(max_length=400)
    latitude = models.DecimalField(decimal_places=7,max_digits=15)
    longitude = models.DecimalField(decimal_places=7,max_digits=15)
    loc = models.PointField(blank=True,geography=True,default='POINT(0.0 0.0)')

    objects = models.Manager()

    
    def __str__(self):
        return self.user.username

    def save(self,*args,**kwargs):
        self.loc.y = self.latitude
        self.loc.x = self.longitude
        super(GuideProfile,self).save(*args,**kwargs)

class ProfilePicture(models.Model):
    profile_pic = models.ImageField(upload_to='images',blank=True)

    def __str__(self):
        return self.profile_pic.url

class Reviews(models.Model):
    guide = models.ForeignKey(GuideProfile,on_delete=models.CASCADE)
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    review = models.TextField()
    rating = models.FloatField(default=0.0)


    class Meta:
        verbose_name_plural = 'Reviews'

    def __str__(self):
        return '{} {} reviewed by {} {}'.format(self.guide.user.first_name,self.guide.user.last_name,self.user.first_name,self.user.last_name)



        