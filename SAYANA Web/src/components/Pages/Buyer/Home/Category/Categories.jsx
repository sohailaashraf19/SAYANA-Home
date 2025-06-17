import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { motion, AnimatePresence } from "framer-motion";
import BedImage from "../../../../../assets/bed 1.jpg";
import DinningImage from "../../../../../assets/dinning 1.jpg";
import WallpapaerImage from "../../../../../assets/wallpaper 1.jpg";
import OutdoorImage from "../../../../../assets/outdoor 1.jpg";
import KitchenImage from "../../../../../assets/kitchen 1.jpg";
import StorageImage from "../../../../../assets/storage 1.jpg";
import ElectronicImage from "../../../../../assets/electronic 1.jpg";
import TableImage from "../../../../../assets/table 1.jpg";
import BathImage from "../../../../../assets/bath 2.jpg";
import DoorImage from "../../../../../assets/door 1.jpg";
import ChildrenImage from "../../../../../assets/kids 1.jpg";
import CarpetImage from "../../../../../assets/carpet 2.jpg";
import CurtainImage from "../../../../../assets/curtain 1.jpg";
import DecoreImage from "../../../../../assets/decore 1.jpg";
import LightingImage from "../../../../../assets/lighting 1.jpg";
import MirrorImage from "../../../../../assets/mirror 1.jpg";
import CeramicImage from "../../../../../assets/ceramic 1.jpg";
import SofaImage from "../../../../../assets/sofa 1.jpg";
import OFFICEImage from "../../../../../assets/office 2.jpg";
import ToolsImage from "../../../../../assets/Tool 1.jpg";
import ChairImage from "../../../../../assets/chair 2.jpg";
import FolderImage from "../../../../../assets/folder.jpg";

function Categories() {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const categoryImages = {
    bedroom: BedImage,
    dinningroom: DinningImage,
    "wallpaper&points": WallpapaerImage,
    outdoor: OutdoorImage,
    kitchen: KitchenImage,
    storage: StorageImage,
    electronic: ElectronicImage,
    table: TableImage,
    bathroom: BathImage,
    doors: DoorImage,
    cheldrrien_room: ChildrenImage,
    carpet: CarpetImage,
    curtain: CurtainImage,
    house_decore: DecoreImage,
    lighter: LightingImage,
    mirrors: MirrorImage,
    "ceramic&porcelain": CeramicImage,
    "livingroom&sofa": SofaImage,
    office: OFFICEImage,
    "kitchen accessories&tools": ToolsImage,
    chair: ChairImage,
    ديكور: FolderImage,
    uuyy: FolderImage,
    uuyy8: FolderImage,
    test: FolderImage,
  };

  useEffect(() => {
    const fetchCategories = async () => {
      const token = localStorage.getItem("token");
      if (!token) {
        setError("No authentication token found. Please log in.");
        setLoading(false);
        navigate("/buyer-login");
        return;
      }

      try {
        const response = await axios.get(
          "https://olivedrab-llama-457480.hostingersite.com/public/api/getAllCategories",
          {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "application/json",
              Accept: "application/json",
            },
          }
        );

        console.log("API Response:", response.data);
        setCategories(response.data);
        setLoading(false);
      } catch (err) {
        console.error("Error fetching categories:", err);
        if (err.response) {
          console.log("Error Response:", err.response.data);
          if (err.response.status === 401) {
            setError("Unauthorized. Please log in again.");
            localStorage.removeItem("token");
            navigate("/buyer-login");
          } else {
            setError("Failed to fetch categories. Please try again.");
          }
        } else {
          setError("Network error. Please check your connection.");
        }
        setLoading(false);
      }
    };

    fetchCategories();
  }, [navigate]);

  // Animation variants للكارد
  const cardVariants = {
    hidden: { opacity: 0, y: 50, scale: 0.8 },
    visible: (i) => ({
      opacity: 1,
      y: 0,
      scale: 1,
      transition: {
        duration: 0.4,
        delay: i * 0.1,
        ease: "easeOut",
      },
    }),
    hover: {
      scale: 1.1,
      transition: { duration: 0.3, ease: "easeInOut" },
    },
    tap: { scale: 0.95, transition: { duration: 0.2 } },
  };

  // Animation variants للصورة
  const imageVariants = {
    initial: { scale: 1 },
    hover: {
      scale: 1.15,
      filter: "brightness(110%)",
      boxShadow: "0 0 20px rgba(0, 54, 100, 0.4)",
      border: "3px solid #003664",
      transition: { duration: 0.3, ease: "easeInOut" },
    },
  };

  // Animation variants للـ spinner
  const spinnerVariants = {
    animate: {
      rotate: 360,
      scale: [1, 1.2, 1], // تأثير pulse
      transition: {
        rotate: { repeat: Infinity, duration: 1, ease: "linear" },
        scale: { repeat: Infinity, duration: 0.8, ease: "easeInOut" },
      },
    },
  };

  // Handle category click
  const handleCategoryClick = (categoryId) => {
    const category = categories.find((cat) => cat.Category_id === categoryId);
    if (category) {
      const normalizedCategoryName = category.Name.toLowerCase()
        .replace(/\s+/g, "-")
        .replace(/&/g, "&");
      navigate(`/buyer/category/${normalizedCategoryName}`);
    } else {
      console.warn(`Category with ID ${categoryId} not found.`);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 py-8 px-4 md:px-20">
      {/* Header Animation */}
      <motion.div
        className="text-center mb-8"
        initial={{ opacity: 0, y: -50 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
      >
        <h1 className="text-3xl md:text-4xl font-bold text-[#003664]">
          Browse Categories
        </h1>
        <p className="text-gray-600 mt-2">
          Explore our wide range of product categories
        </p>
      </motion.div>

      {/* Loading State */}
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

      {/* Error State */}
      {error && (
        <motion.div
          className="text-center text-red-500 font-semibold"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          {error}
        </motion.div>
      )}

      {/* Categories Grid */}
      {!loading && !error && (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
          {categories.length === 0 ? (
            <motion.div
              className="col-span-full text-center text-gray-500"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.4 }}
            >
              No categories available.
            </motion.div>
          ) : (
            categories.map((category, index) => (
              <motion.div
                key={category.Category_id}
                className="flex flex-col items-center cursor-pointer relative"
                custom={index}
                variants={cardVariants}
                initial="hidden"
                animate="visible"
                whileHover="hover"
                whileTap="tap"
                onClick={() => handleCategoryClick(category.Category_id)}
              >
                {/* Circular Image Container */}
                <motion.div
                  className="w-32 h-32 md:w-40 md:h-40 rounded-full overflow-hidden mb-2 relative"
                  variants={imageVariants}
                  initial="initial"
                  whileHover="hover"
                >
                  {categoryImages[category.Name.toLowerCase()] ? (
                    <img
                      src={categoryImages[category.Name.toLowerCase()]}
                      alt={category.Name}
                      className="w-full h-full object-cover"
                    />
                  ) : category.img ? (
                    <img
                      src={category.img}
                      alt={category.Name}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <div className="w-full h-full bg-gray-200 flex items-center justify-center rounded-full">
                      <span className="text-gray-500 text-sm">No Image</span>
                    </div>
                  )}
                </motion.div>
                {/* Category Name */}
                <motion.h2
                  className="text-sm md:text-lg font-semibold text-[#003664] text-center"
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3, delay: index * 0.15 }}
                >
                  {category.Name}
                </motion.h2>
              </motion.div>
            ))
          )}
        </div>
      )}
    </div>
  );
}

export default Categories;