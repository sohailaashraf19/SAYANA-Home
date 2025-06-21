import React, { useState } from "react";
import { ChatBubbleBottomCenterTextIcon, TicketIcon } from "@heroicons/react/24/solid";
import { motion, AnimatePresence } from "framer-motion";

// Spinner for loading
const spinnerVariants = {
  animate: {
    rotate: 360,
    scale: [1, 1.2, 1],
    transition: {
      rotate: { repeat: Infinity, duration: 1, ease: "linear" },
      scale: { repeat: Infinity, duration: 0.8, ease: "easeInOut" },
    },
  },
};

const Support = () => {
  // State for loader
  const [loading, setLoading] = useState(false);

  return (
    // خلي الخلفية نفس اللون اللي في صفحة Product: #FBFBFB
    <div className="flex min-h-screen" style={{ background: "#FBFBFB" }}>
      {/* Main content */}
      <div className="flex-1 flex flex-col items-center justify-center p-4">
        {/* Loader */}
        <AnimatePresence>
          {loading && (
            <motion.div
              className="flex justify-center items-center h-64"
              initial={{ opacity: 0, scale: 0.5 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.5 }}
              transition={{ duration: 0.4, ease: "easeInOut" }}
            >
              <motion.div
                className="relative h-20 w-20"
                variants={spinnerVariants}
                animate="animate"
              >
                <div
                  className="absolute inset-0 rounded-full"
                  style={{
                    background: "linear-gradient(45deg, #003664, #4a90e2)",
                    boxShadow: "0 0 15px rgba(0, 54, 100, 0.5)",
                  }}
                />
                <div className="absolute inset-2 rounded-full bg-gray-100" />
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Support Card */}
        {!loading && (
          <>
            <div className="bg-white shadow-xl rounded-3xl max-w-2xl w-full mx-auto px-8 py-10 flex flex-col items-center">
              {/* Illustration */}
              <div className="mb-6">
                <svg width="140" height="110" viewBox="0 0 140 110" fill="none">
                  <rect x="40" y="65" width="60" height="35" rx="8" fill="#F6FAFD" />
                  <rect x="52" y="75" width="36" height="17" rx="3" fill="#E0ECF8" />
                  <rect x="55" y="80" width="30" height="7" rx="2" fill="#D1E4F5" />
                  <ellipse cx="70" cy="45" rx="25" ry="18" fill="#F6FAFD" />
                  <rect x="62" y="30" width="16" height="20" rx="8" fill="#F0B972" />
                  <rect x="63" y="35" width="14" height="15" rx="6" fill="#F8D9AA" />
                  <rect x="67" y="46" width="2" height="2" rx="1" fill="#555" />
                  <rect x="71" y="46" width="2" height="2" rx="1" fill="#555" />
                  <rect x="69" y="49" width="2" height="1" rx="0.5" fill="#555" />
                  <text
                    x="110"
                    y="30"
                    fontSize="30"
                    fill="#C3C3C3"
                    fontWeight="bold"
                    fontFamily="Arial"
                  >
                    ?
                  </text>
                </svg>
              </div>
              {/* Main Title */}
              <h1 className="text-2xl md:text-3xl font-bold text-[#003664] mb-2 text-center">
                Need Help?
              </h1>
              {/* Subtitle */}
              <p className="text-gray-500 mb-6 text-center text-base md:text-lg">
                If you're experiencing any problems, feel free to reach put to us through the following contact options:
              </p>
              {/* Contact info */}
              <div className="w-full flex flex-col items-center">
                <span className="text-gray-400 mb-2">Or you can contact at</span>
                <div className="flex flex-col md:flex-row gap-3">
                  <a
                    href="mailto:support@domain.com"
                    className="px-3 py-1 rounded-lg bg-[#F6FAFD] text-[#003664] border border-[#CFE0EF] text-sm font-medium hover:bg-blue-50 transition"
                  >
                    E-mail: syana289289@gmail.com
                  </a>
                  <span className="px-3 py-1 rounded-lg bg-[#F6FAFD] text-[#003664] border border-[#CFE0EF] text-sm font-medium">
                    Phone: +20 123 456 7890
                  </span>
                </div>
              </div>
            </div>
            {/* Lower message */}
            <div className="mt-8 text-center text-gray-500 font-semibold text-lg">
              May be we have already the solution
            </div>
          </>
        )}
      </div>
      {/* Button animation style */}
      <style>
        {`
          @keyframes pulse-professional {
            0%, 100% {
              transform: scale(1);
              box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.7);
            }
            50% {
              transform: scale(1.05);
              box-shadow: 0 0 0 10px rgba(99, 102, 241, 0);
            }
          }
          .animate-pulse-professional {
            animation: pulse-professional 2.5s infinite;
          }
        `}
      </style>
    </div>
  );
};

export default Support;