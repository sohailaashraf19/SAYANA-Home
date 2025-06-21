import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { FiArrowLeft } from "react-icons/fi";
import Loader from "../../Loader";

const OrdersDetails = () => {
  const { orderId } = useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);

  const order = {
    id: orderId,
    product: "Blush Up Cherry Blossom Body Mist",
    date: "May 9",
    status: "Confirmed",
    price: "119766.28 EGP",
    itemsCount: 4,
    paymentStatus: "Payment due",
    fulfillmentStatus: "Confirmed",
    link: "",
    customer: {
      name: "Sohaila Ashraf",
      email: "sohailaashraf01154207171@gmail.com",
      phone: "01154207171",
      address: "دريم لاند - طريق الواحات - مدينة ٦ اكتوبر",
      city: "Giza",
      country: "Egypt",
    },
    shippingMethod: "Standard",
    billingAddress: "دريم لاند - طريق الواحات - مدينة ٦ اكتوبر",
  };

  // Simulate loading delay
  useEffect(() => {
    const timer = setTimeout(() => {
      setLoading(false);
    }, 1000); // 1-second delay to show Loader
    return () => clearTimeout(timer);
  }, []);

  if (loading) {
    return (
      <div className="min-h-screen bg-[#FBFBFB] flex items-center justify-center p-6">
        <Loader />
      </div>
    );
  }

  return (
    <div className="bg-[#FBFBFB] min-h-screen">
      <div className="p-6 max-w-4xl mx-auto space-y-8">
        {/* Header Section */}
        <div className="flex items-center">
          <h2 className="text-2xl font-bold">Order #{order.id}</h2>
          <button className="text-sm text-white bg-[#003664] px-4 py-2 rounded-full ml-auto">
            Buy again
          </button>
        </div>

        {/* Order Status and Date */}
        <div className="flex flex-col items-start mb-4">
          <span className="text-green-600 font-semibold">✔ {order.status}</span>
          <span className="text-sm text-gray-500 mt-1">{order.date}</span>
        </div>

        {/* Promo & Payment Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {/* Promo Card - Modified */}
          <div className="bg-white rounded-xl shadow p-6 text-sm">
            <p className="text-gray-800 font-semibold">Give 15%, get 18% off</p>
            <p className="text-sm text-gray-600 mt-4">
              Share this link with a friend. When they make a purchase, you'll get 18% off your next one.
            </p>
            <a
              href={order.link}
              className="block text-blue-600 text-sm underline mt-2 break-words"
            >
              {order.link}
            </a>
          </div>

          {/* Payment Info */}
          <div className="bg-white rounded-xl shadow p-6 text-sm">
            <p className="text-gray-800">
              <strong className="text-lg">{order.price}</strong>
            </p>
            <p className="text-gray-500 mt-1">
              This order has a pending payment. The balance will be updated when payment is received.
            </p>
          </div>
        </div>

        {/* Fulfillment Status */}
        <div className="bg-white rounded-xl shadow p-6 text-sm col-span-1 md:col-span-2">
          <p className="text-gray-800 font-semibold">{order.fulfillmentStatus}</p>
          <p className="text-xs text-gray-500 mt-1">{order.date}</p>
          <p className="text-sm text-gray-600 mt-4">We've received your order.</p>
        </div>

        {/* Customer and Order Information */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {/* Left Column */}
          <div className="bg-white rounded-xl shadow p-6 space-y-4 text-sm w-full">
            <div className="space-y-6">
              <div>
                <h3 className="font-semibold text-gray-800">Contact information</h3>
                <p>{order.customer.name}</p>
                <p>{order.customer.email}</p>

                <h3 className="font-semibold text-gray-800">Shipping address</h3>
                <p>{order.customer.address}</p>
                <p>{order.customer.city}</p>
                <p>{order.customer.country}</p>
                <p>{order.customer.phone}</p>

                <h3 className="font-semibold text-gray-800">Shipping method</h3>
                <p>{order.shippingMethod}</p>
              </div>
            </div>
          </div>

          {/* Right Column */}
          <div className="bg-white rounded-xl shadow p-6 space-y-4 text-sm w-full">
            <div className="space-y">
              <h3 className="font-semibold text-gray-800">Payment</h3>
              <p>Cash on Delivery (COD)</p>
              <p>{order.price}</p>

              <h3 className="font-semibold text-gray-800">Billing address</h3>
              <p>{order.billingAddress}</p>
              <p>{order.customer.city}</p>
              <p>{order.customer.country}</p>
              <p>{order.customer.phone}</p>
            </div>
          </div>
        </div>

        {/* Order Summary */}
        <div className="bg-white rounded-xl shadow p-6 space-y-4 text-sm">
          <div>
            <h3 className="font-semibold text-gray-800">Order summary</h3>
            <div className="space-y-2">
              <div className="flex justify-between">
                <span>Compact Bar Sink</span>
                <span>5716.28 EGP</span>
              </div>
              <div className="flex justify-between">
                <span>New Shine Cage Swing</span>
                <span>2000.00 EGP</span>
              </div>
              <div className="flex justify-between">
                <span>Karla dinning room, 6pieces - art-166</span>
                <span>112000.00 EGP</span>
              </div>
            </div>
          </div>
          <div>
            <h3 className="font-semibold text-gray-800">Order totals</h3>
            <div className="space-y-2">
              <div className="flex justify-between">
                <span>Subtotal</span>
                <span>119716.28 EGP</span>
              </div>
              <div className="flex justify-between">
                <span>Shipping</span>
                <span>50.00 EGP</span>
              </div>
              <div className="flex justify-between font-bold">
                <span>Total</span>
                <span>119766.28 EGP</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default OrdersDetails;