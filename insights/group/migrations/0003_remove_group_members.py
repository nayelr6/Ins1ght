# Generated by Django 4.2 on 2023-07-03 15:32

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("group", "0002_group_members"),
    ]

    operations = [
        migrations.RemoveField(
            model_name="group",
            name="members",
        ),
    ]