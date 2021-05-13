from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from ..models import Order, OrderItem, Product, ShippingAddress
from ..serializers import OrderSerializer


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def add_order_items(request):
    user = request.user
    data = request.data

    order_items = data["orderItems"]

    if order_items and len(order_items) == 0:
        return Response({"detail": "No Order Items"}, status=status.HTTP_400_BAD_REQUEST)

    # create order
    order = Order.objects.create(
        user=user,
        paymentMethod=data["paymentMethod"],
        taxPrice=data["taxPrice"],
        shippingPrice=data["shippingPrice"],
        totalPrice=data["totalPrice"],
    )

    # create shipping address
    shipping_address = data["shippingAddress"]
    shipping = ShippingAddress.objects.create(
        order=order,
        address=shipping_address["address"],
        city=shipping_address["city"],
        postalCode=shipping_address["postalCode"],
        country=shipping_address["country"],
    )

    # create order items
    for item in order_items:
        product = Product.objects.get(_id=item["product"])
        order_item = OrderItem.objects.create(
            product=product,
            order=order,
            name=product.name,
            qty=item["qty"],
            price=item["price"],
            image=product.image.url,
        )

        # update stock
        product.countInStock -= order_item.qty
        product.save()

    serializer = OrderSerializer(order, many=False)
    return Response(serializer.data)
