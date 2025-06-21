import React, { useEffect, useState } from "react";
import { Card, CardContent } from "/src/components/ui/card.jsx";
import { TrashIcon, PencilIcon } from '@heroicons/react/24/solid';
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { motion, AnimatePresence } from "framer-motion";

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

const Product = () => {
  const navigate = useNavigate();
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [productToDelete, setProductToDelete] = useState(null);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const sellerId = localStorage.getItem("seller_id");
        const token = localStorage.getItem("token");

        if (!sellerId || !token) {
          setError("No seller_id or token found in localStorage");
          setLoading(false);
          return;
        }

        const response = await axios.get(
          `https://olivedrab-llama-457480.hostingersite.com/public/api/get_product_by_seller_id?saller_id=${sellerId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        const transformedProducts = response.data.map((product) => {
          const imagePath = product.images?.[0]?.image_path;
          const imageUrl = imagePath
            ? `https://olivedrab-llama-457480.hostingersite.com/${imagePath}`
            : "https://via.placeholder.com/128";

          return {
            ...product,
            imageUrl,
          };
        });

        setProducts(transformedProducts);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  const handleEditClick = (productId) => {
    const product = products.find((product) => product.product_id === productId);
    navigate(`/products-update/${productId}`, { state: { product } });
  };

  const handleAddProductClick = () => {
    navigate('/add-product');
  };

  const handleDeleteClick = async (productId) => {
    try {
      const token = localStorage.getItem("token");

      if (!token) {
        setError("No token found in localStorage");
        return;
      }

      await axios.delete(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/delete_products/${productId}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      setProducts(products.filter((product) => product.product_id !== productId));
      setShowConfirmModal(false);
    } catch (err) {
      setError(err.message);
    }
  };

  const openConfirmModal = (productId) => {
    setProductToDelete(productId);
    setShowConfirmModal(true);
  };

  const closeConfirmModal = () => {
    setShowConfirmModal(false);
    setProductToDelete(null);
  };

  return (
    <div className="flex h-screen bg-[#FBFBFB]">
      <main className="flex-1 p-6 overflow-y-scroll">
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-2xl font-bold">Products</h1>
          <button
            onClick={handleAddProductClick}
            className="px-6 py-2 bg-[#003664] text-white font-bold text-base rounded-full shadow-lg transform transition-transform duration-300 hover:scale-110 hover:bg-indigo-700 focus:outline-none focus:ring-4 focus:ring-indigo-300 animate-pulse-professional"
          >
            Add Product
          </button>
        </div>

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

        {error ? (
          <p>Error: {error}</p>
        ) : !loading && (
          <div className="grid grid-cols-3 gap-4">
            {products.map((product) => (
              <Card
                key={product.product_id}
                className="p-4 relative bg-[#EFF4F7] transition-transform transform hover:scale-105 hover:translate-y-[-10px] h-[440px] flex flex-col"
                style={{ minHeight: "440px", maxHeight: "440px" }} // يمكنك تغير الرقم حسب ما يناسبك
              >
                {/* أزرار الحذف والتعديل */}
                <button
                  className="absolute top-4 right-2 bg-red-500 p-2 rounded-full text-white opacity-80"
                  onClick={() => openConfirmModal(product.product_id)}
                >
                  <TrashIcon className="w-6 h-6" />
                </button>
                <button
                  className="absolute top-16 right-2 bg-gray-500 p-2 rounded-full text-white opacity-80"
                  onClick={() => handleEditClick(product.product_id)}
                >
                  <PencilIcon className="w-6 h-6" />
                </button>
                {/* محتوى الكارت */}
                <CardContent className="flex flex-col flex-1 justify-between items-center p-0">
                  <div className="flex flex-col items-center w-full">
                    <img
                      src={product.imageUrl}
                      alt={product.name}
                      className="w-40 h-40 object-cover mb-2 max-w-full max-h-40 rounded-lg border border-gray-200"
                      onError={(e) => {
                        e.target.src = "https://via.placeholder.com/128";
                      }}
                    />
                    <div className="text-[#201A23] font-semibold text-lg mt-1 mb-1">{product.price} LE</div>
                    <div className="text-gray-800 font-semibold text-center h-12 overflow-hidden text-ellipsis line-clamp-2">
                      {product.name}
                    </div>
                    {/* وصف المنتج مع سطرين فقط */}
                    <div
                      className="text-gray-500 text-sm mb-2 mt-1 text-center h-10 overflow-hidden text-ellipsis"
                      style={{
                        display: '-webkit-box',
                        WebkitLineClamp: 2,
                        WebkitBoxOrient: 'vertical',
                        whiteSpace: 'normal',
                      }}
                    >
                      {product.description}
                    </div>
                  </div>
                  {/* معلومات المخزون والطلبات */}
                  <div className="flex justify-between w-full text-sm text-gray-600 mt-2">
                    <div className="flex flex-col items-center">
                      <div className="font-semibold">{product.quantity}</div>
                      <div>Stocks</div>
                    </div>
                    <div className="flex flex-col items-center">
                      <div className="font-semibold">{product.sales_count}</div>
                      <div>Orders</div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </main>

      {showConfirmModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-lg shadow-lg text-center">
            <h2 className="text-xl font-bold text-[#003664] mb-4">Confirm Delete</h2>
            <p className="text-gray-600 mb-6">Are you sure you want to Delete Product?</p>
            <div className="flex justify-center gap-4">
              <button
                onClick={closeConfirmModal}
                className="px-4 py-2 bg-gray-300 text-gray-800 rounded-full hover:bg-gray-400 transition"
              >
                Cancel
              </button>
              <button
                onClick={() => handleDeleteClick(productToDelete)}
                className="px-4 py-2 bg-red-500 text-white rounded-full hover:bg-opacity-90 transition"
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      )}

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

export default Product;