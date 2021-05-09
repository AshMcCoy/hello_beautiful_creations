from django import forms
#from .models import Item
from django_countries.fields import CountryField
from django_countries.widgets import CountrySelectWidget

PAYMENT = (
    ('S', 'Stripe'),
    ('P', 'PayPal'),
)

#class ItemForm(forms.ModelForm):
    #class Meta:
        #model = Item
        #fields = ['shirt_color']

class CheckoutForm(forms.Form):
    street_address = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': '1234 Main St'
    }))

    apartment_address = forms.CharField(required= False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Apartment or suite'
    }))

    city = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control'
    }))
    
    state = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control'
    }))

    country = CountryField(blank_label='(select country)').formfield(widget=CountrySelectWidget(attrs={
        'class': 'custom-select d-block w-100'
    }))

    zip = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control'
    }))

    same_billing_address = forms.BooleanField(required= False)
    save_info = forms.BooleanField(required=False)
    payment_option = forms.ChoiceField(
        widget= forms.RadioSelect, choices=PAYMENT)