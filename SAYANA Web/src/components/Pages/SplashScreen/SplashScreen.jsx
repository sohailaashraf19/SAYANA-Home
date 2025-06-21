import  { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";

const SplashScreen = () => {
  const navigate = useNavigate();
  const [currentImage, setCurrentImage] = useState(0);
  const [showButtons, setShowButtons] = useState(false);

  const images = [
    "src/assets/images/pp4.avif",
    "src/assets/images/pp7.avif",
    "src/assets/images/pp14.avif",
  ];

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentImage((prev) => {
        if (prev < images.length - 1) {
          return prev + 1;
        } else {
          clearInterval(timer);
          setShowButtons(true);
          return prev;
        }
      });
    }, 2000);

    return () => clearInterval(timer);
  }, []);

  return (
    <div className="flex items-center justify-center h-screen bg-[#003664] relative overflow-hidden">
      {/* الصور */}
      <motion.img
        src={images[currentImage]}
        alt="Sliding Image"
        className="w-full h-full object-cover max-w-[100%] max-h-[100%] mx-auto"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 1 }}
      />

      {/* النص والأزرار بعد انتهاء العرض */}
      {showButtons && (
        <>
          {/* النص المتحرك في أعلى يسار الصفحة */}
          <motion.h1
            className="absolute top-8 left-8 text-white text-3xl font-bold drop-shadow-lg"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, ease: "easeOut" }}
          >
            Welcome to SYANA Home
          </motion.h1>

          {/* النص الثاني بحركة */}
          <motion.p
            className="absolute top-24 left-8 text-white text-xl font-medium drop-shadow-lg"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1.2, ease: "easeOut" }}
          >
            Making your home feel like home, one piece at a time.
          </motion.p>

          {/* الأزرار المتحركة في أسفل يمين الصفحة */}
          <motion.div
            className="absolute bottom-4 right-4 flex gap-16"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, ease: "easeOut" }}
          >
            <button
              onClick={() => navigate("/login")}
              className="bg-[#003664] text-white px-6 py-2 rounded-full border border-[#003664] shadow-md hover:opacity-80 transition duration-300"
            >
              Seller
            </button>
            <button
              onClick={() => navigate("/buyer-login")}
              className="bg-[#003664] text-white px-6 py-2 rounded-full border border-[#003664] shadow-md hover:opacity-80 transition duration-300"
            >
              Buyer
            </button>
          </motion.div>
        </>
      )}
    </div>
  );
};

export default SplashScreen;
