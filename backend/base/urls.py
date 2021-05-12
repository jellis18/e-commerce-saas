from django.urls import path

from . import views

urlpatterns = [
    path("products/", views.get_products, name="products"),
    path("products/<str:pk>", views.get_product, name="product"),
    path("users/login/", views.MyTokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("users/register/", views.register_user, name="register"),
    path("users/profile/", views.get_user_profile, name="user_profile"),
    path("users/", views.get_users, name="users"),
]
