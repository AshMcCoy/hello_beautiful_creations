# Generated by Django 2.2 on 2021-05-03 16:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('hbc_app', '0003_auto_20210427_0713'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='item',
            name='label',
        ),
        migrations.AddField(
            model_name='item',
            name='image',
            field=models.ImageField(blank=True, null=True, upload_to=''),
        ),
    ]