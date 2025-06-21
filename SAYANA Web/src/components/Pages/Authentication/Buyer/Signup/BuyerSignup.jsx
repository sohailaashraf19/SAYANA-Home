import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { FaFacebookF, FaGoogle, FaApple } from "react-icons/fa";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import axios from "axios";

const BuyerSignup = () => {
  const navigate = useNavigate();
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  // Function to clear localStorage data
  const handleClearData = () => {
    localStorage.removeItem("user"); // Remove user data (name, email, phone, role)
    localStorage.removeItem("token"); // Remove token
    setError("User data cleared successfully.");
    // Reset form fields
    setName("");
    setPhone("");
    setEmail("");
    setPassword("");
    setConfirmPassword("");
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    // Client-side validation
    if (!name.trim()) {
      setError("Business name is required.");
      setLoading(false);
      return;
    }
    if (!phone.trim()) {
      setError("Phone number is required.");
      setLoading(false);
      return;
    }
    if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setError("Please enter a valid email address.");
      setLoading(false);
      return;
    }
    if (password.length < 10) {
      setError("Password must be at least 10 characters long.");
      setLoading(false);
      return;
    }
    if (password !== confirmPassword) {
      setError("Passwords do not match!");
      setLoading(false);
      return;
    }

    // Prepare the request body (match backend expectations)
    const payload = {
      name,
      email,
      password,
      password_confirmation: confirmPassword,
      phone,
    };

    try {
      console.log("Sending request with payload:", payload);
      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/register",
        payload,
        {
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
        }
      );

      console.log("API Response:", response.data);

      // Handle both 200 and 201 status codes
      if (response.status === 200 || response.status === 201) {
        // Clear previous storage
        localStorage.removeItem("token");
        localStorage.removeItem("user");

        localStorage.setItem(
          "user",
          JSON.stringify({
            name,
            email,
            phone,
            role: "buyer",
          })
        );
        localStorage.setItem("token", response.data.token); // Store token
        navigate("/buyer");
      }
    } catch (err) {
      console.error("Error during signup:", err);
      if (err.response) {
        if (err.response.status === 422) {
          const errors = err.response.data.errors;
          if (errors.email) {
            setError(errors.email[0] || "Email is already taken.");
          } else if (errors.password) {
            setError(errors.password[0] || "Password validation failed.");
          } else if (errors.name) {
            setError(errors.name[0] || "Business name validation failed.");
          } else if (errors.phone) {
            setError(errors.phone[0] || "Phone number validation failed.");
          } else {
            setError("Validation failed. Please check your inputs.");
          }
        } else if (err.response.status === 404) {
          setError("API endpoint not found. Please check the URL.");
        } else if (err.response.status === 500) {
          setError("Server error. Please try again later.");
        } else {
          setError("An unexpected error occurred. Please try again.");
        }
      } else if (err.request) {
        setError("Network error. Please check your connection or CORS settings.");
      } else {
        setError("An error occurred. Please try again.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex bg-[#FBFBFB]">
      {/* Left Side Image */}
      <div className="w-1/2 bg-[#003664]">
        <img
          src="src/assets/images/6.jpg"
          alt="Signup Visual"
          className="w-full h-full object-cover"
        />
      </div>

      {/* Right Side Form */}
      <div className="w-1/2 bg-[#f3f4f6] flex items-start justify-center pt-20">
        <div className="bg-white p-12 rounded-2xl shadow-lg w-full max-w-xl min-h-[650px]">
          <h1 className="text-3xl font-bold text-[#003664] mb-2 text-left">
            SYANA Home
          </h1>
          <h2 className="text-xl font-bold text-[#003664] mb-6 text-left">
            Create an Account
          </h2>

          {error && <div className="text-red-500 text-sm mb-4">{error}</div>}

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Full Name */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Name
              </label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                disabled={loading}
                className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
              />
            </div>

            {/* Phone Number */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Phone Number
              </label>
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                required
                disabled={loading}
                className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
              />
            </div>

            {/* Email */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Email
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                disabled={loading}
                className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
              />
            </div>

            {/* Password */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Password
              </label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  disabled={loading}
                  className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
                />
                <button
                  type="button"
                  className="absolute right-4 top-2.5 text-gray-500"
                  onClick={() => setShowPassword(!showPassword)}
                  disabled={loading}
                >
                  {showPassword ? (
                    <EyeSlashIcon className="h-5 w-5" />
                  ) : (
                    <EyeIcon className="h-5 w-5" />
                  )}
                </button>
              </div>
            </div>

            {/* Confirm Password */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Confirm Password
              </label>
              <div className="relative">
                <input
                  type={showConfirm ? "text" : "password"}
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  disabled={loading}
                  className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
                />
                <button
                  type="button"
                  className="absolute right-4 top-2.5 text-gray-500"
                  onClick={() => setShowConfirm(!showConfirm)}
                  disabled={loading}
                >
                  {showConfirm ? (
                    <EyeSlashIcon className="h-5 w-5" />
                  ) : (
                    <EyeIcon className="h-5 w-5" />
                  )}
                </button>
              </div>
            </div>

            {/* Submit */}
            <button
              type="submit"
              className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-90 transition disabled:opacity-50"
              disabled={loading}
            >
              {loading ? "Signing Up..." : "Sign Up"}
            </button>
          </form>

          {/* Divider */}
          <div className="my-6 flex items-center justify-between">
            <div className="border-t border-gray-300 w-1/4"></div>
            <span className="text-sm text-gray-500">or continue with</span>
            <div className="border-t border-gray-300 w-1/4"></div>
          </div>

          {/* Social Buttons */}
          <div className="flex justify-center space-x-6 mb-6">
            <button className="bg-[#3b5998] text-white p-3 rounded-full">
              <FaFacebookF size={20} />
            </button>
            <button className="bg-white border p-3 rounded-full shadow">
              <FaGoogle size={20} />
            </button>
            <button className="bg-black text-white p-3 rounded-full">
              <FaApple size={20} />
            </button>
          </div>

          {/* Already have an account */}
          <p className="text-center text-sm text-gray-600">
            Already have an account?
            <button
              onClick={() => navigate("/buyer-login")}
              className="ml-2 text-[#003664] font-semibold hover:underline"
            >
              Log In
            </button>
          </p>
        </div>
      </div>
    </div>
  );
};

export default BuyerSignup;