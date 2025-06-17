import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { FaEye, FaEyeSlash } from "react-icons/fa";

export default function ResetPass() {
  const [message, setMessage] = useState({ text: "", type: "" });
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [email, setEmail] = useState("");
  const [otp, setOtp] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  // Retrieve email and otp from localStorage on mount
  useEffect(() => {
    const storedEmail = localStorage.getItem("resetEmail");
    const storedOtp = localStorage.getItem("resetOtp");
    if (storedEmail && storedOtp) {
      setEmail(storedEmail);
      setOtp(storedOtp);
    } else {
      setMessage({ text: "Session expired. Please start the reset process again.", type: "error" });
      setTimeout(() => navigate("/buyer-forgot-password"), 3000);
    }
  }, [navigate]);

  // Auto-dismiss message after 3 seconds
  useEffect(() => {
    if (message.text) {
      const timer = setTimeout(() => {
        setMessage({ text: "", type: "" });
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [message]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage({ text: "", type: "" });
    setLoading(true);

    if (!email || !otp) {
      setMessage({ text: "Session expired. Please start the reset process again.", type: "error" });
      setLoading(false);
      return;
    }

    try {
      const response = await fetch(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/reset",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            email,
            otp,
            password,
            password_confirmation: confirmPassword,
          }),
        }
      );

      const data = await response.json();

      if (response.status === 200 || response.status === 201) {
        setMessage({ text: "Password reset successful! Redirecting to login...", type: "success" });
        localStorage.removeItem("resetEmail");
        localStorage.removeItem("resetOtp");
        setTimeout(() => navigate("/buyer-login"), 2000);
      } else {
        setMessage({ text: data.message || "Failed to reset password. Please try again.", type: "error" });
      }
    } catch (err) {
      console.error("Error resetting password:", err);
      setMessage({ text: "Network error. Please check your connection and try again.", type: "error" });
    } finally {
      setLoading(false);
    }
  };

  // Animation variants
  const containerVariants = {
    hidden: { opacity: 0, y: 50 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.6, ease: "easeOut" },
    },
  };

  const inputVariants = {
    hidden: { opacity: 0, scale: 0.8 },
    visible: (i) => ({
      opacity: 1,
      scale: 1,
      transition: { delay: i * 0.1, duration: 0.3 },
    }),
  };

  const buttonVariants = {
    hover: { scale: 1.05, transition: { duration: 0.3 } },
    tap: { scale: 0.95 },
  };

  return (
    <div className="min-h-screen flex bg-[#FBFBFB]">
      {/* Left Side Image */}
      <div className="w-1/2 bg-[#003664]">
        <img
          src="src/assets/images/6.jpg"
          alt="Reset Password Visual"
          className="w-full h-screen object-cover"
        />
      </div>

      {/* Right Side Form */}
      <div className="w-1/2 bg-[#f3f4f6] flex items-start justify-center pt-20">
        <motion.div
          className="bg-white p-12 rounded-2xl shadow-lg w-full max-w-xl min-h-[650px]"
          variants={containerVariants}
          initial="hidden"
          animate="visible"
        >
          {/* Header */}
          <motion.h1
            className="text-3xl font-bold text-[#003664] mb-2 text-left"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0, transition: { delay: 0.2, duration: 0.5 } }}
          >
            SAYANA Home
          </motion.h1>
          <motion.h2
            className="text-xl font-bold text-[#003664] mb-6 text-left"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0, transition: { delay: 0.3, duration: 0.5 } }}
          >
            Reset Password
          </motion.h2>
          <motion.p
            className="text-sm text-[#003664] mb-6 text-left"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0, transition: { delay: 0.4, duration: 0.5 } }}
          >
            Enter your new password below.
          </motion.p>

          {/* Messages */}
          {message.text && (
            <div
              className={`text-sm mb-4 ${
                message.type === "success" ? "text-green-500" : "text-red-500"
              }`}
            >
              {message.text}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Password Field */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Password
              </label>
              <div className="relative">
                <motion.input
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
                  placeholder="Enter new password"
                  required
                  disabled={loading}
                  variants={inputVariants}
                  initial="hidden"
                  animate="visible"
                  custom={0}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute top-1/2 right-3 transform -translate-y-1/2 text-gray-400 hover:text-gray-500"
                  aria-label={showPassword ? "Hide password" : "Show password"}
                  disabled={loading}
                >
                  {showPassword ? <FaEyeSlash size={18} /> : <FaEye size={18} />}
                </button>
              </div>
              <div className="h-4 mt-1"></div>
            </div>

            {/* Confirm Password Field */}
            <div>
              <label className="block mb-1 text-sm font-medium text-gray-700">
                Confirm Password
              </label>
              <div className="relative">
                <motion.input
                  type={showConfirmPassword ? "text" : "password"}
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] disabled:opacity-50"
                  placeholder="Confirm new password"
                  required
                  disabled={loading}
                  variants={inputVariants}
                  initial="hidden"
                  animate="visible"
                  custom={1}
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  className="absolute top-1/2 right-3 transform -translate-y-1/2 text-gray-400 hover:text-gray-500"
                  aria-label={showConfirmPassword ? "Hide confirmation password" : "Show confirmation password"}
                  disabled={loading}
                >
                  {showConfirmPassword ? <FaEyeSlash size={18} /> : <FaEye size={18} />}
                </button>
              </div>
              <div className="h-4 mt-1"></div>
            </div>

            {/* Submit Button */}
            <motion.button
              type="submit"
              disabled={loading}
              className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-90 transition disabled:opacity-50"
              variants={buttonVariants}
              whileHover={loading ? {} : "hover"}
              whileTap={loading ? {} : "tap"}
            >
              {loading ? "Updating..." : "Update Password"}
            </motion.button>
          </form>
        </motion.div>
      </div>
    </div>
  );
}