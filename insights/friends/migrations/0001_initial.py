# Generated by Django 4.2.2 on 2023-06-23 17:06

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('userPortrait', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Friends',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('blocked', models.BooleanField(default=False)),
                ('friend_1', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='friend_1', to='userPortrait.userprofile')),
                ('friend_2', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='friend_2', to='userPortrait.userprofile')),
            ],
        ),
    ]