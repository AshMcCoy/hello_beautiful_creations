from django.conf import settings
from django.db import models
from django.shortcuts import reverse
from django_countries.fields import CountryField

CATEGORY = (
    ('RB', 'Ribbon Bows'),
    ('CB', 'Cloth Bows'),
    ('LB', 'Leather Bows'),
    ('E', 'Earrings'),
    ('NCK', 'Necklaces'),
    ('BC', 'Baby Clothing'),
    ('T', 'Tees'),
    ('PG', 'Phone Grips'),
    ('M', 'Misc'),
)

CHOICES = (
    ('Dark Heather', 'Dark Heather'),
    ('Heather Navy', 'Heather Navy'),
    ('Heather Indigo', 'Heather Indigo'),
    ('Heather Royal', 'Heather Royal'),
    ('Heather Sapphire', 'Heather Sapphire'),
    ('Heather Galapagos Blue', 'Heather Galapagos Blue'),
    ('Heather Seafoam', 'Heather Seafoam'),
    ('Heather Irish Green', 'Heather Irish Green'),
    ('Heather Military Green', 'Heather Military Green'),
    ('Heather Maroon', 'Heather Maroon'),
    ('Heather Purple', 'Heather Purple'),
    ('Heather Berry', 'Heather Berry'),
    ('Heather Helonica', 'Heather Helonica'),
    ('Heather Coral Silk', 'Heather Coral Silk'),
    ('Heather Orange', 'Heather Orange'),
    ('Heather Cardinal', 'Heather Cardinal'),
    ('Heather Red', 'Heather Red'),
)

class Item(models.Model):
    item_name = models.CharField(max_length= 100)
    price = models.FloatField()
    discount_price = models.FloatField(blank= True, null= True)
    category = models.CharField(choices= CATEGORY, max_length= 3)
    image = models.ImageField(null= True, blank= True)
    description = models.TextField()
    shirt_color = models.CharField(max_length= 50, choices=CHOICES, default= 'Dark Heather')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    #"user_ordered"= []

    def __str__(self):
        return self.item_name
    
    def get_absolute_url(self):
        return reverse("hbc_app:product", kwargs={
            "pk": self.pk
        })

    def get_add_to_cart_url(self):
        return reverse("hbc_app:add-to-cart", kwargs={
            "pk": self.pk
        })

    def get_remove_from_cart_url(self):
        return reverse("hbc_app:remove-from-cart", kwargs={
            "pk": self.pk
        })

class OrderItem(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete= models.CASCADE)
    ordered = models.BooleanField(default= False)
    item = models.ForeignKey(Item, related_name= "user_ordered", on_delete= models.CASCADE)
    quantity = models.IntegerField(default= 1)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    #"complete_order"= []

    def __str__(self):
        return f"{self.quantity} of {self.item.item_name}"

    #returns total price value of each product item
    def get_total_item_price(self):
        return self.quantity * self.item.price

    #returns the total price value of ea. product item based on discount
    def get_discount_item_price(self):
        return self.quantity * self.item.discount_price

    #returns the value of the price saved from existing discounts
    def get_amount_saved(self):
        return self.get_total_item_price() - self.get_discount_item_price()

    #returns which function is used as a price determinant (whether using orignal or discount price)
    def get_final_price(self):
        if self.item.discount_price:
            return self.get_discount_item_price()
        return self.get_total_item_price()

class Order(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete= models.CASCADE)
    items = models.ManyToManyField(OrderItem, related_name= "complete_order")
    start_date = models.DateTimeField(auto_now_add=True)
    ordered_date= models.DateTimeField()
    ordered = models.BooleanField(default= False)
    checkout_address = models.ForeignKey('CheckoutAddress', related_name= "user_checkout_address", on_delete=models.SET_NULL, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.user.username

    #returns the value of the total price of all ordered product items
    def get_total_price(self):
        total = 0
        for order_item in self.items.all():
            total += order_item.get_final_price()
        return total

class CheckoutAddress(models.Model):
    user= models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    street_address = models.CharField(max_length= 100)
    apartment_address = models.CharField(max_length= 100)
    country = CountryField(multiple= False)
    zip = models.CharField(max_length= 10)

    def __str__(self):
        return self.user.username

# Create your models here.
