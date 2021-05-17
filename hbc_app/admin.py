from django.contrib import admin
from .models import Item, OrderItem, Order, Coupon, Refund, Address, Category



class ItemAdmin(admin.ModelAdmin):
    list_display = [
        'id', 
        'item_name', 
        'category_name',
        'available', 
        'image', 
        'price'
    ]
    list_display_links = ['id', 'item_name']
    list_editable= ['category_name']
    list_filter = ['price']
    search_fields = ['item_name', 'category']

def make_order_process(modeladmin, request, queryset):
    queryset.update(in_process=True)

make_order_process.short_description= "Update orders to In-Process"

def make_order_shipped(modeladmin, request, queryset):
    queryset.update(in_process=False, being_delivered=True)

make_order_shipped.short_description= "Update orders to shipped"

def make_order_received(modeladmin, request, queryset):
    queryset.update(being_delivered=False, received= True)

make_order_received.short_description = "Update orders to customer received"

def make_refund_accepted(modeladmin, request, queryset):
    queryset.update(refund_requested=False, refund_granted=True)

make_refund_accepted.short_description= "Update orders to refund granted"

class OrderAdmin(admin.ModelAdmin):
    list_display = [
        'id', 
        'user', 
        'ordered', 
        'ordered_date', 
        'coupon',
        'shipping_address',
        'billing_address', 
        'in_process',
        'being_delivered', 
        'received', 
        'refund_requested', 
        'refund_granted'
    ]
    list_display_links = [
        'id', 
        'user', 
        'shipping_address',
        'billing_address', 
        'coupon'
    ]
    list_filter = [
        'ordered', 
        'in_process',
        'being_delivered',
        'received',
        'refund_requested',
        'refund_granted'
    ]
    search_fields = [
        'user', 
        'ref_code',
        'ordered_date', 
        'billing_address']
    actions= [make_order_process, make_order_shipped, make_order_received, make_refund_accepted]

class OrderItemAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'item', 'quantity']
    list_display_links = ['id', 'user', 'item']
    list_filter = ['id', 'user']
    search_fields = ['item', 'user']
    
class AddressAdmin(admin.ModelAdmin):
    list_display = [
        'user',
        'street_address',
        'apartment_address',
        'city',
        'state',
        'country',
        'zip',
        'address_type',
        'default'
    ]
    list_filter = ['default', 'address_type']
    search_fields = ['user', 'street_address', 'apartment_address', 'zip']

admin.site.register(Item, ItemAdmin)
admin.site.register(OrderItem, OrderItemAdmin)
admin.site.register(Order, OrderAdmin)
admin.site.register(Coupon)
admin.site.register(Address, AddressAdmin)
admin.site.register(Category)

# Register your models here.
