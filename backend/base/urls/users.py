from django.urls import path

from ..views.users import MyTokenObtainPairView, get_user_profile, get_users, register_user, update_user_profile

urlpatterns = [
    path("login/", MyTokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("register/", register_user, name="register"),
    path("profile/", get_user_profile, name="user_profile"),
    path("profile/update/", update_user_profile, name="user_profile_update"),
    path("", get_users, name="users"),
]
