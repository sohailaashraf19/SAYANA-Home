import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { useOutletContext, useNavigate } from "react-router-dom";
import { HeartIcon as HeartOutlineIcon, ShoppingCartIcon as CartOutlineIcon } from "@heroicons/react/24/outline";
import { HeartIcon as HeartSolidIcon, ShoppingCartIcon as CartSolidIcon } from "@heroicons/react/24/solid";
import axios from "axios";
import sofa from "../../../../assets/images/3.jpg";
import kitchen from "../../../../assets/images/1.jpg";
import bath from "../../../../assets/images/2.jpg";
import Outdoor from "../../../../assets/images/4.jpg";
import Bedroom from "../../../../assets/images/5.jpg";
import office from "../../../../assets/images/8.jpg";
import lens from "../../../../assets/images/search.png";
import Loader from "./Loader";

function Home() {
  const { searchQuery, setSearchQuery, wishlist = [], setWishlist, cart, setCart } = useOutletContext();
  const navigate = useNavigate();
  const [categories, setCategories] = useState([]);
  const [loadingCategories, setLoadingCategories] = useState(true);
  const [currentCategoryIndex, setCurrentCategoryIndex] = useState(-1);
  const [displayText, setDisplayText] = useState("Search on Photos of your category home");
  const [confirmationMessage, setConfirmationMessage] = useState(null);
  const [currentSlideIndex, setCurrentSlideIndex] = useState(0);
  const [fade, setFade] = useState(true);
  const [iconStates, setIconStates] = useState({});
  const [bestSellingItems, setBestSellingItems] = useState([]);
  const [currentImageIndices, setCurrentImageIndices] = useState({});

  useEffect(() => {
    const fetchCategories = async () => {
      try {
        const response = await axios.get("https://olivedrab-llama-457480.hostingersite.com/public/api/getAllCategories");
        console.log("Categories in Home:", response.data);
        const validCategories = Array.isArray(response.data)
          ? response.data.map((cat) => ({
              id: cat.Category_id,
              name: cat.Name.toLowerCase().replace(/\s+/g, "-"),
            }))
          : [];
        setCategories(validCategories);
        setLoadingCategories(false);
      } catch (error) {
        console.error("Error fetching categories in Home:", error);
        setCategories([]);
        setLoadingCategories(false);
      }
    };
    fetchCategories();
  }, []);

  const getCategoryRoute = (categoryName) => {
    return categoryName.toLowerCase().replace(/\s+/g, "-");
  };

  const slides = [
    {
      image: sofa,
      alt: "Interior Design Living Room",
      buttons: [
        { text: "livingroom&sofa", bottom: "28%", left: "85%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("livingroom&sofa")}`) },
        { text: "livingroom&sofa", bottom: "36%", left: "67%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("livingroom&sofa")}`) },
        { text: "Chair", bottom: "13%", left: "71%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("chair")}`) },
        { text: "lighter", bottom: "47%", left: "31%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("lighter")}`) },
        { text: "House_decore", bottom: "46%", left: "21%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("House_decore")}`) },
        { text: "House_decore", bottom: "55%", left: "73%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("House_decore")}`) },
        { text: "lighter", bottom: "50%", left: "84.5%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("lighter")}`) },
        { text: "table", bottom: "27%", left: "52%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("table")}`) },
        { text: "table", bottom: "27.5%", left: "12.5%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("table")}`) },
        { text: "carpet", bottom: "23%", left: "30%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("carpet")}`) },
        { text: "electronic", bottom: "43%", left: "5%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("electronic")}`) },
        { text: "curtain", bottom: "66%", left: "16%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("curtain")}`) },
        { text: "wallpaper&points", bottom: "66%", left: "52%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("wallpaper&points")}`) },
      ],
    },
    {
      image: kitchen,
      alt: "Interior Design Bathroom",
      buttons: [
        { text: "kitchen accessories&tools", bottom: "43%", left: "41%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("kitchen accessories&tools")}`) },
        { text: "Dinningroom", bottom: "43%", left: "67%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("Dinningroom")}`) },
        { text: "Dinningroom", bottom: "25%", left: "33%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("Dinningroom")}`) },
        { text: "electronic", bottom: "53%", left: "3%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("electronic")}`) },
        { text: "House_decore", bottom: "49%", left: "75.5%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("House_decore")}`) },
        { text: "lighter", bottom: "72%", left: "64.5%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("lighter")}`) },
      ],
    },
    {
      image: bath,
      alt: "Interior Design Kitchen",
      buttons: [
        { text: "House_decore", bottom: "49.5%", left: "29.5%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("House_decore")}`) },
        { text: "lighter", bottom: "82%", left: "17.3%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("lighter")}`) },
        { text: "mirrors", bottom: "66%", left: "16%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("mirrors")}`) },
        { text: "ceramic&porcelain", bottom: "56%", left: "83%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("ceramic&porcelain")}`) },
        { text: "bathroom", bottom: "37%", left: "51%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("bathroom")}`) },
      ],
    },
    {
      image: Outdoor,
      alt: "Interior Design Kitchen",
      buttons: [
        { text: "House_decore", bottom: "49%", left: "93%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("House_decore")}`) },
        { text: "lighter", bottom: "82.5%", left: "40%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("lighter")}`) },
        { text: "outdoor", bottom: "39%", left: "36%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("outdoor")}`) },
        { text: "outdoor", bottom: "45%", left: "69%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("outdoor")}`) },
      ],
    },
    {
      image: Bedroom,
      alt: "Interior Design Kitchen",
      buttons: [
        { text: "House_decore", bottom: "44%", left: "91%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("House_decore")}`) },
        { text: "BedRoom", bottom: "34%", left: "31%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("BedRoom")}`) },
        { text: "carpet", bottom: "20%", left: "79%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("carpet")}`) },
        { text: "curtain", bottom: "60%", left: "48%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("curtain")}`) },
      ],
    },
    {
      image: office,
      alt: "Interior Design Kitchen",
      buttons: [
        { text: "office", bottom: "22%", left: "45%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("office")}`) },
        { text: "Doors", bottom: "45%", left: "83%", onClick: () => navigate(`/buyer/category/${getCategoryRoute("Doors")}`) },
      ],
    },
  ];

  // Extract unique category names from slides for display
  const uniqueCategories = Array.from(new Set(slides.flatMap(slide => slide.buttons.map(button => button.text))));

  // Cycle through categories for the text animation
  useEffect(() => {
    if (loadingCategories || uniqueCategories.length === 0) return;

    const interval = setInterval(() => {
      setCurrentCategoryIndex((prevIndex) => {
        if (prevIndex === -1) {
          setDisplayText(`Search on Photos of your category ${uniqueCategories[0]}`);
          return 0;
        } else if (prevIndex < uniqueCategories.length - 1) {
          setDisplayText(`Search on Photos of your category ${uniqueCategories[prevIndex + 1]}`);
          return prevIndex + 1;
        } else {
          setDisplayText("Search on Photos of your category home");
          return -1;
        }
      });
    }, 2000);
    return () => clearInterval(interval);
  }, [loadingCategories, uniqueCategories]);

  useEffect(() => {
    const fetchBestSellingItems = async () => {
      try {
        const response = await axios.get("https://olivedrab-llama-457480.hostingersite.com/public/api/products/best-selling");
        const baseUrl = "https://olivedrab-llama-457480.hostingersite.com/";
        const items = response.data.map((item) => ({
          ...item,
          images: item.images.map((img) => ({
            ...img,
            full_url: `${baseUrl}${encodeURI(img.image_path)}`,
          })),
        }));
        setBestSellingItems(items);
        const initialIndices = {};
        items.forEach((item) => {
          initialIndices[item.product_id] = 0;
        });
        setCurrentImageIndices(initialIndices);
      } catch (error) {
        console.error("Error fetching best-selling items:", error);
        setBestSellingItems([]);
      }
    };
    fetchBestSellingItems();
  }, []);

  const filteredItems = bestSellingItems.filter((item) =>
    item.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  useEffect(() => {
    const interval = setInterval(() => {
      setFade(false);
      setTimeout(() => {
        setCurrentSlideIndex((prevIndex) => (prevIndex + 1) % slides.length);
        setFade(true);
      }, 300);
    }, 20000);
    return () => clearInterval(interval);
  }, [slides.length]);

  const handleNextSlide = () => {
    setFade(false);
    setTimeout(() => {
      setCurrentSlideIndex((prevIndex) => (prevIndex + 1) % slides.length);
      setFade(true);
    }, 300);
  };

  const handlePrevSlide = () => {
    setFade(false);
    setTimeout(() => {
      setCurrentSlideIndex((prevIndex) => (prevIndex === 0 ? slides.length - 1 : prevIndex - 1));
      setFade(true);
    }, 300);
  };

  const handleNextImage = (productId, imageCount) => {
    setCurrentImageIndices((prev) => ({
      ...prev,
      [productId]: (prev[productId] + 1) % imageCount,
    }));
  };

  const handlePrevImage = (productId, imageCount) => {
    setCurrentImageIndices((prev) => ({
      ...prev,
      [productId]: (prev[productId] - 1 + imageCount) % imageCount,
    }));
  };

  const pageVariants = { initial: { opacity: 0 }, animate: { opacity: 1 }, exit: { opacity: 0 } };
  const slideVariants = { initial: { opacity: 0, x: 50 }, animate: { opacity: 1, x: 0 }, exit: { opacity: 0, x: -50 } };
  const cardVariants = {
    initial: { opacity: 0, scale: 0.9 },
    animate: (index) => ({ opacity: 1, scale: 1, transition: { delay: index * 0.1, duration: 0.5 } }),
    hover: { scale: 1.05, opacity: 0.95, transition: { duration: 0.3 } },
  };

  const emojiVariants = {
    animate: {
      y: [0, -10, 0],
      rotate: [0, 5, -5, 0],
      transition: {
        y: { repeat: Infinity, duration: 1, ease: "easeInOut" },
        rotate: { repeat: Infinity, duration: 1.5, ease: "easeInOut" },
      },
    },
  };

  const buttonVariants = {
    initial: { opacity: 0, y: 20 },
    animate: (i) => ({
      opacity: 1,
      y: 0,
      transition: {
        delay: i * 0.1,
        duration: 0.5,
        ease: "easeOut",
      },
    }),
    hover: {
      scale: 1.1,
      transition: { duration: 0.3, ease: "easeOut" },
    },
  };

  const handleWishlistToggle = async (item) => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      alert("Please log in to add items to your wishlist.");
      return;
    }

    const body = new URLSearchParams();
    body.append("product_id", item.product_id);
    body.append("buyer_id", buyerId);

    try {
      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/addwishlist",
        body.toString(),
        { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
      );
      if (response.status === 200) {
        const itemObj = {
          product_id: item.product_id,
          name: item.name,
          image: item.images[0]?.full_url || "https://source.unsplash.com/300x200/?product",
          category: "Best Selling",
          price: item.price,
        };
        const isInWishlist = wishlist.some((wishlistItem) => wishlistItem.product_id === item.product_id);
        setWishlist(
          isInWishlist
            ? wishlist.filter((wishlistItem) => wishlistItem.product_id !== item.product_id)
            : [...wishlist, itemObj]
        );
        setConfirmationMessage(
          isInWishlist
            ? `${item.name} has been removed from your wishlist!`
            : `${item.name} has been added to your wishlist!`
        );
        setTimeout(() => setConfirmationMessage(null), 3000);
      } else {
        console.error("Unexpected response status:", response.status);
      }
    } catch (error) {
      console.error("Error adding to wishlist:", error.response?.data || error.message);
    }
    setIconStates((prev) => ({
      ...prev,
      [item.product_id]: { ...prev[item.product_id], heart: !prev[item.product_id]?.heart },
    }));
  };

  const handleCartToggle = async (item) => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      alert("Please log in to add items to your cart.");
      return;
    }

    const body = new URLSearchParams();
    body.append("product_id", item.product_id);
    body.append("qty", 1);
    body.append("buyer_id", buyerId);

    try {
      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/cart_add",
        body.toString(),
        { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
      );
      if (response.status === 200) {
        const isInCart = cart.some((cartItem) => cartItem.product_id === item.product_id);
        setCart(
          isInCart
            ? cart.filter((cartItem) => cartItem.product_id !== item.product_id)
            : [
                ...cart,
                {
                  product_id: item.product_id,
                  name: item.name,
                  image: item.images[0]?.full_url || "https://source.unsplash.com/300x200/?product",
                  quantity: 1,
                  price: item.price,
                },
              ]
        );
        setConfirmationMessage(
          isInCart
            ? `${item.name} has been removed from your cart!`
            : `${item.name} has been added to your cart!`
        );
        setTimeout(() => setConfirmationMessage(null), 3000);
      } else {
        console.error("Unexpected response status:", response.status);
      }
    } catch (error) {
      console.error("Error adding to cart:", error.response?.data || error.message);
    }
    setIconStates((prev) => ({
      ...prev,
      [item.product_id]: { ...prev[item.product_id], cart: !prev[item.product_id]?.cart },
    }));
  };

  if (loadingCategories) {
    return <Loader />;
  }

  const currentSlide = slides[currentSlideIndex];

  return (
    <motion.div
      className="min-h-screen bg-[#FBFBFB] flex flex-col items-center justify-start"
      variants={pageVariants}
      initial="initial"
      animate="animate"
      exit="exit"
      transition={{ duration: 1 }}
    >
      <AnimatePresence>
        {confirmationMessage && (
          <motion.div
            className="fixed top-5 right-5 bg-white text-black px-4 py-3 rounded-md shadow-lg z-50 border border-gray-200 flex items-center justify-between"
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.3 }}
          >
            <span>{confirmationMessage}</span>
            {confirmationMessage.includes("added to cart") && (
              <button
                onClick={() => navigate("/buyer/cart")}
                className="ml-4 bg-[#003664] text-white px-3 py-1 rounded-md hover:bg-gray-600 transition duration-300"
              >
                Go to Cart
              </button>
            )}
            {confirmationMessage.includes("added to wishlist") && (
              <button
                onClick={() => navigate("/buyer/wishlist")}
                className="ml-4 bg-[#003664] text-white px-3 py-1 rounded-md hover:bg-gray-600 transition duration-300"
              >
                Go to Wishlist
              </button>
            )}
          </motion.div>
        )}
      </AnimatePresence>

      <div className="flex items-center space-x-4 my-2.5">
        <motion.div
          className="text-4xl"
          variants={emojiVariants}
          animate="animate"
        >
          <img src={lens} className="w-12 h-12" alt="" />
        </motion.div>
        <motion.div
          className="text-xl font-semibold text-gray-800"
          key={displayText}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.5 }}
        >
          {displayText}
        </motion.div>
      </div>

      <div className="relative rounded-md overflow-hidden">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentSlideIndex}
            className="relative"
            variants={slideVariants}
            initial="initial"
            animate="animate"
            exit="exit"
            transition={{ duration: 0.3 }}
          >
            <img src={currentSlide.image} alt={currentSlide.alt} className="w-[1529px] h-[690px]" />
            {currentSlide.buttons.map((button, index) => (
              <motion.div
                key={`${currentSlideIndex}-${index}`}
                className="absolute group"
                style={{ bottom: button.bottom, left: button.left, transform: "translateX(-50%)" }}
                variants={buttonVariants}
                initial="initial"
                animate="animate"
                custom={index}
                whileHover="hover"
              >
                <button
                  className="relative w-8 h-8 bg-transparent border-2 border-white/30 rounded-full flex items-center justify-center transition-all hover:bg-white/10 focus:bg-white/10 duration-300 ease-in-out shadow-md z-10 pointer-events-auto"
                  onClick={button.onClick}
                  aria-label={`Navigate to ${button.text} category`}
                >
                  <span className="w-4 h-4 bg-white rounded-full"></span>
                </button>
                <span className="absolute bottom-full mb-2 left-1/2 transform -translate-x-1/2 bg-[#003664] text-white text-xs font-semibold px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none whitespace-nowrap">
                  {button.text.replace(/&/g, " & ").replace(/_/g, " ")}
                </span>
              </motion.div>
            ))}
            <button
              className="absolute bottom-5 left-5 bg-[#003664] text-white rounded-full w-12 h-12 flex items-center justify-center transition-all hover:bg-gray-600 focus:bg-gray-600 duration-300 ease-in-out z-20"
              onClick={handlePrevSlide}
            >
              <span className="text-xl">&lt;</span>
            </button>
            <button
              className="absolute bottom-5 right-5 bg-[#003664] text-white rounded-full w-12 h-12 flex items-center justify-center transition-all hover:bg-gray-600 focus:bg-gray-600 duration-300 ease-in-out z-20"
              onClick={handleNextSlide}
            >
              <span className="text-xl">&gt;</span>
            </button>
          </motion.div>
        </AnimatePresence>
      </div>
      <div className="w-full max-w-[1521px] mt-8">
        <h2 className="text-2xl font-bold mb-4">Best Selling Items</h2>
        {filteredItems.length === 0 ? (
          <p className="text-gray-500">No best-selling items found.</p>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {filteredItems.map((item, index) => {
              const discountedPrice = item.discount > 0
                ? (parseFloat(item.price) * (1 - item.discount / 100)).toFixed(2)
                : item.price;
              const currentImageIndex = currentImageIndices[item.product_id] || 0;
              const currentImage = item.images && item.images[currentImageIndex]?.full_url || "https://source.unsplash.com/300x200/?product";

              return (
                <motion.div
                  key={item.product_id}
                  className="relative bg-white rounded-lg shadow-md overflow-hidden h-full flex flex-col justify-between group"
                  variants={cardVariants}
                  initial="initial"
                  animate="animate"
                  custom={index}
                  whileHover="hover"
                >
                  <div className="relative w-full h-48">
                    <img
                      src={currentImage}
                      alt={item.name}
                      className="w-full h-48 object-cover"
                      onError={(e) => {
                        console.error(`Failed to load image for ${item.name}: ${currentImage}`);
                        e.target.src = "https://source.unsplash.com/300x200/?product";
                      }}
                    />
                    <div className="absolute top-4 right-2 flex flex-col space-y-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300 z-10">
                      <button
                        onClick={() => handleWishlistToggle(item)}
                        className="bg-white rounded-full w-8 h-8 flex items-center justify-center shadow-sm hover:shadow-md"
                      >
                        {wishlist.some((wishlistItem) => wishlistItem.product_id === item.product_id) ? (
                          <HeartSolidIcon className="w-5 h-5 text-red-500" />
                        ) : (
                          <HeartOutlineIcon className="w-5 h-5 text-gray-600 hover:text-red-500" />
                        )}
                      </button>
                      <button
                        onClick={() => handleCartToggle(item)}
                        className="bg-white rounded-full w-8 h-8 flex items-center justify-center shadow-sm hover:shadow-md"
                      >
                        {iconStates[item.product_id]?.cart ? (
                          <CartSolidIcon className="w-5 h-5 text-green-500" />
                        ) : (
                          <CartOutlineIcon className="w-5 h-5 text-gray-600 hover:text-green-500" />
                        )}
                      </button>
                    </div>
                    {item.discount > 0 && (
                      <div className="absolute top-2 left-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded">
                        {item.discount}% OFF
                      </div>
                    )}
                  </div>
                  <div
                    onClick={() => navigate("/buyer/product-detail", { state: { product: item } })}
                    className="relative z-10 p-4 text-black cursor-pointer"
                  >
                    <h3 className="text-lg font-bold">{item.name}</h3>
                    <p className="text-sm mt-1 truncate">{item.description}</p>
                    <div className="flex items-center mt-2">
                      <span className="text-md sm:text-lg font-bold text-blue-700">{discountedPrice} L.E</span>
                      {item.discount > 0 && (
                        <span className="text-sm text-gray-500 line-through ml-2">{parseFloat(item.price).toFixed(2)} L.E</span>
                      )}
                    </div>
                  </div>
                </motion.div>
              );
            })}
          </div>
        )}
      </div>
    </motion.div>
  );
}

export default Home;


