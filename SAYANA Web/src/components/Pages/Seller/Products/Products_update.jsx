import React, { useState, useEffect } from "react";
import { useNavigate, useParams, useLocation } from "react-router-dom";
import axios from "axios";

const ProductsUpdate = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const { state } = useLocation();

  const [price, setPrice] = useState("");
  const [description, setDescription] = useState("");
  const [name, setName] = useState("");
  const [quantity, setQuantity] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [error, setError] = useState(null);

  useEffect(() => {
    if (state && state.product) {
      const product = state.product;
      setPrice(product.price || "");
      setDescription(product.description || "");
      setName(product.name || "");
      setQuantity(product.quantity || "");
      setImageUrl(product.imageUrl || "https://via.placeholder.com/128");
    }
  }, [state]);

  const handleSave = async () => {
    try {
      const token = localStorage.getItem("token");
      const sellerId = localStorage.getItem("seller_id");

      if (!token || !sellerId) {
        setError("No token or seller_id found in localStorage");
        return;
      }

      const numericPrice = parseFloat(price.replace(/[^0-9.]/g, ""));
      const updatedProduct = {
        name,
        description,
        price: numericPrice,
        quantity: parseInt(quantity),
        saller_id: parseInt(sellerId),
      };

      await axios.put(
        `https://olivedrab-llama-457480.hostingersite.com/public/api/update_product/${id}`,
        updatedProduct,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      navigate("/products");
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="flex flex-col h-screen bg-[#FBFBFB] relative">
      <div className="flex-1 p-6 pb-24">
        <h1 className="text-2xl font-bold mb-6">Edit Product</h1>
        {error && <p className="text-red-500 mb-4">{error}</p>}
        <div className="flex flex-col items-center">
          {imageUrl && (
            <img
              src={imageUrl}
              alt={name}
              className="w-60 h-60 object-cover mb-4 rounded-lg border border-gray-200"
              onError={(e) => {
                e.target.src = "https://via.placeholder.com/128";
              }}
            />
          )}
          <div className="w-full max-w-md">
            <div className="mb-4">
              <label className="block text-gray-700">Product Name</label>
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-4">
              <label className="block text-gray-700">Price</label>
              <input
                type="text"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-4">
              <label className="block text-gray-700">Description</label>
              <input
                type="text"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
            <div className="mb-4">
              <label className="block text-gray-700">Quantity</label>
              <input
                type="number"
                value={quantity}
                onChange={(e) => setQuantity(e.target.value)}
                className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664]"
              />
            </div>
          </div>
        </div>
      </div>

      <div className="absolute bottom-16 right-10">
        <button
          onClick={handleSave}
          className="bg-[#003664] text-white px-6 py-2 rounded-full shadow-md hover:opacity-90 transition"
        >
          Save
        </button>
      </div>
    </div>
  );
};

export default ProductsUpdate;