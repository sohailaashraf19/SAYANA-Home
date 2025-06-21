import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate, Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import axios from 'axios';
import Loader from '../../Loader';

const containerVariants = {
  hidden: { opacity: 0, y: 30 },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.6,
      when: "beforeChildren",
      staggerChildren: 0.1,
    },
  },
};

const itemVariants = {
  hidden: { opacity: 0, x: -20 },
  visible: {
    opacity: 1,
    x: 0,
    transition: { duration: 0.4 },
  },
};

function OrderSummary() {
  const location = useLocation();
  const navigate = useNavigate();
  const orderData = location.state;
  const cartItems = location.state?.cartItems || []; // Use passed cartItems or empty array
  const shippingAddress = location.state?.shippingAddress || {}; // Use passed shippingAddress or empty object

  console.log('Received cartItems in OrderSummary:', cartItems); // Debug log
  console.log('Received shippingAddress in OrderSummary:', shippingAddress); // Debug log

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!orderData) {
      setError("No order data found");
      setLoading(false);
      const timer = setTimeout(() => {
        navigate('/buyer/cart');
      }, 2000);
      return () => clearTimeout(timer);
    }
    setLoading(false);
  }, [orderData, navigate]);

  const clearCart = async () => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId || !cartItems.length) return;

    try {
      for (const item of cartItems) {
        await axios.delete(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/cartdelet/${item.product_id}`,
          {
            data: { buyer_id: buyerId },
          }
        );
      }
    } catch (error) {
      console.error("Error clearing cart:", error);
    }
  };

  const handleContinueShopping = () => {
    clearCart();
    navigate('/buyer');
  };

  const handleViewOrderDetails = () => {
    navigate('/buyer/order-details', { state: orderData });
  };

  if (loading) return <Loader />;

  if (error) {
    return (
      <div className="min-h-screen bg-gray-100 flex items-center justify-center p-6">
        <div className="bg-white rounded-lg shadow-lg p-8 max-w-md w-full text-center">
          <div className="text-red-600 mb-4">
            <svg className="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h2 className="text-xl font-bold text-gray-800">Error Loading Order</h2>
            <p className="text-gray-600 mt-2">{error}</p>
            <p className="text-gray-500 mt-2">Redirecting to Cart...</p>
          </div>
          <Link to="/buyer/cart">
            <button className="bg-[#003664] text-white py-2 px-6 rounded-full hover:bg-[#002a4f] transition-colors duration-300">
              Back to Cart
            </button>
          </Link>
        </div>
      </div>
    );
  }

  const subtotal = cartItems.reduce((total, item) => total + item.price * item.quantity, 0);
  const shippingPrice = parseFloat(orderData.shipping_price || 0);
  const totalPrice = parseFloat(orderData.total_price || subtotal + shippingPrice);

  return (
    <motion.div
      className="min-h-screen bg-gray-100 p-6"
      variants={containerVariants}
      initial="hidden"
      animate="visible"
    >
      <div className="max-w-4xl mx-auto">
        {/* Success Header */}
        <motion.div 
          className="bg-white rounded-lg shadow-lg p-8 mb-6 text-center"
          variants={itemVariants}
        >
          <div className="text-green-600 mb-4">
            <svg className="w-20 h-20 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h1 className="text-3xl font-bold text-gray-800">Order Placed Successfully!</h1>
            <p className="text-gray-600 mt-2">Thank you for your purchase. Your order has been confirmed.</p>
          </div>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Order Items */}
          <motion.div 
            className="lg:col-span-2 bg-white rounded-lg shadow-lg p-6"
            variants={itemVariants}
          >
            <h2 className="text-xl font-bold text-gray-800 mb-4">Order Items</h2>
            <div className="space-y-4">
              {cartItems.map((item, index) => (
                <motion.div
                  key={item.product_id}
                  className="flex items-center p-4 bg-gray-50 rounded-lg"
                  variants={itemVariants}
                  custom={index}
                >
                  <img
                    src={item.image}
                    alt={item.name}
                    className="w-16 h-16 object-cover rounded-md mr-4"
                    onError={(e) => {
                      e.target.src = "https://via.placeholder.com/100";
                    }}
                  />
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-800">{item.name}</h3>
                    <p className="text-gray-600">Price: {item.price.toFixed(2)} EGP</p>
                    <p className="text-gray-600">Quantity: {item.quantity}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold text-gray-800">
                      {(item.price * item.quantity).toFixed(2)} EGP
                    </p>
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.div>

          {/* Order Summary */}
          <motion.div 
            className="bg-white rounded-lg shadow-lg p-6 h-fit"
            variants={itemVariants}
          >
            <h2 className="text-xl font-bold text-gray-800 mb-4">Order Summary</h2>
            
            <div className="space-y-3 text-gray-700">
              <div className="flex justify-between">
                <span>Order ID:</span>
                <span className="font-semibold">{orderData.order?.id || orderData.id || 'N/A'}</span>
              </div>
              
              <div className="flex justify-between">
                <span>Payment Method:</span>
                <span className="capitalize font-semibold">
                  {orderData.order?.payment_method || orderData.payment_method || 'N/A'}
                </span>
              </div>
              
              <div className="flex justify-between">
                <span>City:</span>
                <span className="font-semibold">{orderData.city_name || 'N/A'}</span>
              </div>
              {/* Display Street */}
              {shippingAddress.street && (
                <div className="flex justify-between">
                    <span>Street:</span>
                    <span className="font-semibold">{shippingAddress.street || 'N/A'}</span>
                 
                </div>
              )}
              
              <hr className="my-3" />
              
              <div className="flex justify-between">
                <span>Subtotal:</span>
                <span>{subtotal.toFixed(2)} EGP</span>
              </div>
              
              <div className="flex justify-between">
                <span>Shipping:</span>
                <span>{shippingPrice.toFixed(2)} EGP</span>
              </div>
              
              <hr className="my-3" />
              
              <div className="flex justify-between font-bold text-lg text-gray-800">
                <span>Total:</span>
                <span>{totalPrice.toFixed(2)} EGP</span>
              </div>
              
              {orderData.payment_img_url && (
                <div className="mt-4">
                  <p className="text-sm text-gray-600 mb-2">Payment Screenshot:</p>
                  <img 
                    src={orderData.payment_img_url} 
                    alt="Payment Screenshot" 
                    className="w-full h-32 object-cover rounded-md border"
                  />
                </div>
              )}
            </div>

            <div className="mt-6 space-y-3">
              
              
              <button
                onClick={handleContinueShopping}
                className="w-full bg-[#003664] text-white py-3 rounded-full hover:bg-gray-300 transition-colors duration-300 font-semibold"
              >
                Continue Shopping
              </button>
            </div>
          </motion.div>
        </div>
      </div>
    </motion.div>
  );
}

export default OrderSummary;