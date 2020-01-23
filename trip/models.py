from django.db import models
from django.contrib.auth.models import User


class TripProfile(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    days = models.IntegerField(default=1)
    place = models.TextField(max_length=50)
    placeId = models.TextField(max_length=50)
    rating = models.FloatField(default=0)
    description = models.TextField(max_length=500, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    image = models.TextField()

    def DATE(self):
        from django.utils.timesince import timesince
        return timesince(self.created_at)

    def __str__(self):
        return self.user.username


class TripImage(models.Model):
    image = models.ImageField(upload_to='images/', blank=True)

    def __str__(self):
        return self.image.url
