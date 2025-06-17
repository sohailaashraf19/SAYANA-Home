import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import { FaFacebookF, FaGoogle, FaApple } from "react-icons/fa";
import { ArrowLeftIcon } from "@heroicons/react/24/outline";

const SellerLogin = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState(""); // State for error messages
  const [loading, setLoading] = useState(false); // State for loading status

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(""); // Clear previous errors
    setLoading(true); // Set loading state

    try {
      const response = await fetch("https://olivedrab-llama-457480.hostingersite.com/public/api/seller/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          password,
        }),
      });

      const data = await response.json();

      if (response.ok) {
        // Success: Store the token and seller data
        localStorage.setItem("token", data.token); // Store token in localStorage
        localStorage.setItem("seller_id", data.seller.seller_id); // Store token in localStorage
        localStorage.setItem("seller", JSON.stringify(data.seller)); // Store seller data
        console.log("Login successful:", data);
        
        navigate("/home"); // Navigate to home page
      } else {
        // Handle error (e.g., 401 Invalid credentials)
        setError(data.message || "An error occurred during login.");
      }
    } catch (err) {
      // Handle network or other errors
      setError("Failed to connect to the server. Please try again.");
      console.error("Error:", err);
    } finally {
      setLoading(false); // Reset loading state
    }
  };

  const handleBackClick = () => {
    navigate("/"); // Navigate to SplashScreen
  };

  return (
    <div className="min-h-screen flex bg-[#FBFBFB]">
      {/* Back Button */}
      <button
        onClick={handleBackClick}
        className="absolute top-4 left-4 bg-transparent text-white p-3 rounded-full shadow-md hover:opacity-80 transition"
      >
        <ArrowLeftIcon className="h-5 w-5" />
      </button>

      {/* Left Image */}
      <div className="w-1/2 bg-[#003664]">
        <img
          src="src/assets/images/6.jpg"
          alt="Login Visual"
          className="w-full h-full object-cover"
        />
      </div>

      {/* Right Form */}
      <div className="w-1/2 bg-[#f3f4f6] flex items-start justify-center pt-20">
        <div className="bg-white p-12 rounded-2xl shadow-lg w-full max-w-xl min-h-[650px]">
          <h1 className="text-3xl font-bold text-[#003664] mb-2 text-left">SAYANA Home</h1>
          <h2 className="text-xl font-bold text-[#003664] mb-6 text-left">Seller Log In</h2>

          {/* Error Message */}
          {error && (
            <div className="text-red-500 text-sm mb-4 text-center">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
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
                  className="w-full px-4 py-2 border border-gray-300 pr-10 rounded-full focus:outline-none focus:border-[#003664]"
                  disabled={loading}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute inset-y-0 right-3 flex items-center"
                >
                  {showPassword ? (
                    <EyeSlashIcon className="h-5 w-5 text-gray-500" />
                  ) : (
                    <EyeIcon className="h-5 w-5 text-gray-500" />
                  )}
                </button>
              </div>
            </div>

            {/* Remember & Forget */}
            <div className="flex justify-between text-sm text-gray-600">
              <label className="flex items-center space-x-2">
                <input type="checkbox" className="accent-[#003664]" disabled={loading} />
                <span>Remember me</span>
              </label>
              <button onClick={() => navigate("/seller-forgotpassword") } className="text-[#003664] hover:underline" disabled={loading}>
                Forgot password?
              </button>
            </div>

            {/* Submit */}
            <button
              type="submit"
              className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-80 transition"
              disabled={loading}
            >
              Log In
            </button>
          </form>

          {/* OR Separator */}
          <div className="flex items-center my-6">
            <hr className="flex-grow border-gray-300" />
            <span className="px-4 text-sm text-gray-500">or continue with</span>
            <hr className="flex-grow border-gray-300" />
          </div>

          {/* Social Icons */}
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

          {/* Signup Link */}
          <div className="text-center text-sm text-gray-600">
            Don't have an account?{" "}
            <button
              className="ml-2 text-[#003664] font-semibold hover:underline"
              onClick={() => navigate("/signup")}
              disabled={loading}
            >
              Signup
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SellerLogin;
