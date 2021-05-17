from django.db.models import Q
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.exceptions import ObjectDoesNotExist
from django.shortcuts import render, get_object_or_404, redirect
from django.views.generic import ListView, DetailView, View
from django.utils import timezone
from .forms import CheckoutForm, CouponForm, RefundForm
from .models import Item, Order, OrderItem, Address, Coupon, Refund, Category
import random
import string
import re


def landing(request):
    return render(request, 'landing.html')
class HomeView(ListView):
    model = Item
    paginate_by = 12
    template_name = "home.html"

    def get_context_data(self, **kwargs):
        context = super(HomeView, self).get_context_data(**kwargs)
        context['items'] = Item.objects.all()
        context['categories'] = Category.objects.all()
        return context

def create_ref_code():
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=20))

def category(request, pk):
    category = get_object_or_404(Category, pk=pk)
    context = {
        'all_categories': Category.objects.all(),
        'this_category': category
    }
    return render(request, 'category.html', context)
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
            messages.warning(self.request, "You do not have an active order")
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

def is_valid_form(values):
    valid= True
    for field in values:
        if field == '':
            valid = False
    return valid
class CheckoutView(View):
    def get(self, *args, **kwargs):
        try:
            order = Order.objects.get(user=self.request.user, ordered=False)
            form = CheckoutForm()
            context = {
                'form': form,
                'couponform': CouponForm(),
                'order': order
            }

            shipping_address_qs = Address.objects.filter(
                user=self.request.user,
                address_type= 'S',
                default= True
            )

            if shipping_address_qs.exists():
                context.update({ 'default_shipping_address': shipping_address_qs[0] })

            billing_address_qs = Address.objects.filter(
                user=self.request.user,
                address_type= 'B',
                default= True
            )
            if billing_address_qs.exists():
                context.update({ 'default_billing_address': billing_address_qs[0] })

            return render(self.request, 'checkout.html', context)
        except ObjectDoesNotExist:
            messages.warning(self.request, "You do not have an active order")
            return redirect('hbc_app:checkout')
            
    
    def post(self, *args, **kwargs):
        form = CheckoutForm(self.request.POST or None)
        try:
            order = Order.objects.get(user=self.request.user, ordered= False)
            if form.is_valid():

                use_default_shipping= form.cleaned_data.get('use_default_shipping')
                if use_default_shipping:
                    print("Using the default shipping address")
                    address_qs = Address.objects.filter(
                        user=self.request.user,
                        address_type= 'S',
                        default= True
                    )
                    if address_qs.exists():
                        shipping_address= address_qs[0]
                        order.shipping_address = shipping_address
                        order.save()
                    else: 
                        messages.info(self.request, "No default shipping address available")
                        return redirect("hbc_app:checkout")
                else:
                    print("User is entering a new shipping address")
                    shipping_address1 = form.cleaned_data.get('shipping_address')
                    shipping_address2 = form.cleaned_data.get('shipping_address2')
                    shipping_city = form.cleaned_data.get('shipping_city')
                    shipping_state= form.cleaned_data.get('shipping_state')
                    shipping_country = form.cleaned_data.get('shipping_country')
                    shipping_zip = form.cleaned_data.get('shipping_zip')

                    if is_valid_form(['shipping_address1', 'shipping_city', 'shipping_state', 'shipping_country', 'shipping_zip']):
                        shipping_address = Address(
                            user = self.request.user,
                            street_address = shipping_address1,
                            apartment_address = shipping_address2,
                            city = shipping_city,
                            state = shipping_state,
                            country = shipping_country,
                            zip = shipping_zip,
                            address_type= 'S'
                        )
                        shipping_address.save()

                        order.shipping_address = shipping_address
                        order.save()

                        set_default_shipping= form.cleaned_data.get('set_default_shipping')
                        if set_default_shipping:
                            shipping_address.default= True
                            shipping_address.save()

                    else:
                        messages.info(self.request, "Please fill in the required shipping address fields")

                use_default_billing = form.cleaned_data.get('use_default_billing')
                same_billing_address = form.cleaned_data.get('same_billing_address')

                if same_billing_address:
                    billing_address= shipping_address
                    billing_address.pk = None
                    billing_address.save()
                    billing_address.address_type = 'B'
                    billing_address.save()
                    order.billing_address = billing_address
                    order.save()
                elif use_default_billing:
                    print("Using the dafault billing address")
                    address_qs= Address.objects.filter(
                        user=self.request.user,
                        address_type= 'B',
                        default= True 
                    )
                    if address_qs.exists():
                        billing_address = address_qs[0]
                        order.billing_address = billing_address
                        order.save()
                    else:
                        messages.info(self.request, "No default billing address available")
                        return redirect('hbc_app:checkout')
                else:
                    print("User is entering a new billing address")
                    billing_address1= form.cleaned_data.get('billing_address')
                    billing_address2= form.cleaned_data.get('billing_address2')
                    billing_city= form.cleaned_data.get('billing_city')
                    billing_state= form.cleaned_data.get('billing_state')
                    billing_country= form.cleaned_data.get('billing_country')
                    billing_zip= form.cleaned_data.get('billing_zip')

                    if is_valid_form(['billing_address1','billing_city', 'billing_state', 'billing_country', 'billing_zip']):
                        billing_address = Address(
                            user=self.request.user,
                            street_address=billing_address1,
                            apartment_address= billing_address2,
                            city= billing_city,
                            state= billing_state,
                            country= billing_country,
                            zip= billing_zip,
                            address_type= 'B'
                        )
                        billing_address.save()

                        order.billing_address= billing_address
                        order.save()

                        set_default_billing= form.cleaned_data.get('set_default_billing')
                        if set_default_billing:
                            billing_address.default= True
                            billing_address.save()

                    else:
                        messages.info(self.request, "Please fill in the required billing address fields")

                payment_option = form.cleaned_data.get('payment_option')

                if payment_option == 'S':
                    return redirect('hbc_app:payment', payment_option='stripe')
                elif payment_option == 'P':
                    return redirect('hbc_app:payment', payment_option='paypal')
                else:
                    messages.warning(self.request, "Invalid payment option selected")
                    return redirect('hbc_app:checkout')
        except ObjectDoesNotExist:
            messages.warning(self.request, "You do not have an active order")
            return redirect('hbc_app:order-summary')

class PaymentView(View):
    def get(self, *args, **kwargs):
        #order
        order = Order.objects.get(user=self.request.user, ordered=False)
        if order.billing_address:
            context = {
                'order': order
            }
            return render(self.request, "payment.html", context)
        else:
            messages.warning(self.request, "You have not entered a billing address")
            return redirect('hbc_app:checkout')

            #TODO:need to create payment

            #TODO:assign the payment to the order

            #TODO: assign the ref code in the assigned order
                    #order.ref_code = create_ref_code()

def get_coupon(request, code):
    try:
        coupon= Coupon.objects.get(code=code)
        return coupon
    except ObjectDoesNotExist:
        messages.info(request, "This coupon does not exist")
        return redirect("hbc_app:checkout")

class AddCouponView(View):
    def post(self, *args, **kwargs):
        form= CouponForm(self.request.POST or None)
        if form.is_valid():
            try:
                code= form.cleaned_data.get('code')
                order = Order.objects.get(user=self.request.user, ordered=False)
                order.coupon = get_coupon(self.request, code)
                order.save()
                messages.success(self.request, "Successfully added coupon")
                return redirect("hbc_app:checkout")
            except ObjectDoesNotExist:
                messages.info(self.request, "You do not have an active order")
                return redirect("hbc_app:checkout")

class RequestRefundView(View):
    def get(self, *args, **kwargs):
        form = RefundForm()
        context = {
            'form': form
        }
        return render(self.request, "request_refund.html", context)
    def post(self, *args, **kwargs):
        form = RefundForm(self.request.POST)
        if form.is_valid():
            ref_code = form.cleaned_data.get('ref_code')
            message = form.cleaned_data.get('message')
            email= form.cleaned_data.get('email')
            #edit the order
            try:
                order= Order.objects.get(ref_code= ref_code)
                order.refund_requested = True
                order.save()

                #store the refund
                refund = Refund()
                refund.order= order
                refund.reason = message
                refund.email = email
                refund.save()
                
                messages.info(self.request, "Your request was received.")
                return redirect("hbc_app:request-refund")

            except ObjectDoesNotExist:
                messages.info(self.request, "This order does not exist")
                return redirect("hbc_app:request-refund")

def normalize_query(query_string, findterms=re.compile(r'"([^"]+)"|(\S+)').findall, normspace=re.compile(r'\s{2,}').sub):
    ''' Splits the query string in invidual keywords, getting rid of unecessary spaces
        and grouping quoted words together.
        Example:
        . . . normalize_query('  some random  words "with   quotes  " and   spaces')
        ['some', 'random', 'words', 'with quotes', 'and', 'spaces']

'''
    return [normspace(' ', (t[0] or t[1]).strip()) for t in findterms(query_string)]

def get_query(query_string, search_fields):
    ''' Returns a query, that is a combination of Q objects. That combination
        aims to search keywords within a model by testing the given search fields.
    '''
    query = None # Query to search for every search term
    terms = normalize_query(query_string)
    for term in terms:
        or_query = None # Query to search for a given term in each field
        for field_name in search_fields:
            q = Q(**{"%s__icontains" % field_name: term})
            if or_query is None:
                or_query = q
            else:
                or_query = or_query | q
        if query is None:
            query = or_query
        else:
            query = query & or_query
    return query

def search(request):
    query_string = ''
    found_entries = None
    if ('q' in request.GET) and request.GET['q'].strip():
        query_string = request.GET['q']
        entry_query = get_query(query_string, ['item_name', 'description'])
        found_entries = Item.objects.filter(entry_query).order_by('id')
    context = { 
        'query_string': query_string,
        'found_entries': found_entries,
        'categories': Category.objects.all()
    }
    return render(request, 'search.html', context)