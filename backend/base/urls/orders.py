from django.urls import path

from ..views import orders

urlpatterns = [path("add/", orders.add_order_items, name="orders_add")]
