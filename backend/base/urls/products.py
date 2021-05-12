from django.urls import path

from ..views.products import get_product, get_products

urlpatterns = [
    path("", get_products, name="products"),
    path("<str:pk>", get_product, name="product"),
]
