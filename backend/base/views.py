from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Product
from .serializers import ProductSerializer


@api_view(["GET"])
def get_routes(request):
    routes = [
        "/api/products",
        "api/products/create",
        "api/products/upload",
        "api/products/<id>/reviews/",
        "/api/products/top/",
        "/api/products/<id>/",
        "/api/products/delete/<id>/",
        "/api/products/<update>/<id>/",
    ]
    return Response(routes)


@api_view(["GET"])
def get_products(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)


@api_view(["GET"])
def get_product(request, pk):
    product = Product.objects.get(_id=pk)
    serializer = ProductSerializer(product, many=False)
    return Response(serializer.data)
