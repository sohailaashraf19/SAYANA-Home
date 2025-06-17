import React, { useState } from 'react';
import { motion } from 'framer-motion';
import axios from 'axios';
import { Navigate } from 'react-router-dom';
import Loader from '../../Loader';

// تعريف متغيرات التحريك للحاوية والمدخلات
const containerVariants = {
  hidden: { opacity: 0, y: 50 },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.5,
      when: "beforeChildren",
      staggerChildren: 0.1,
    },
  },
};

const inputVariants = {
  hidden: { opacity: 0, x: -20 },
  visible: {
    opacity: 1,
    x: 0,
    transition: { duration: 0.3 },
  },
};

const buttonVariants = {
  hover: {
    scale: 1.05,
    backgroundColor: "#003664",
    transition: { duration: 0.3 },
  },
  tap: { scale: 0.95 },
};

function Checkout() {
  // البيانات الخاصة بالنموذج
  const [formData, setFormData] = useState({
    fname: "",
    lname: "",
    payment_method: "cash",
    street: "",
    street_no: "",
    floor_no: "",
    building_no: "",
  });

  // حالات التحكم:
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [error, setError] = useState(null);
  const [navigate, setNavigate] = useState(false);
  const [loading, setLoading] = useState(false); // حالة التحميل

  // التعامل مع تغييرات المدخلات
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  // التعامل مع تقديم النموذج
  const handleSubmit = async (e) => {
    e.preventDefault();

    // التحقق من وجود buyer_id في localStorage
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      setError("Please log in to place an order.");
      return;
    }

    // تجهيز جسم الطلب
    const requestBody = {
      ...formData,
      offer: 10, // قيمة افتراضية لـ offer
      buyer_id: parseInt(buyerId, 10),
    };

    setLoading(true); // بدء عرض الـ Loader

    try {
      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/neworders",
        requestBody,
        { headers: { "Content-Type": "application/json" } }
      );

      if (response.status === 200) {
        setIsSubmitted(true);
        setError(null);
        // إعادة تعيين النموذج والتنقل بعد 4 ثوانٍ
        setTimeout(() => {
          setFormData({
            fname: "",
            lname: "",
            payment_method: "cash",
            street: "",
            street_no: "",
            floor_no: "",
            building_no: "",
          });
          setIsSubmitted(false);
          setNavigate(true);
        }, 4000);
      } else {
        setError("Failed to place order. Please try again.");
      }
    } catch (err) {
      console.error("Error submitting order:", err.response?.data || err.message);
      setError("An error occurred while placing your order. Please try again.");
    } finally {
      setLoading(false); // إخفاء الـ Loader بعد انتهاء الطلب
    }
  };

  // التنقل إلى صفحة /buyer إذا تم تفعيل التنقل
  if (navigate) {
    return <Navigate to="/buyer" replace />;
  }

  return (
    <motion.div
      className="min-h-screen bg-gray-100 flex items-center justify-center p-6"
      variants={containerVariants}
      initial="hidden"
      animate="visible"
    >
      <div className="bg-white rounded-lg shadow-lg p-8 max-w w-full">
        <h2 className="text-2xl font-bold text-gray-800 mb-6 text-center">
          Checkout Form
        </h2>

        {/* عرض الـ Loader أثناء حالة التحميل */}
        {loading ? (
          <Loader />
        ) : isSubmitted ? (
          <motion.div
            className="text-center text-green-600 font-semibold"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
          >
            Thank you for your order! We'll process it shortly.
          </motion.div>
        ) : error ? (
          <motion.div
            className="text-center text-red-600 font-semibold"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
          >
            {error}
          </motion.div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-4">
            {/* First Name */}
            <motion.div variants={inputVariants}>
              <label htmlFor="fname" className="block text-sm font-medium text-gray-700">
                First Name
              </label>
              <input
                type="text"
                id="fname"
                name="fname"
                value={formData.fname}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              />
            </motion.div>

            {/* Last Name */}
            <motion.div variants={inputVariants}>
              <label htmlFor="lname" className="block text-sm font-medium text-gray-700">
                Last Name
              </label>
              <input
                type="text"
                id="lname"
                name="lname"
                value={formData.lname}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              />
            </motion.div>

            {/* Payment Method */}
            <motion.div variants={inputVariants}>
              <label htmlFor="payment_method" className="block text-sm font-medium text-gray-700">
                Payment Method
              </label>
              <select
                id="payment_method"
                name="payment_method"
                value={formData.payment_method}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              >
                <option value="cash">Cash</option>
              </select>
            </motion.div>

            {/* Street */}
            <motion.div variants={inputVariants}>
              <label htmlFor="street" className="block text-sm font-medium text-gray-700">
                Street
              </label>
              <input
                type="text"
                id="street"
                name="street"
                value={formData.street}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              />
            </motion.div>

            {/* Street Number */}
            <motion.div variants={inputVariants}>
              <label htmlFor="street_no" className="block text-sm font-medium text-gray-700">
                Street Number
              </label>
              <input
                type="text"
                id="street_no"
                name="street_no"
                value={formData.street_no}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              />
            </motion.div>

            {/* Floor Number */}
            <motion.div variants={inputVariants}>
              <label htmlFor="floor_no" className="block text-sm font-medium text-gray-700">
                Floor Number
              </label>
              <input
                type="text"
                id="floor_no"
                name="floor_no"
                value={formData.floor_no}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              />
            </motion.div>

            {/* Building Number */}
            <motion.div variants={inputVariants}>
              <label htmlFor="building_no" className="block text-sm font-medium text-gray-700">
                Building Number
              </label>
              <input
                type="text"
                id="building_no"
                name="building_no"
                value={formData.building_no}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              />
            </motion.div>

            {/* Submit Button */}
            <motion.button
              type="submit"
              className="w-full bg-[#003664] text-white p-3 rounded-full mt-4"
              variants={buttonVariants}
              whileHover="hover"
              whileTap="tap"
            >
              Submit Order
            </motion.button>
          </form>
        )}
      </div>
    </motion.div>
  );
}

export default Checkout;
