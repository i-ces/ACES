# Generated by Django 3.0.2 on 2020-01-24 06:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('hireguides', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='hirings',
            name='days',
            field=models.CharField(default=0, max_length=30),
        ),
    ]