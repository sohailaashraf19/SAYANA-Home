import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { HeartIcon as HeartOutlineIcon, HeartIcon as HeartSolidIcon } from "@heroicons/react/24/outline";
import axios from "axios";
import Loader from "../../Loader";

function Whishlist() {
  const [wishlist, setWishlist] = useState([]);
  const [isLoading, setIsLoading] = useState(true); // Add loading state

  // Framer Motion variants for card animation
  const cardVariants = {
    initial: { opacity: 0, scale: 0.9 },
    animate: (index) => ({
      opacity: 1,
      scale: 1,
      transition: { delay: index * 0.1, duration: 0.5 },
    }),
    hover: { scale: 1.05, opacity: 0.95, transition: { duration: 0.3 } },
    exit: { opacity: 0, scale: 0.9, transition: { duration: 0.3 } },
  };

  // Function to toggle an item in the wishlist (add or remove)
  const handleWishlistToggle = async (item) => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      console.error("buyer_id not found in localStorage");
      return;
    }

    const isInWishlist = wishlist.some((wishlistItem) => wishlistItem.product_id === item.product_id);

    try {
      if (isInWishlist) {
        const response = await axios.delete(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/removewishlist/${item.product_id}`,
          {
            data: { buyer_id: buyerId },
          }
        );
        if (response.status === 200) {
          setWishlist(wishlist.filter((wishlistItem) => wishlistItem.product_id !== item.product_id));
        }
      } else {
        const addResponse = await axios.post(
          "https://olivedrab-llama-457480.hostingersite.com/public/api/addwishlist",
          {
            product_id: item.product_id,
            buyer_id: buyerId,
          }
        );
        if (addResponse.status === 200) {
          const updatedWishlist = [
            ...wishlist,
            {
              product_id: item.product_id,
              name: item.name,
              category: item.category,
              image: item.image,
              price: item.price,
              discount: item.discount,
            },
          ];
          setWishlist(updatedWishlist);
        }
      }
    } catch (error) {
      console.error("Error toggling wishlist:", error);
    }
  };

  // Fetch wishlist data on component mount
  useEffect(() => {
    const fetchWishlist = async () => {
      setIsLoading(true); // Set loading to true
      const buyerId = localStorage.getItem("buyer_id");
      if (!buyerId) {
        console.error("buyer_id not found in localStorage");
        setIsLoading(false); // Stop loading if no buyerId
        return;
      }

      try {
        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/getwishlist`,
          {
            params: { buyer_id: buyerId },
          }
        );
        console.log("API Response:", response.data); // Log the full API response

        const baseUrl = "https://olivedrab-llama-457480.hostingersite.com/"; // Adjusted base URL
        const wishlistData = response.data.map((item) => {
          const imagePath = item.product?.images?.[0]?.image_path;
          const imageUrl = imagePath ? `${baseUrl}${encodeURI(imagePath)}` : "https://via.placeholder.com/300x200";
          console.log(`Constructed Image URL for ${item.product.name}: ${imageUrl}`);

          return {
            product_id: item.product.product_id,
            name: item.product.name,
            category: item.product.category_id ? `Category ${item.product.category_id}` : "Unknown",
            image: imageUrl,
            price: item.product.price,
            discount: item.product.discount,
          };
        });
        setWishlist(wishlistData);
      } catch (error) {
        console.error("Error fetching wishlist:", error);
        setWishlist([]); // Ensure wishlist is empty on error
      } finally {
        setIsLoading(false); // Stop loading regardless of success or failure
      }
    };

    fetchWishlist();
  }, []);

  // Show Loader while fetching data
  if (isLoading) {
    return (
      <div className="min-h-screen bg-[#FBFBFB] flex items-center justify-center p-4">
        <Loader />
      </div>
    );
  }

  return (
    <div className="p-4 min-h-screen bg-[#FBFBFB]">
      <h1 className="text-3xl font-bold mb-4">Wishlist</h1>
      <AnimatePresence>
        {wishlist.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {wishlist.map((item, index) => {
              const discountedPrice = item.discount > 0 ? (parseFloat(item.price) * (1 - item.discount / 100)).toFixed(2) : item.price;

              return (
                <motion.div
                  key={item.product_id || index}
                  className="relative bg-white rounded-lg shadow-md overflow-hidden h-full flex flex-col justify-between"
                  variants={cardVariants}
                  initial="initial"
                  animate="animate"
                  custom={index}
                  whileHover="hover"
                  exit="exit"
                >
                  <div className="relative w-full h-48">
                    <img
                      src={item.image}
                      alt={item.name}
                      className="w-full h-full object-cover"
                      onError={(e) => {
                        console.error(`Failed to load image for ${item.name}: ${item.image}`);
                        e.target.src = "https://via.placeholder.com/300x200";
                      }}
                    />
                    <div className="absolute top-2 right-2 flex space-x-2 z-10">
                      <button
                        onClick={() => handleWishlistToggle(item)}
                        className="text-red-500 hover:text-red-600"
                      >
                        {wishlist.some((wishlistItem) => wishlistItem.product_id === item.product_id) ? (
                          <HeartSolidIcon className="w-6 h-6" />
                        ) : (
                          <HeartOutlineIcon className="w-6 h-6" />
                        )}
                      </button>
                    </div>
                    <div className="absolute inset-0 bg-black opacity-50"></div>
                    {item.discount > 0 && (
                      <div className="absolute top-2 left-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded">
                        {item.discount}% OFF
                      </div>
                    )}
                  </div>
                  <div className="relative z-10 p-4 text-black cursor-pointer">
                    <h3 className="text-xl font-bold">{item.name || "Unnamed Item"}</h3>
                    <p className="text-sm mt-1">
                      Popular choice for {item.category?.toLowerCase() || "unknown"}
                    </p>
                    <div className="flex items-center mt-2">
                      <span className="text-md sm:text-lg font-bold text-blue-700">
                        {discountedPrice} EGP
                      </span>
                      {item.discount > 0 && (
                        <span className="text-sm text-gray-500 line-through ml-2">
                          {parseFloat(item.price).toFixed(2)} EGP
                        </span>
                      )}
                    </div>
                  </div>
                </motion.div>
              );
            })}
          </div>
        ) : (
          <p className="text-gray-500">Your wishlist is empty.</p>
        )}
      </AnimatePresence>
    </div>
  );
}

export default Whishlist;