import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Link, useNavigate } from "react-router-dom";
import { HeartIcon, ShoppingCartIcon, BellIcon, Squares2X2Icon } from "@heroicons/react/24/outline"; // Added Squares2X2Icon
import ProfileDropdown from "./Profile/ProfileDropdown";
import NotificationDropdown from "./Notification/NotificationDropDown";
import Categories from "../Category/Categories";
import axios from "axios";

function SayanaNav({ searchQuery, setSearchQuery }) {
  const [activeDropdown, setActiveDropdown] = useState(null);
  const [isNotificationsRead, setIsNotificationsRead] = useState(false);
  const [user, setUser] = useState({
    name: "",
    avatar: null,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [activeTab, setActiveTab] = useState("");
  const navigate = useNavigate();

  // Fetch user profile data from API
  useEffect(() => {
    const fetchProfile = async () => {
      const token = localStorage.getItem("token");
      if (!token) {
        setError("No authentication token found. Please log in.");
        setLoading(false);
        navigate("/buyer-login");
        return;
      }

      try {
        const response = await axios.get(
          "https://olivedrab-llama-457480.hostingersite.com/public/api/buyer/profile",
          {
            headers: {
              Authorization: `Bearer ${token}`,
              "Content-Type": "application/json",
              Accept: "application/json",
            },
          }
        );

        // Assuming response.data contains { buyer_id, name, email, phone }
        setUser({
          name: response.data.name,
          avatar: null,
        });
        setLoading(false);
      } catch (err) {
        console.error("Error fetching profile:", err);
        if (err.response) {
          if (err.response.status === 401) {
            setError("Unauthorized. Please log in again.");
            localStorage.removeItem("token");
            localStorage.removeItem("user");
            navigate("/buyer-login");
          } else {
            setError("Failed to fetch profile. Please try again.");
          }
        } else {
          setError("Network error. Please check your connection.");
        }
        setLoading(false);
      }
    };

    fetchProfile();
  }, [navigate]);

  const iconVariants = {
    hover: { scale: 1.1, transition: { duration: 0.2 } },
    tap: { scale: 0.95, transition: { duration: 0.1 } },
  };

  const buttonVariants = {
    active: {
      scale: 1.05,
      color: "#6A0DAD",
      transition: { duration: 0.2, ease: "easeOut" },
    },
    inactive: {
      scale: 1,
      color: "#201A23",
      transition: { duration: 0.2, ease: "easeOut" },
    },
  };

  const handleDropdownToggle = (dropdownName) => {
    if (dropdownName === "wishlist") {
      navigate("/buyer/wishlist");
      setActiveDropdown(null);
      setActiveTab(null);
    } else if (dropdownName === "/cart") {
      navigate("/buyer/cart");
      setActiveDropdown(null);
      setActiveTab(null);
    } else if (dropdownName === "categories") {
      navigate("/buyer/categories");
      setActiveDropdown(null);
      setActiveTab(null);
    } else {
      if (activeDropdown === dropdownName) {
        setActiveDropdown(null);
        setActiveTab(null);
      } else {
        setActiveDropdown(dropdownName);
        setActiveTab(dropdownName);
      }
    }
  };

  const handleSearchChange = (e) => {
    setSearchQuery(e.target.value);
  };

  return (
    <div className="bg-[#003664] fixed top-0 left-0 right-0 z-50">
      <div className="flex flex-col md:flex-row justify-between items-center px-4 md:px-20 py-4">
        {/* Logo */}
        <motion.div
          className="flex items-center font-bold text-xl md:text-2xl ml-4 md:ml-20 text-white"
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5 }}
        >
          <Link to="/buyer">SAYANA Home</Link>
        </motion.div>

        {/* Search Input */}
        <motion.div
          className="w-full md:w-auto mx-4 md:mx-32 mt-2 md:mt-0"
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <input
            type="text"
            placeholder="Search for products ..."
            value={searchQuery}
            onChange={handleSearchChange}
            className="w-full p-2 rounded-full border-2 border-gray-300 focus:outline-none focus:ring-[#003664] text-black md:w-[500px]"
          />
        </motion.div>

        {/* Icons Section */}
        <motion.div
          className="flex items-center space-x-4 md:space-x-6 cursor-pointer mt-2 md:mt-0"
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5 }}
        >
          {/* Categories Icon */}
          <div className="relative">
            <motion.div
              className="relative"
              variants={iconVariants}
              whileHover="hover"
              whileTap="tap"
              onClick={() => handleDropdownToggle("categories")}
            >
              <Squares2X2Icon className="w-6 h-6 md:w-7 md:h-7 text-white" />
            </motion.div>
          </div>

          {/* Wishlist Icon */}
          <div className="relative">
            <motion.div
              className="relative"
              variants={iconVariants}
              whileHover="hover"
              whileTap="tap"
              onClick={() => handleDropdownToggle("wishlist")}
            >
              <HeartIcon className="w-6 h-6 md:w-7 md:h-7 text-white" />
            </motion.div>
          </div>

          {/* Cart Icon */}
          <div className="relative">
            <motion.div
              className="relative"
              variants={iconVariants}
              whileHover="hover"
              whileTap="tap"
              onClick={() => handleDropdownToggle("/cart")}
            >
              <ShoppingCartIcon className="w-6 h-6 md:w-7 md:h-7 text-white" />
            </motion.div>
          </div>

          {/* Bell Icon with Notification Dropdown */}
          <div
            className="relative"
            onMouseEnter={() => {
              setActiveDropdown("notifications");
              setIsNotificationsRead(true);
            }}
            onMouseLeave={() => setActiveDropdown(null)}
          >
            <motion.div
              className="relative cursor-pointer"
              variants={iconVariants}
              whileHover="hover"
              whileTap="tap"
              onClick={() => handleDropdownToggle("notification")}
            >
              <BellIcon className="w-6 h-6 md:w-7 md:h-7 text-white" />
              {!isNotificationsRead && (
                <>
                  <span className="absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-500 ring-2 ring-white animate-ping"></span>
                  <span className="absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span>
                </>
              )}
            </motion.div>

            <AnimatePresence>
              {activeDropdown === "notifications" && (
                <motion.div
                  key="notifications-dropdown"
                  initial={{ opacity: 0, y: -10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -10 }}
                  transition={{ duration: 0.2 }}
                  className="absolute top-full right-0 mt-2"
                >
                  <NotificationDropdown
                    onClose={() => setActiveDropdown(null)}
                  />
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Profile Avatar and Dropdown */}
          {loading ? (
            <div className="w-8 h-8 bg-gray-900 rounded-full flex items-center justify-center text-white font-bold text-sm">
              ...
            </div>
          ) : error ? (
            <div className="w-8 h-8 bg-gray-900 rounded-full flex items-center justify-center text-white font-bold text-sm">
              !!
            </div>
          ) : (
            <div
              className="relative"
              onMouseEnter={() => setActiveDropdown("profile")}
              onMouseLeave={() => setActiveDropdown(null)}
            >
              <motion.div
                className="relative flex items-center"
                variants={iconVariants}
                whileHover="hover"
                whileTap="tap"
                onClick={() => handleDropdownToggle("profile")}
              >
                {user.avatar ? (
                  <img
                    src={user.avatar}
                    alt="Avatar"
                    className="w-8 h-8 rounded-full object-cover cursor-pointer"
                  />
                ) : (
                  <div className="w-8 h-8 bg-gray-900 rounded-full flex items-center justify-center text-white font-bold text-sm cursor-pointer">
                    {user.name
                      ? user.name
                          .split(" ")
                          .map((n) => n[0])
                          .join("")
                          .slice(0, 2)
                      : "NA"}
                  </div>
                )}
              </motion.div>

              <AnimatePresence>
                {activeDropdown === "profile" && (
                  <motion.div
                    key="profile-dropdown"
                    initial={{ opacity: 0, y: -10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -10 }}
                    transition={{ duration: 0.2 }}
                    className="absolute top-full right-0 mt-2"
                  >
                    <ProfileDropdown
                      onClose={() => setActiveDropdown(null)}
                    />
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          )}
        </motion.div>
      </div>
    </div>
  );
}

export default SayanaNav;