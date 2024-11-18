from django.shortcuts import render,redirect
from django.http import HttpResponse,HttpResponseRedirect
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from .forms import Signupform,UploadImageForm
from .models import UploadedImage

# Create your views here.
@login_required
def home(request):
    return render(request,'home.html')
@login_required
def images(request):
    if request.method == 'POST':
        form = UploadImageForm(request.POST,request.FILES)
        if form.is_valid():
            form.save()
            return redirect('Webpage:display_images')
    else:
        form = UploadImageForm()
        images = UploadedImage.objects.all()
        return render(request,'image.html',{'form':form,'images':images})

def signup(request):
    if request.method =='POST':
        form = Signupform(request.POST or None)
        if form.is_valid():
            form.save()
            return redirect('Webpage:login')
    else:
        form = Signupform()

    return render(request,'registration/signup.html',{"form":form})
