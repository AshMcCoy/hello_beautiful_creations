from django.urls import path
from .views import (
    remove_from_cart, 
    add_to_cart, 
    landing, 
    ProductView, 
    HomeView, 
    OrderSummaryView, 
    reduce_quantity_item, 
    CheckoutView, 
    PaymentView, 
    AddCouponView,
    RequestRefundView
)
#CreateItemForm

app_name = 'hbc_app'

urlpatterns = [
    path('', landing, name= 'landing'),
    path('home', HomeView.as_view(), name= 'home'),
    path('product/<pk>/', ProductView.as_view(), name= 'product'),
    path('add-to-cart/<pk>/', add_to_cart, name= 'add-to-cart'),
    path('add-coupon/', AddCouponView.as_view(), name= 'add-coupon'),
    path('remove-from-cart/<pk>/', remove_from_cart, name= 'remove-from-cart'),
    path('order-summary', OrderSummaryView.as_view(), name='order-summary'),
    path('reduce-quantity-item/<pk>/', reduce_quantity_item, name='reduce-quantity-item'),
    path('checkout', CheckoutView.as_view(), name= 'checkout'),
    path('payment/<payment_option>/', PaymentView.as_view(), name='payment'),
    path('request-refund/', RequestRefundView.as_view(), name='request-refund' )
]