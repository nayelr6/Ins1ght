# Generated by Django 4.2 on 2023-07-03 10:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("userPortrait", "0001_initial"),
        ("group", "0001_initial"),
    ]

    operations = [
        migrations.AddField(
            model_name="group",
            name="members",
            field=models.ManyToManyField(
                related_name="groups", to="userPortrait.userprofile"
            ),
        ),
    ]
