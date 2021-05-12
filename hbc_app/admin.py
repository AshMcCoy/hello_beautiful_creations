from django.contrib import admin
from .models import Item, OrderItem, Order, Coupon

class ItemAdmin(admin.ModelAdmin):
    list_display = ('id', 'item_name', 'available', 'image', 'category', 'price')
    list_display_links = ('id', 'item_name')
    list_filter = ('category', 'price')
    search_fields = ('item_name', 'category')

class OrderAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'ordered', 'ordered_date', 'billing_address')
    list_display_links = ('id', 'ordered_date')
    list_filter = ('ordered_date', 'items',)
    search_fields = ('user', 'ordered_date', 'billing_address')

class OrderItemAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'item', 'quantity')
    list_display_links = ('id', 'user', 'item')
    list_filter = ('id', 'user')
    search_fields = ('item', 'user')
    

admin.site.register(Item, ItemAdmin)
admin.site.register(OrderItem, OrderItemAdmin)
admin.site.register(Order, OrderAdmin)
admin.site.register(Coupon)

# Register your models here.
