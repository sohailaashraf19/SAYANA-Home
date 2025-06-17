import { Link } from "react-router-dom";
import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import axios from "axios";
import trash from "../../../../../../assets/images/tr.svg";
import emptyCartImage from "../../../../../../assets/images/cart empty.jpg";
import Loader from "../../Loader";

function Cart() {
  const [cart, setCart] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  const itemVariants = {
    initial: { opacity: 0, x: -20 },
    animate: (index) => ({
      opacity: 1,
      x: 0,
      transition: { delay: index * 0.1, duration: 0.5, ease: "easeOut" },
    }),
    hover: { scale: 1.02, transition: { duration: 0.3 } },
    exit: { opacity: 0, x: 20, transition: { duration: 0.3, ease: "easeIn" } },
  };

  const summaryVariants = {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0, transition: { duration: 0.5, delay: 0.3, ease: "easeOut" } },
  };

  const handleQuantityChange = (productId, change) => {
    setCart((prevCart) =>
      prevCart.map((item) =>
        item.product_id === productId
          ? { ...item, quantity: Math.max(1, item.quantity + change) }
          : item
      )
    );
  };

  const handleRemoveItem = async (productId) => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) return;

    try {
      const response = await axios.delete(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/cartdelet/${productId}`,
        {
          data: { buyer_id: buyerId },
        }
      );
      if (response.status === 200) {
        setCart((prevCart) => prevCart.filter((item) => item.product_id !== productId));
      }
    } catch (error) {
      console.error("Error removing item from cart:", error);
    }
  };

  useEffect(() => {
    const fetchCart = async () => {
      const buyerId = localStorage.getItem("buyer_id");
      if (!buyerId) return;

      try {
        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/getcart`,
          { params: { buyer_id: buyerId } }
        );

        const baseUrl = "https://olivedrab-llama-457480.hostingersite.com/";
        const cartData = response.data.map((item) => {
          const imagePath = item.product?.images?.[0]?.image_path;
          const imageUrl = imagePath
            ? `${baseUrl}${encodeURI(imagePath)}`
            : "https://via.placeholder.com/100";

          return {
            product_id: item.product.product_id,
            name: item.product.name,
            price: parseFloat(item.product.price),
            quantity: item.quantity || 1,
            image: imageUrl,
          };
        });

        setCart(cartData);
      } catch (error) {
        console.error("Error fetching cart:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchCart();
  }, []);

  const shippingFee = 50.0;
  const subtotal = cart.reduce((total, item) => total + item.price * item.quantity, 0);
  const total = subtotal + shippingFee;

  if (isLoading) return <Loader />;

  return (
    <div className="p-6 bg-[#F8FAFC] min-h-screen">
      <h1 className="text-3xl font-bold text-[#1F2937] mb-8">Shopping Cart</h1>
      {cart.length === 0 ? (
        <div className="flex flex-col items-center justify-center h-[calc(100vh-200px)] bg-white rounded-2xl shadow-lg p-8">
          <img
            src={emptyCartImage}
            alt="Empty Cart"
            className="w-48 h-48 mb-6 object-contain"
            onError={(e) => {
              e.target.src = "https://via.placeholder.com/150";
            }}
          />
          <p className="text-2xl font-semibold text-[#1F2937] mb-2">Your Cart is Empty</p>
          <p className="text-gray-500 mb-6 text-center max-w-md">
            Discover amazing products and start your shopping journey today!
          </p>
          <Link to="/buyer">
            <button className="bg-[#003664] text-white py-3 px-8 rounded-full hover:bg-[#002a4f] transition-colors duration-300 shadow-md">
              Start Shopping
            </button>
          </Link>
        </div>
      ) : (
        <div className="flex flex-col lg:flex-row gap-8">
          {/* Left Side: Product List */}
          <div className="lg:w-2/3 space-y-6">
            <AnimatePresence>
              {cart.map((item, index) => (
                <motion.div
                  key={item.product_id}
                  className="flex items-center bg-white rounded-xl shadow-md p-4 hover:shadow-lg transition-shadow duration-300"
                  variants={itemVariants}
                  initial="initial"
                  animate="animate"
                  custom={index}
                  whileHover="hover"
                  exit="exit"
                >
                  <img
                    src={item.image}
                    alt={item.name}
                    className="w-20 h-20 object-cover rounded-md mr-4"
                    onError={(e) => {
                      e.target.src = "https://via.placeholder.com/100";
                    }}
                  />
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-[#1F2937]">{item.name}</h3>
                    <p className="text-gray-600">{item.price.toFixed(2)} L.E</p>
                  </div>
                  <div className="flex items-center space-x-3 mr-4">
                    <button
                      onClick={() => handleQuantityChange(item.product_id, -1)}
                      className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center hover:bg-gray-200 transition-colors duration-200 text-gray-700 font-bold"
                    >
                      -
                    </button>
                    <span className="w-8 text-center text-gray-800 font-medium">{item.quantity}</span>
                    <button
                      onClick={() => handleQuantityChange(item.product_id, 1)}
                      className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center hover:bg-gray-200 transition-colors duration-200 text-gray-700 font-bold"
                    >
                      +
                    </button>
                  </div>
                  <button
                    onClick={() => handleRemoveItem(item.product_id)}
                    className="text-red-500 hover:text-red-600 transition-colors duration-200"
                  >
                    <img src={trash} alt="Remove item" className="w-5 h-5" />
                  </button>
                </motion.div>
              ))}
            </AnimatePresence>
          </div>

          {/* Right Side: Checkout Summary */}
          <motion.div
            className="lg:w-2/5 bg-white rounded-xl shadow-md p-6 sticky top-24 h-fit"
            variants={summaryVariants}
            initial="initial"
            animate="animate"
          >
            <h2 className="text-xl font-semibold text-[#1F2937] mb-4">Order Summary</h2>
            <div className="space-y-3 text-gray-700">
              <div className="flex justify-between">
                <span>Shipping Fee</span>
                <span className="font-medium">{shippingFee.toFixed(2)} L.E</span>
              </div>
              <div className="flex justify-between">
                <span>Subtotal</span>
                <span className="font-medium">{subtotal.toFixed(2)} L.E</span>
              </div>
              <div className="flex justify-between font-bold text-[#1F2937] pt-2 border-t border-gray-200">
                <span>Total</span>
                <span>{total.toFixed(2)} L.E</span>
              </div>
            </div>
            <Link to="/buyer/checkout">
              <button className="w-full mt-6 bg-[#003664] text-white py-3 rounded-full hover:bg-[#002a4f] transition-colors duration-300 font-semibold shadow-md">
                Proceed to Checkout
              </button>
            </Link>
          </motion.div>
        </div>
      )}
    </div>
  );
}

export default Cart;