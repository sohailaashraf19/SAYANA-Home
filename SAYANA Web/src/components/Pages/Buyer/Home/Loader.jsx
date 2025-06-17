import { motion } from "framer-motion";

// Animation variants for the spinner
const spinnerVariants = {
  animate: {
    rotate: 360,
    scale: [1, 1.2, 1], // Pulse effect
    transition: {
      rotate: { repeat: Infinity, duration: 1, ease: "linear" },
      scale: { repeat: Infinity, duration: 0.8, ease: "easeInOut" },
    },
  },
};

function Loader() {
  return (
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
  );
}

export default Loader;