from django.urls import path,include
from . import views


urlpatterns = [

  path('accounts/', include('django.contrib.auth.urls')),
  path('signup/',views.signup,name='signup'),
  path('',views.home,name='home'),
  path('images/',views.images,name='display_images'),
]