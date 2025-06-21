import React, { useState, useEffect } from "react";
import { useParams, useOutletContext, useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import { HeartIcon as HeartOutlineIcon, ShoppingCartIcon as CartOutlineIcon } from "@heroicons/react/24/outline";
import { HeartIcon as HeartSolidIcon, ShoppingCartIcon as CartSolidIcon } from "@heroicons/react/24/solid";
import axios from "axios";
import Loader from "../Loader";

function CategoryPage() {
  const { categoryName } = useParams();
  const { searchQuery, wishlist = [], setWishlist, cart = [], setCart } = useOutletContext();
  const navigate = useNavigate();

  const [allCategories, setAllCategories] = useState([]);
  const [categoryProducts, setCategoryProducts] = useState([]);
  const [iconStates, setIconStates] = useState({});
  const [isLoading, setIsLoading] = useState(true);
  const [isLoadingCategories, setIsLoadingCategories] = useState(true);
  const [isLoadingProducts, setIsLoadingProducts] = useState(false);
  const [errorMessage, setErrorMessage] = useState(null);
  const [displayCategoryName, setDisplayCategoryName] = useState("");
  const [confirmationMessage, setConfirmationMessage] = useState(null);

  const API_BASE_URL = "https://olivedrab-llama-457480.hostingersite.com";

  useEffect(() => {
    const fetchAllCategories = async () => {
      setIsLoadingCategories(true);
      setIsLoading(true);
      setErrorMessage(null);
      setAllCategories([]);

      try {
        const response = await axios.get(`${API_BASE_URL}/public/api/getAllCategories`);
        console.log("API Response (All Categories):", response.data);

        const fetchedCategories = Array.isArray(response.data?.data) ? response.data.data : Array.isArray(response.data) ? response.data : [];
        const validCategories = fetchedCategories
          .filter((cat) => cat && typeof cat.Name === "string" && cat.Category_id != null)
          .map((cat) => ({
            id: cat.Category_id,
            name: cat.Name.toLowerCase().replace(/\s+/g, "-").replace(/&/g, "&"),
          }));
        console.log("Processed Categories (mapped to id, name):", validCategories);
        setAllCategories(validCategories);

        if (validCategories.length === 0) {
          console.warn("No valid categories found in API response.");
          setErrorMessage("No categories available at this time.");
        }
      } catch (err) {
        console.error("Error fetching categories:", err);
        setErrorMessage("Failed to load categories. Please try again later.");
      } finally {
        setIsLoadingCategories(false);
        setIsLoading(false);
      }
    };
    fetchAllCategories();
  }, [API_BASE_URL]);

  useEffect(() => {
    if (isLoadingCategories || !categoryName || allCategories.length === 0) {
      if (!isLoadingCategories && categoryName && allCategories.length === 0 && !errorMessage) {
        console.warn(`Attempted to find category "${categoryName}" but no categories are loaded.`);
      }
      return;
    }

    setIsLoadingProducts(true);
    setIsLoading(true);
    setErrorMessage(null);
    setCategoryProducts([]);

    let nameToSearch = categoryName.toLowerCase();
    if (nameToSearch === "kitchen-accessories&tool") {
      nameToSearch = "kitchen-accessories&tools";
      console.log("Applied specific fix: URL slug was 'kitchen-accessories&tool', now searching for 'kitchen-accessories&tools'");
    }

    setDisplayCategoryName(nameToSearch.replace(/-/g, " "));
    console.log(`Attempting to find category with name: "${nameToSearch}"`);
    const matchedCategory = allCategories.find((cat) => cat.name === nameToSearch);
    console.log("Matched category object:", matchedCategory);

    if (matchedCategory) {
      const fetchProducts = async () => {
        try {
          const response = await axios.get(`${API_BASE_URL}/public/api/products_category/${matchedCategory.id}`);
          console.log(`API Response (Products for ${matchedCategory.name}):`, response.data);

          const productsData = Array.isArray(response.data?.data) ? response.data.data : Array.isArray(response.data) ? response.data : [];
          const processedProducts = productsData.map((item) => ({
            ...item,
            product_id: item.product_id,
            name: item.name || "Unnamed Product",
            description: item.description || "No description available.",
            price: parseFloat(item.price) || 0,
            discount: parseFloat(item.discount) || 0,
            quantity: parseInt(item.quantity) || 0,
            image: item.images && item.images.length > 0 && item.images[0].image_path
              ? `${API_BASE_URL}/${encodeURI(item.images[0].image_path.replace(/^public\//, '').replace(/^img\//, 'img/'))}`
              : item.image || "https://source.unsplash.com/300x200/?product&text=No+Image",
            original_images: item.images || [],
          }));
          setCategoryProducts(processedProducts);
        } catch (err) {
          console.error(`Error fetching products for ${matchedCategory.name}:`, err);
          setErrorMessage(`Failed to load products for "${matchedCategory.name.replace(/-/g, " ")}".`);
        } finally {
          setIsLoadingProducts(false);
          setIsLoading(false);
        }
      };
      fetchProducts();
    } else {
      console.warn(`Category "${nameToSearch}" not found in the loaded categories list.`);
      setErrorMessage(`The category "${nameToSearch.replace(/-/g, " ")}" is not available at this time.`);
      setIsLoadingProducts(false);
      setIsLoading(false);
    }
  }, [allCategories, categoryName, isLoadingCategories, API_BASE_URL]);

  const filteredItems = categoryProducts.filter(
    (item) => item.name && item.name.toLowerCase().includes(searchQuery ? searchQuery.toLowerCase() : "")
  );

  const handleWishlistToggle = async (item) => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      alert("Please log in to add items to your wishlist.");
      return;
    }
    const body = new URLSearchParams();
    body.append("product_id", String(item.product_id));
    body.append("buyer_id", buyerId);

    const isInWishlist = wishlist.some((wItem) => wItem.product_id === item.product_id);
    const currentIconState = iconStates[item.product_id]?.heart;
    const effectiveIsInWishlist = currentIconState !== undefined ? currentIconState : isInWishlist;

    setIconStates((prev) => ({ ...prev, [item.product_id]: { ...prev[item.product_id], heart: !effectiveIsInWishlist } }));
    if (effectiveIsInWishlist) {
      setWishlist(wishlist.filter((wItem) => wItem.product_id !== item.product_id));
      setConfirmationMessage(`${item.name} has been removed from your wishlist!`);
    } else {
      setWishlist([...wishlist, { product_id: item.product_id, name: item.name, image: item.image, price: item.price }]);
      setConfirmationMessage(`${item.name} has been added to your wishlist!`);
    }
    setTimeout(() => setConfirmationMessage(null), 3000);

    try {
      const response = await axios.post(`${API_BASE_URL}/public/api/addwishlist`, body.toString(), {
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
      });

      if (!(response.status === 200 || response.status === 201) || (response.data && response.data.status === false && effectiveIsInWishlist)) {
        setIconStates((prev) => ({ ...prev, [item.product_id]: { ...prev[item.product_id], heart: effectiveIsInWishlist } }));
        if (effectiveIsInWishlist) {
          if (!wishlist.some((w) => w.product_id === item.product_id))
            setWishlist([...wishlist, { product_id: item.product_id, name: item.name, image: item.image, price: item.price }]);
        } else {
          setWishlist(wishlist.filter((wItem) => wItem.product_id !== item.product_id));
        }
        setConfirmationMessage("Could not update wishlist. Server responded unexpectedly.");
        setTimeout(() => setConfirmationMessage(null), 3000);
      } else {
        console.log("Wishlist updated successfully via API:", response.data);
      }
    } catch (err) {
      console.error("Error updating wishlist:", err.response?.data || err.message);
      setIconStates((prev) => ({ ...prev, [item.product_id]: { ...prev[item.product_id], heart: effectiveIsInWishlist } }));
      if (effectiveIsInWishlist) {
        if (!wishlist.some((w) => w.product_id === item.product_id))
          setWishlist([...wishlist, { product_id: item.product_id, name: item.name, image: item.image, price: item.price }]);
      } else {
        setWishlist(wishlist.filter((wItem) => wItem.product_id !== item.product_id));
      }
      setConfirmationMessage("An error occurred while updating your wishlist.");
      setTimeout(() => setConfirmationMessage(null), 3000);
    }
  };

  const handleCartToggle = async (item) => {
    const buyerId = localStorage.getItem("buyer_id");
    if (!buyerId) {
      alert("Please log in to add items to your cart.");
      return;
    }
    const body = new URLSearchParams();
    body.append("product_id", String(item.product_id));
    body.append("qty", "1");
    body.append("buyer_id", buyerId);

    const isInCart = cart.some((cItem) => cItem.product_id === item.product_id);
    const currentIconState = iconStates[item.product_id]?.cart;
    const effectiveIsInCart = currentIconState !== undefined ? currentIconState : isInCart;

    setIconStates((prev) => ({ ...prev, [item.product_id]: { ...prev[item.product_id], cart: !effectiveIsInCart } }));
    if (effectiveIsInCart) {
      setCart(cart.filter((cItem) => cItem.product_id !== item.product_id));
      setConfirmationMessage(`${item.name} has been removed from your cart!`);
    } else {
      setCart([...cart, { product_id: item.product_id, name: item.name, image: item.image, price: item.price, quantity: 1 }]);
      setConfirmationMessage(`${item.name} has been added to your cart!`);
    }
    setTimeout(() => setConfirmationMessage(null), 3000);

    try {
      const response = await axios.post(`${API_BASE_URL}/public/api/cart_add`, body.toString(), {
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
      });

      if (!(response.status === 200 || response.status === 201)) {
        setIconStates((prev) => ({ ...prev, [item.product_id]: { ...prev[item.product_id], cart: effectiveIsInCart } }));
        if (effectiveIsInCart) {
          if (!cart.some((c) => c.product_id === item.product_id)) {
            setCart([...cart, { product_id: item.product_id, name: item.name, image: item.image, price: item.price, quantity: 1 }]);
          }
        } else {
          setCart(cart.filter((cItem) => cItem.product_id !== item.product_id));
        }
        setConfirmationMessage("Could not update cart. Server responded unexpectedly.");
        setTimeout(() => setConfirmationMessage(null), 3000);
      } else {
        console.log("Add to cart API call successful:", response.data);
      }
    } catch (err) {
      console.error("Error updating cart:", err.response?.data || err.message);
      setIconStates((prev) => ({ ...prev, [item.product_id]: { ...prev[item.product_id], cart: effectiveIsInCart } }));
      if (effectiveIsInCart) {
        if (!cart.some((c) => c.product_id === item.product_id))
          setCart([...cart, { product_id: item.product_id, name: item.name, image: item.image, price: item.price, quantity: 1 }]);
      } else {
        setCart(cart.filter((cItem) => cItem.product_id !== item.product_id));
      }
      setConfirmationMessage("An error occurred while updating your cart.");
      setTimeout(() => setConfirmationMessage(null), 3000);
    }
  };

  const cardVariants = {
    initial: { opacity: 0, y: 20 },
    animate: (index) => ({ opacity: 1, y: 0, transition: { delay: index * 0.05, duration: 0.4 } }),
    hover: { scale: 1.03, boxShadow: "0px 10px 20px rgba(0,0,0,0.1)" },
  };

  // Combined loading state check
  if (isLoading) {
    return <Loader />;
  }

  if (errorMessage) {
    return (
      <div className="flex flex-col justify-center items-center min-h-[calc(100vh-200px)] text-center">
        <p className="text-xl text-red-600">Notice</p>
        <p className="text-md text-gray-700 mt-2">{errorMessage}</p>
        <button
          onClick={() => navigate("/buyer/home")}
          className="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition duration-300"
        >
          Return to Home
        </button>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-4 sm:p-6 min-h-screen">
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

      <h1 className="text-2xl sm:text-3xl font-bold mb-6 sm:mb-8 text-center capitalize text-gray-800">
        {displayCategoryName || (categoryName ? categoryName.replace(/-/g, " ") : "Category")}
      </h1>

      {filteredItems.length === 0 ? (
        <div className="text-center py-10">
          <svg className="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path
              vectorEffect="non-scaling-stroke"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2zm3-1a1 1 0 000 2h.01a1 1 0 100-2H12zm5-1a1 1 0 000 2h.01a1 1 0 100-2H17z"
            />
          </svg>
          <h3 className="mt-2 text-sm font-medium text-gray-900">No products found</h3>
          <p className="mt-1 text-sm text-gray-500">
            There are no products available in this category{searchQuery && ` matching "${searchQuery}"`}.
          </p>
        </div>
      ) : (
        <motion.div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 sm:gap-6">
          {filteredItems.map((item, index) => {
            const discountedPrice = item.discount > 0 ? (item.price * (1 - item.discount / 100)) : item.price;
            const isWishlisted =
              iconStates[item.product_id]?.heart !== undefined
                ? iconStates[item.product_id].heart
                : wishlist.some((wItem) => wItem.product_id === item.product_id);
            const isInUserCart =
              iconStates[item.product_id]?.cart !== undefined
                ? iconStates[item.product_id].cart
                : cart.some((cItem) => cItem.product_id === item.product_id);

            return (
              <motion.div
                key={item.product_id}
                className="bg-white rounded-lg shadow-md overflow-hidden flex flex-col transition-shadow duration-300 hover:shadow-xl"
                variants={cardVariants}
                initial="initial"
                animate="animate"
                custom={index}
                whileHover="hover"
              >
                <div
                  className="relative w-full h-52 sm:h-56 cursor-pointer group"
                  onClick={() => navigate(`/buyer/product-detail`, { state: { product: item } })}
                >
                  <img
                    src={item.image}
                    alt={item.name}
                    className="w-full h-full object-cover"
                    onError={(e) => {
                      e.target.src = "https://source.unsplash.com/300x200/?product&text=Image+Error";
                    }}
                  />
                  {item.discount > 0 && (
                    <div className="absolute top-3 left-3 bg-red-500 text-white text-xs font-semibold px-2.5 py-1 rounded">
                      {item.discount}% OFF
                    </div>
                  )}
                  <div className="absolute top-3 right-3 flex flex-col space-y-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        handleWishlistToggle(item);
                      }}
                      className={`p-2 rounded-full bg-white/80 backdrop-blur-sm shadow-md transition-colors ${
                        isWishlisted ? "text-red-500" : "text-gray-700 hover:text-red-500"
                      }`}
                      aria-label="Toggle Wishlist"
                    >
                      {isWishlisted ? <HeartSolidIcon className="w-5 h-5" /> : <HeartOutlineIcon className="w-5 h-5" />}
                    </button>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        handleCartToggle(item);
                      }}
                      className={`p-2 rounded-full bg-white/80 backdrop-blur-sm shadow-md transition-colors ${
                        isInUserCart ? "text-green-600" : "text-gray-700 hover:text-green-600"
                      }`}
                      aria-label="Toggle Cart"
                    >
                      {isInUserCart ? <CartSolidIcon className="w-5 h-5" /> : <CartOutlineIcon className="w-5 h-5" />}
                    </button>
                  </div>
                </div>

                <div className="p-3 sm:p-4 flex flex-col flex-grow">
                  <h3
                    className="text-base sm:text-lg font-semibold text-gray-800 mb-1 truncate cursor-pointer"
                    onClick={() => navigate(`/buyer/product-detail`, { state: { product: item } })}
                    title={item.name}
                  >
                    {item.name}
                  </h3>
                  {item.description && (
                    <p className="text-xs sm:text-sm text-gray-600 mb-2 line-clamp-2 flex-grow" title={item.description}>
                      {item.description}
                    </p>
                  )}
                  <div className="mt-auto">
                    <div className="flex items-baseline gap-2 mb-2">
                      <span className="text-md sm:text-lg font-bold text-blue-700">{discountedPrice.toFixed(2)} EGP</span>
                      {item.discount > 0 && item.price != null && (
                        <span className="text-xs sm:text-sm text-gray-500 line-through">
                          {parseFloat(item.price).toFixed(2)} EGP
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              </motion.div>
            );
          })}
        </motion.div>
      )}
    </div>
  );
}

export default CategoryPage;