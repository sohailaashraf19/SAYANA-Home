import { useNavigate } from 'react-router-dom';
import { useEffect, useState, useRef } from 'react';
import { motion } from 'framer-motion';

const OTPInput = ({ length = 6 }) => {
  const [otp, setOtp] = useState(new Array(length).fill(''));
  const [message, setMessage] = useState({ text: '', type: '' });
  const [resendAttempts, setResendAttempts] = useState(0);
  const [lastResendTime, setLastResendTime] = useState(null);
  const [cooldownTime, setCooldownTime] = useState(0);
  const [email, setEmail] = useState('');
  const inputRefs = useRef([]);
  const navigate = useNavigate();

  // Retrieve email from localStorage on mount
  useEffect(() => {
    const storedEmail = localStorage.getItem("resetEmail");
    if (storedEmail) {
      setEmail(storedEmail);
    } else {
      setMessage({ text: 'Session expired. Please start the reset process again.', type: 'error' });
      setTimeout(() => navigate('/buyer-forgot-password'), 3000);
    }
  }, [navigate]);

  // Auto-dismiss message after 3 seconds
  useEffect(() => {
    if (message.text) {
      const timer = setTimeout(() => {
        setMessage({ text: '', type: '' });
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [message]);

  // Timer for cooldown
  useEffect(() => {
    let timer;
    if (cooldownTime > 0) {
      timer = setInterval(() => {
        setCooldownTime((prev) => prev - 1);
      }, 1000);
    }
    return () => clearInterval(timer);
  }, [cooldownTime]);

  // Handle OTP input change
  const handleChange = (index, value) => {
    if (!/^[0-9]?$/.test(value)) return;
    const newOtp = [...otp];
    newOtp[index] = value;
    setOtp(newOtp);

    if (value && index < length - 1) {
      inputRefs.current[index + 1].focus();
    }
  };

  // Handle backspace key
  const handleKeyDown = (index, e) => {
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      inputRefs.current[index - 1].focus();
    }
  };

  // Handle OTP submission
  const handleOtp = async () => {
    const otpValue = otp.join('');
    if (otpValue.length !== length) {
      setMessage({ text: 'Please enter a complete OTP.', type: 'error' });
      return;
    }

    if (!email) {
      setMessage({ text: 'Session expired. Please start the reset process again.', type: 'error' });
      setTimeout(() => navigate('/buyer-forgot-password'), 3000);
      return;
    }

    try {
      const response = await fetch(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/verify-otp',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ email, otp: otpValue }),
        }
      );

      const data = await response.json();

      if (response.status === 200 || response.status === 201) {
        setMessage({ text: 'OTP verified! Redirecting...', type: 'success' });
        localStorage.setItem('resetOtp', otpValue);
        setTimeout(() => navigate('/buyer-ResetPass'), 1000);
      } else {
        setMessage({ text: data.message || 'Invalid OTP. Please try again.', type: 'error' });
      }
    } catch (err) {
      console.error('Error verifying OTP:', err);
      setMessage({ text: 'Network error. Please check your connection and try again.', type: 'error' });
    }
  };

  // Handle resend OTP with cooldown logic
  const handleResendOtp = async () => {
    const now = Date.now();
    const timeSinceLastResend = lastResendTime ? (now - lastResendTime) / 1000 : Infinity;
    const isRestrictedMode = resendAttempts >= 10;
    const cooldownDuration = isRestrictedMode ? 300 : 30; // 5 minutes or 30 seconds

    if (timeSinceLastResend < cooldownDuration) {
      setMessage({
        text: `Please wait ${Math.ceil(cooldownDuration - timeSinceLastResend)} seconds before resending.`,
        type: 'error',
      });
      setCooldownTime(Math.ceil(cooldownDuration - timeSinceLastResend));
      return;
    }

    if (!email) {
      setMessage({ text: 'Session expired. Please start the reset process again.', type: 'error' });
      setTimeout(() => navigate('/buyer-forgot-password'), 3000);
      return;
    }

    try {
      const response = await fetch(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/forgot-password/request-otp',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ email }),
        }
      );

      const data = await response.json();

      if (response.status === 200 || response.status === 201) {
        setMessage({ text: 'OTP resent successfully. Please check your email.', type: 'success' });
        setLastResendTime(now);
        setResendAttempts((prev) => {
          const newAttempts = prev + 1;
          if (newAttempts === 10) {
            setMessage({
              text: 'Maximum attempts reached. Next resend available after 5 minutes.',
              type: 'warning',
            });
          }
          return newAttempts;
        });
        setCooldownTime(cooldownDuration);
      } else {
        setMessage({ text: data.message || 'Failed to resend OTP. Please try again.', type: 'error' });
      }
    } catch (err) {
      console.error('Error resending OTP:', err);
      setMessage({ text: 'Network error. Please check your connection and try again.', type: 'error' });
    }
  };

  // Animation variants for the container
  const containerVariants = {
    hidden: { opacity: 0, y: 50 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.6, ease: 'easeOut' },
    },
  };

  // Animation variants for the inputs
  const inputVariants = {
    hidden: { opacity: 0, scale: 0.8 },
    visible: (i) => ({
      opacity: 1,
      scale: 1,
      transition: { delay: i * 0.1, duration: 0.3 },
    }),
  };

  // Animation variants for the button
  const buttonVariants = {
    hover: { scale: 1.05, transition: { duration: 0.3 } },
    tap: { scale: 0.95 },
  };

  // Animation variants for the resend link
  const linkVariants = {
    hover: {
      scale: 1.05,
      color: '#003664',
      transition: { duration: 0.2 },
    },
  };

  return (
    <div className="min-h-screen flex bg-[#FBFBFB]">
      {/* Left Side Image */}
      <div className="w-1/2 bg-[#003664]">
        <img
          src="src/assets/images/6.jpg"
          alt="OTP Verification Visual"
          className="w-full h-screen object-cover"
        />
      </div>

      {/* Right Side Form */}
      <div className="w-1/2 bg-[#f3f4f6] flex items-start justify-center pt-10">
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
            SYANA Home
          </motion.h1>
          <motion.h2
            className="text-xl font-bold text-[#003664] mb-6 text-left"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0, transition: { delay: 0.3, duration: 0.5 } }}
          >
            Verify OTP
          </motion.h2>
          <motion.p
            className="text-sm text-[#003664] mb-6 text-left"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0, transition: { delay: 0.4, duration: 0.5 } }}
          >
            Enter the OTP sent to your email to verify your account.
          </motion.p>

          {/* Messages */}
          {message.text && (
            <div
              className={`text-sm mb-4 ${
                message.type === 'success'
                  ? 'text-green-500'
                  : message.type === 'error'
                  ? 'text-red-500'
                  : 'text-yellow-500'
              }`}
            >
              {message.text}
            </div>
          )}

          {/* OTP Inputs */}
          <div className="flex gap-6 justify-center mb-6">
            {otp.map((digit, index) => (
              <motion.input
                key={index}
                type="text"
                maxLength={1}
                value={digit}
                onChange={(e) => handleChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                ref={(el) => (inputRefs.current[index] = el)}
                className="w-12 h-16 text-center text-xl border-2 border-gray-300 rounded-md focus:outline-none focus:border-[#003664]"
                variants={inputVariants}
                initial="hidden"
                animate="visible"
                custom={index}
              />
            ))}
          </div>

          {/* Submit Button */}
          <motion.button
            className="w-full bg-[#003664] text-white py-2 rounded-full font-semibold hover:bg-opacity-90 transition"
            onClick={handleOtp}
            variants={buttonVariants}
            whileHover="hover"
            whileTap="tap"
          >
            Verify OTP
          </motion.button>

          {/* Resend OTP */}
          <motion.p
            className="mt-6 text-sm text-gray-600 text-center"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1, transition: { delay: 0.5, duration: 0.5 } }}
          >
            Didn’t get OTP?{' '}
            {cooldownTime > 0 ? (
              <span className="text-gray-500">
                Try again in {cooldownTime} seconds
              </span>
            ) : (
              <motion.span
                className="text-[#003664] font-semibold hover:underline cursor-pointer"
                onClick={handleResendOtp}
                variants={linkVariants}
                whileHover="hover"
              >
                Resend OTP
              </motion.span>
            )}
          </motion.p>

         
        </motion.div>
      </div>
    </div>
  );
};

export default OTPInput;