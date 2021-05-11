from rest_framework.decorators import api_view
from rest_framework.response import Response

from .products import products


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
    return Response(products)


@api_view(["GET"])
def get_product(request, pk):
    for product in products:
        if product["_id"] == pk:
            return Response(product)
    return Response()
