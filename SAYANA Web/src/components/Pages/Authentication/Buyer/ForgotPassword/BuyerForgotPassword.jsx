import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { FaFacebookF, FaGoogle, FaApple } from "react-icons/fa";

const BuyerForgotPassword = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setSuccess("");
    setLoading(true);

    // Client-side validation
    if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setError("Please enter a valid email address.");
      setLoading(false);
      return;
    }

    try {
      const response = await fetch(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/request-otp",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email }),
        }
      );

      const data = await response.json();

      if (response.status === 200 || response.status === 201) {
        setSuccess("Password reset OTP sent to your email. Please check your inbox.");
        // Store email in localStorage for use in reset password component
        localStorage.setItem("resetEmail", email);
        setTimeout(() => navigate("/buyer-Otp"), 3000);
      } else {
        setError(data.message || "Failed to send OTP. Please try again.");
        setLoading(false);
      }
    } catch (err) {
      console.error("Error requesting OTP:", err);
      setError("Network error. Please check your connection and try again.");
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex bg-[#FBFBFB]">
      {/* Left Side Image */}
      <div className="w-1/2 bg-[#003664]">
        <img
          src="src/assets/images/6.jpg"
          alt="Forgot Password Visual"
          className="w-full h-screen object-cover"
        />
      </div>

      {/* Right Side Form */}
      <div className="w-1/2 bg-[#f3f4f6] flex items-start justify-center pt-20">
        <div className="bg-white p-12 rounded-2xl shadow-lg w-full max-w-xl min-h-[650px]">
          <h1 className="text-3xl font-bold text-[#003664] mb-2 text-left">
            SAYANA Home
          </h1>
          <h2 className="text-xl font-bold text-[#003664] mb-6 text-left">
            Forgot Password
          </h2>
          <h6 className="text-sm text-[#003664] mb-6 text-left">
            Enter your email address and we will send a link to reset your password
          </h6>
          {error && <div className="text-red-500 text-sm mb-4">{error}</div>}
          {success && <div className="text-green-500 text-sm mb-4">{success}</div>}

          <form onSubmit={handleSubmit} className="space-y-6">
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
                placeholder="Enter your email address"
              />
            </div>

            {/* Submit */}
            <button
              type="submit"
              className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-90 transition disabled:opacity-50"
              disabled={loading}
            >
              {loading ? "Sending..." : "Send Reset Link"}
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

        </div>
      </div>
    </div>
  );
};

export default BuyerForgotPassword;