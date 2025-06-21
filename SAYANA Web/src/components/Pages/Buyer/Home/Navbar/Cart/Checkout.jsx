import React, { useState } from 'react';
import { motion } from 'framer-motion';
import axios from 'axios';
import { useNavigate, useLocation } from 'react-router-dom';
import Loader from '../../Loader';

// Animation variants
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

const EGYPT_CITIES = [
  "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum",
  "Gharbia", "Ismailia", "Menoufia", "Minya", "Qalyubia", "New Valley",
  "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said", "Damietta",
  "Sharqia", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor",
  "Qena", "North Sinai", "Sohag", "Helwan"
];

function Checkout() {
  const navigate = useNavigate();
  const location = useLocation();
  const cartItems = location.state?.cartItems || []; // Receive cartItems from Cart

  const [formData, setFormData] = useState({
    fname: "",
    lname: "",
    city: "",
    payment_method: "cash",
    street: "",
    street_no: "",
    floor_no: "",
    building_no: "",
  });

  const [instaPayImage, setInstaPayImage] = useState(null);
  const [isSubmitted, setIsSubmitted] = useState(false);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleInstaPayImageChange = (e) => {
    const file = e.target.files[0];
    setInstaPayImage(file);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      setError("Please log in to place an order.");
      return;
    }

    if (!formData.city) {
      setError("Please select your city.");
      return;
    }

    if (formData.payment_method === "instapay" && !instaPayImage) {
      setError("Please upload the InstaPay transaction image.");
      return;
    }

    setLoading(true);

    try {
      let requestBody;
      let headers;

      if (formData.payment_method === "instapay") {
        requestBody = new FormData();
        requestBody.append("fname", formData.fname);
        requestBody.append("lname", formData.lname);
        requestBody.append("city", formData.city);
        requestBody.append("city_name", formData.city);
        requestBody.append("city.name", formData.city);
        requestBody.append("payment_method", formData.payment_method);
        requestBody.append("street", formData.street);
        requestBody.append("street_no", formData.street_no);
        requestBody.append("floor_no", formData.floor_no);
        requestBody.append("building_no", formData.building_no);
        requestBody.append("offer", 10);
        requestBody.append("buyer_id", parseInt(buyerId, 10));
        requestBody.append("instapay_transaction_image", instaPayImage);
        headers = { "Content-Type": "multipart/form-data" };
      } else {
        requestBody = {
          fname: formData.fname,
          lname: formData.lname,
          city: formData.city,
          city_name: formData.city,
          payment_method: formData.payment_method,
          street: formData.street,
          street_no: formData.street_no,
          floor_no: formData.floor_no,
          building_no: formData.building_no,
          offer: 10,
          buyer_id: parseInt(buyerId, 10),
        };
        headers = { "Content-Type": "application/json" };
      }

      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/neworders",
        requestBody,
        { headers }
      );

      if (response.status === 200) {
        setIsSubmitted(true);
        setError(null);
        console.log('API Response:', response.data); // Debug log
        console.log('Cart Items:', cartItems); // Debug log
        setTimeout(() => {
          setFormData({
            fname: "",
            lname: "",
            city: "",
            payment_method: "cash",
            street: "",
            street_no: "",
            floor_no: "",
            building_no: "",
          });
          setInstaPayImage(null);
          setIsSubmitted(false);
          // Navigate with debug log, including street
          const stateToPass = {
            ...response.data,
            cartItems,
            shippingAddress: {
              street: formData.street,
            },
          };
          console.log('Navigating with state:', stateToPass); // Debug log
          navigate("/buyer/order-summary", {
            state: stateToPass,
          });
        }, 1200);
      } else {
        setError("Failed to place order. Please try again.");
      }
    } catch (err) {
      if (err.response && err.response.data && err.response.data.errors) {
        let messages = [];
        Object.values(err.response.data.errors).forEach(arr => {
          messages = messages.concat(arr);
        });
        setError(messages.join(" "));
      } else if (err.response && err.response.data && err.response.data.message) {
        setError(err.response.data.message);
      } else {
        setError("An error occurred while placing your order. Please try again.");
      }
    } finally {
      setLoading(false);
    }
  };

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

        {loading ? (
          <Loader />
        ) : isSubmitted ? (
          <motion.div
            className="text-center text-green-600 font-semibold"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
          >
            Thank you for your order! Redirecting...
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

            {/* Select Your City */}
            <motion.div variants={inputVariants}>
              <label htmlFor="city" className="block text-sm font-medium text-gray-700">
                Select Your City
              </label>
              <select
                id="city"
                name="city"
                value={formData.city}
                onChange={handleChange}
                className="mt-1 block w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:ring-1 focus:ring-[#003664]"
                required
              >
                <option value="">-- Select City --</option>
                {EGYPT_CITIES.map((city) => (
                  <option key={city} value={city}>{city}</option>
                ))}
              </select>
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
                <option value="instapay">InstaPay</option>
              </select>
            </motion.div>

            {/* InstaPay Info */}
            {formData.payment_method === "instapay" && (
              <motion.div
                variants={inputVariants}
                initial="hidden"
                animate="visible"
                className="bg-blue-50 border border-blue-200 rounded-lg p-4 my-2"
              >
                <span className="block font-medium text-blue-700 mb-1">
                  Transfer to InstaPay Account:
                </span>
                <span className="block text-blue-900 font-semibold text-lg">
                  010-****-****
                </span>
                <span className="block text-xs text-gray-600 mt-1">
                  (Please transfer the amount to this account, then upload the transaction image below.)
                </span>
                {/* Upload image button */}
                <div className="mt-4">
                  <label
                    htmlFor="instapay-image-upload"
                    className="bg-[#003664] text-white px-4 py-2 rounded-full cursor-pointer hover:bg-[#002a4a] transition"
                  >
                    {instaPayImage ? "Change Transaction Image" : "Upload Transaction Image"}
                  </label>
                  <input
                    type="file"
                    id="instapay-image-upload"
                    accept="image/*"
                    style={{ display: "none" }}
                    onChange={handleInstaPayImageChange}
                  />
                  {instaPayImage && (
                    <div className="mt-2 text-sm text-green-700">
                      Image selected: {instaPayImage.name}
                    </div>
                  )}
                </div>
              </motion.div>
            )}

            {/* Submit Button */}
            <motion.button
              type="submit"
              className="w-full bg-[#003664] text-white p-3 rounded-full mt-4"
              variants={buttonVariants}
              whileHover="hover"
              whileTap="tap"
            >
              Checkout
            </motion.button>
          </form>
        )}
      </div>
    </motion.div>
  );
}

export default Checkout;