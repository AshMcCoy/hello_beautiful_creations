from django.contrib import admin
from .models import Item, OrderItem, Order

class ItemAdmin(admin.ModelAdmin):
    list_display = ('image', 'id', 'item_name', 'price')
    list_display_links = ('id', 'item_name')
    list_filter = ('category', 'price')
    search_fields = ('item_name', 'category')
    


admin.site.register(Item, ItemAdmin)
admin.site.register(OrderItem)
admin.site.register(Order)

# Register your models here.
