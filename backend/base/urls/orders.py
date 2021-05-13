from django.urls import path

from ..views import orders

urlpatterns = [
    path("add/", orders.add_order_items, name="orders_add"),
    path("myorders/", orders.get_my_orders, name="my_orders"),
    path("<str:pk>/", orders.get_order_by_id, name="get_order_by_id"),
    path("<str:pk>/pay/", orders.update_order_to_paid, name="paid"),
]
