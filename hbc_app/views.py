from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.exceptions import ObjectDoesNotExist
from django.shortcuts import render, get_object_or_404, redirect
from django.views.generic import ListView, DetailView, View
from django.utils import timezone
from .forms import CheckoutForm
from .models import (Item, Order, OrderItem, BillingAddress)

def landing(request):
    return render(request, 'landing.html')
class HomeView(ListView):
    model = Item
    paginate_by = 12
    template_name = "home.html"

class ProductView(DetailView):
    model= Item
    template_name= "product.html"

def is_valid_form(values):
    valid = True
    for field in values:
        if field == '':
            valid = False
    return valid

@login_required
def add_to_cart(request, pk):
    item = get_object_or_404(Item, pk=pk)
    order_item, created = OrderItem.objects.get_or_create(
        item= item,
        user = request.user,
        ordered = False
    )
    order_qs = Order.objects.filter(user=request.user, ordered = False)

    if order_qs.exists():
        order = order_qs[0]
        # check if the order item is in the order
        if order.items.filter(item__pk=item.pk).exists():
            order_item.quantity += 1
            order_item.save()
            messages.info(request, "This item quantity was updated")
            return redirect("hbc_app:order-summary")
        else:
            order.items.add(order_item)
            messages.info(request, "Item added to your cart")
            return redirect ("hbc_app:order-summary")

    else:
        ordered_date = timezone.now()
        order = Order.objects.create(user=request.user, ordered_date= ordered_date)
        order.items.add(order_item)
        messages.info(request, "Item added to your cart")
        return redirect("hbc_app:order-summary")

@login_required
def remove_from_cart(request, pk):
    item= get_object_or_404(Item, pk=pk)
    order_qs = Order.objects.filter(
        user= request.user,
        ordered= False
    )
    if order_qs.exists():
        order = order_qs[0]
        #check if the order item is in the order
        if order.items.filter(item__pk=item.pk).exists():
            order_item = OrderItem.objects.filter(
                item= item,
                user= request.user,
                ordered= False
            ) [0]
            order_item.delete()
            messages.info(request, "Item \""+order_item.item.item_name+"\" removed from your cart")
            return redirect("hbc_app:order-summary")
        else:
            messages.info(request, "This Item is not in your cart")
            return redirect("hbc_app:order-summary", pk=pk)
    else:
        messages.info(request, "You do not have an active order")
        return redirect("hbc_app:order-summary", pk=pk)

class OrderSummaryView(LoginRequiredMixin, View):
    def get(self, *args, **kwargs):

        try: 
            order = Order.objects.get(user=self.request.user, ordered= False)
            context = {
                'object': order
            }
            return render(self.request, 'order_summary.html', context)
        except ObjectDoesNotExist:
            messages.error(self.request, "You do not have an active order")
            return redirect("/")

@login_required
def reduce_quantity_item(request, pk):
    item = get_object_or_404(Item, pk=pk)
    order_qs = Order.objects.filter(
        user = request.user,
        ordered = False
    )
    if order_qs.exists():
        order = order_qs[0]
        if order.items.filter(item__pk=item.pk).exists():
            order_item = OrderItem.objects.filter(
                item = item,
                user = request.user,
                ordered = False
            )[0]
            if order_item.quantity > 1:
                order_item.quantity -= 1
                order_item.save()
            else:
                order_item.delete()
            messages.info(request, "Item quantity updated")
            return redirect("hbc_app:order-summary")
        else:
            messages.info(request, "This Item is not in your cart")
            return redirect("hbc_app:order-summary")
    else: 
        messages.info(request, "You do not have an Order")
        return redirect("hbc_app:order-summary")

class CheckoutView(View):
    def get(self, *args, **kwargs):
        form = CheckoutForm()
        context = {
            'form': form
        }
        return render(self.request, 'checkout.html', context)

def post(self, *args, **kwargs):
    form = CheckoutForm(self.request.POST or None)

    try:
        order = Order.objects.get(user=self.request.user, ordered= False)
        if form.is_valid():
            street_address = form.cleaned_data.get('street_address')
            apartment_address = form.cleaned_data.get('apartment_address')
            city = form.cleaned_data.get('city')
            state= form.cleaned_data.get('state')
            country = form.cleaned_data.get('country')
            zip = form.cleaned_data.get('zip')
            #TODO: add functionality to these fields
            #same_shipping_address = form.cleaned_data.get('same_shipping_address')
            #save_info = form.cleaned_data.get('save_info')
            payment_option = form.cleaned_data.get('payment_option')

            billing_address = BillingAddress(
                user = self.request.user,
                street_address = street_address,
                apartment_address = apartment_address,
                city = city,
                state = state,
                country = country,
                zip = zip
            )
            billing_address.save()
            order.billing_address = billing_address
            order.save()
            #TODO: add redirect to the selected payment option
            return redirect('hbc_app:checkout')
        messages.warning(self.request, "Failed Checkout")
        return redirect('hbc_app:checkout')

    except ObjectDoesNotExist:
        messages.error(self.request, "You do not have an active order")
        return redirect('hbc_app:order-summary')

class PaymentView(View):
    def get(self, *args, **kwargs):
        #order
        return render(self.request, "payment.html")


# Create your views here.
