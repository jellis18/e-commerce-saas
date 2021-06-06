from django.urls import path

from ..views.products import create_product, delete_product, get_product, get_products, update_product

urlpatterns = [
    path("", get_products, name="products"),
    path("create", create_product, name="create-product"),
    path("<str:pk>", get_product, name="product"),
    path("update/<str:pk>", update_product, name="update-product"),
    path("delete/<str:pk>", delete_product, name="delete-product"),
]
