# Generated by Django 2.2 on 2021-05-07 14:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('hbc_app', '0006_auto_20210504_0814'),
    ]

    operations = [
        migrations.AlterField(
            model_name='item',
            name='category',
            field=models.CharField(choices=[('RB', 'Ribbon Bows'), ('CB', 'Cloth Bows'), ('LB', 'Leather Bows'), ('HW', 'Head Wraps'), ('E', 'Earrings'), ('NCK', 'Necklaces'), ('BC', 'Baby Clothing'), ('T', 'Tees'), ('PG', 'Phone Grips'), ('M', 'Misc')], max_length=3),
        ),
    ]
