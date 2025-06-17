import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import { FaFacebookF, FaGoogle, FaApple } from "react-icons/fa";
import { ArrowLeftIcon } from "@heroicons/react/24/outline";
import axios from "axios";

// ✅ استيراد social login
import { LoginSocialGoogle, LoginSocialFacebook } from 'reactjs-social-login';

const BuyerLogin = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/login",
        {
          email,
          password,
        }
      );

      if (response.status === 200) {
        const { token, buyer } = response.data;
        const { buyer_id } = buyer;

        localStorage.removeItem("token");
        localStorage.removeItem("buyer_id");

        localStorage.setItem("token", token || "");
        localStorage.setItem("buyer_id", buyer_id ? String(buyer_id) : "");

        console.log("Saved token:", token);
        console.log("Saved buyer_id:", buyer_id);

        setTimeout(() => {
          console.log("Stored token (after delay):", localStorage.getItem("token"));
          console.log("Stored buyer_id (after delay):", localStorage.getItem("buyer_id"));
        }, 100);

        navigate("/buyer");
      }
    } catch (err) {
      if (err.response && err.response.status === 401) {
        setError("Invalid credentials");
      } else {
        setError("An error occurred. Please try again.");
        console.error("Login error:", err);
      }
    }
  };

  const handleBackClick = () => {
    navigate("/");
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
          className="w-full h-screen object-cover"
        />
      </div>

      {/* Right Form */}
      <div className="w-1/2 bg-[#f3f4f6] flex items-start justify-center pt-11">
        <div className="bg-white p-12 rounded-2xl shadow-lg w-full max-w-xl min-h-[650px]">
          <h1 className="text-3xl font-bold text-[#003664] mb-2 text-left">SAYANA Home</h1>
          <h2 className="text-xl font-bold text-[#003664] mb-6 text-left">Buyer Login</h2>

          {error && <div className="text-red-500 text-sm mb-4">{error}</div>}

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
                <input type="checkbox" className="accent-[#003664]" />
                <span>Remember me</span>
              </label>
              <button
                className="text-[#003664] hover:underline"
                onClick={() => navigate("/buyer-forgotpassword")}
              >
                Forgot password?
              </button>
            </div>

            {/* Submit */}
            <button
              type="submit"
              className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-90 transition"
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
            <LoginSocialFacebook
              appId="YOUR_FACEBOOK_APP_ID"
              onResolve={({ provider, data }) => {
                console.log('Facebook login success:', provider, data);
              }}
              onReject={(err) => {
                console.error('Facebook login error:', err);
              }}
            >
              <button className="bg-[#3b5998] text-white p-3 rounded-full">
                <FaFacebookF size={20} />
              </button>
            </LoginSocialFacebook>

            <LoginSocialGoogle
              client_id="223014847488-g58lj4i1qcld9qban4bgarp63j4ifkcm.apps.googleusercontent.com"
              scope="openid profile email"
              discoveryDocs="claims_supported"
              access_type="offline"
              onResolve={({ provider, data }) => {
                console.log('Google login success:', provider, data);
              }}
              onReject={(err) => {
                console.error('Google login error:', err);
              }}
            >
              <button className="bg-white border p-3 rounded-full shadow">
                <FaGoogle size={20} />
              </button>
            </LoginSocialGoogle>

            {/* Apple button (UI فقط) */}
            <button className="bg-black text-white p-3 rounded-full">
              <FaApple size={20} />
            </button>
          </div>

          {/* Signup Link */}
          <div className="text-center text-sm text-gray-600">
            Don't have an account?{" "}
            <button
              className="ml-2 text-[#003664] font-semibold hover:underline"
              onClick={() => navigate("/buyer-signup")}
            >
              Signup
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default BuyerLogin;
