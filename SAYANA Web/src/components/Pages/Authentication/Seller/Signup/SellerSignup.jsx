import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { FaFacebookF, FaGoogle, FaApple } from "react-icons/fa";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";

const SellerSignup = () => {
  const navigate = useNavigate();
  const [brandName, setBrandName] = useState(""); // Renamed to brandName for clarity
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [error, setError] = useState(""); // State for error messages
  const [loading, setLoading] = useState(false); // State for loading status

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(""); // Clear previous errors
    setLoading(true); // Set loading state

    // Client-side password confirmation check
    if (password !== confirmPassword) {
      setError("Passwords do not match!");
      setLoading(false);
      return;
    }

    try {
      const response = await fetch("https://olivedrab-llama-457480.hostingersite.com/public/api/seller/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          brand_name: brandName,
          phone,
          email,
          password,
          password_confirmation: confirmPassword,
        }),
      });

      const data = await response.json();

      if (response.ok) {
        // Success: Store the token and seller data
        localStorage.setItem("token", data.token); // Store token in localStorage
        localStorage.setItem("seller", JSON.stringify(data.seller)); // Store seller data
        console.log("Registration successful:", data);
        navigate("/home"); // Navigate to home page
      } else {
        // Handle validation errors or other API errors
        if (response.status === 422) {
          // Extract validation errors
          const errors = data.errors || {};
          const errorMessage = Object.values(errors).flat().join(", ");
          setError(errorMessage || "Registration failed. Please check your inputs.");
        } else {
          setError(data.message || "An error occurred during registration.");
        }
      }
    } catch (err) {
      // Handle network or other errors
      setError("Failed to connect to the server. Please try again.");
      console.error("Error:", err);
    } finally {
      setLoading(false); // Reset loading state
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
          <h1 className="text-3xl font-bold text-[#003664] mb-2 text-left">SAYANA Home</h1>
          <h2 className="text-xl font-bold text-[#003664] mb-6 text-left">Create an Account</h2>

          {/* Error Message */}
          {error && (
            <div className="text-red-500 text-sm mb-4 text-center">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Business Name */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">Business Name</label>
              <input
                type="text"
                value={brandName}
                onChange={(e) => setBrandName(e.target.value)}
                required
                className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
                disabled={loading}
              />
            </div>

            {/* Phone Number */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">Phone Number</label>
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                required
                className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
                disabled={loading}
              />
            </div>

            {/* Email */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
                disabled={loading}
              />
            </div>

            {/* Password */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">Password</label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
                  disabled={loading}
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
              <label className="block mb-1 text-sm font-medium text-gray-700">Confirm Password</label>
              <div className="relative">
                <input
                  type={showConfirm ? "text" : "password"}
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
                  disabled={loading}
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
              className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-90 transition"
              disabled={loading}
            >
              {loading ? "Sign Up" : "Sign Up"}
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
            <button className="bg-[#3b5998] text-white p-3 rounded-full" disabled={loading}>
              <FaFacebookF size={20} />
            </button>
            <button className="bg-white border p-3 rounded-full shadow" disabled={loading}>
              <FaGoogle size={20} />
            </button>
            <button className="bg-black text-white p-3 rounded-full" disabled={loading}>
              <FaApple size={20} />
            </button>
          </div>

          {/* Already have an account */}
          <p className="text-center text-sm text-gray-600">
            Already have an account?
            <button
              onClick={() => navigate("/login")}
              className="ml-2 text-[#003664] font-semibold hover:underline"
              disabled={loading}
            >
              Log In
            </button>
          </p>
        </div>
      </div>
    </div>
  );
};

export default SellerSignup;