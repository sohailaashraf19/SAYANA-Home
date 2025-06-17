import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const AddProduct = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: "",
    description: "",
    price: "",
    quantity: "",
    category_id: "",
    saller_id: "",
    sales_count: "",
    color: "",
    type: "",
    discount: "",
    images: null,
  });
  const [error, setError] = useState(null);

  const handleChange = (e) => {
    const { name, value, type, files } = e.target;
    if (type === "file" && files) {
      setFormData({ ...formData, [name]: files[0] });
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      const token = localStorage.getItem("token");
      const sellerId = localStorage.getItem("seller_id");

      if (!token || !sellerId) {
        setError("No token or seller_id found in localStorage");
        return;
      }

      const data = new FormData();
      data.append("name", formData.name);
      data.append("description", formData.description);
      data.append("price", formData.price);
      data.append("quantity", formData.quantity);
      data.append("category_id", formData.category_id);
      data.append("saller_id", sellerId);
      data.append("sales_count", formData.sales_count);
      data.append("color", formData.color);
      data.append("type", formData.type);
      data.append("discount", formData.discount);
      if (formData.images) {
        data.append("images", formData.images);
      }

      const response = await axios.post(
        "https://olivedrab-llama-457480.hostingersite.com/public/api/addproduct",
        data,
        {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "multipart/form-data",
          },
        }
      );

      if (response.data.message.includes("successfully")) {
        
        navigate("/products");
      } else {
        setError("Failed to add product.");
      }
    } catch (err) {
      setError(err.message || "Error adding product.");
    }
  };

  return (
    <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded shadow">
      <h2 className="text-2xl font-bold mb-6 text-center">Add New Product</h2>
      {error && <p className="text-red-500 mb-4">{error}</p>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          type="text"
          name="name"
          placeholder="Product Name"
          value={formData.name}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          required
        />
        <input
          type="text"
          name="description"
          placeholder="Description"
          value={formData.description}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          required
        />
        <input
          type="number"
          name="price"
          placeholder="Price"
          value={formData.price}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          required
          min="0"
          step="0.01"
        />
        <input
          type="number"
          name="quantity"
          placeholder="Quantity"
          value={formData.quantity}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          required
          min="0"
        />
        <input
          type="number"
          name="category_id"
          placeholder="Category ID"
          value={formData.category_id}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          required
        />
        <input
          type="number"
          name="sales_count"
          placeholder="Sales Count"
          value={formData.sales_count}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
        />
        <input
          type="text"
          name="color"
          placeholder="Color"
          value={formData.color}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
        />
        <input
          type="text"
          name="type"
          placeholder="Type"
          value={formData.type}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
        />
        <input
          type="number"
          name="discount"
          placeholder="Discount"
          value={formData.discount}
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          min="0"
        />
        <input
          type="file"
          name="images"
          accept="image/*"
          onChange={handleChange}
          className="w-full p-2 border border-gray-300 rounded-full focus:outline-none focus:border-[#003664] transition"
          required
        />

        <button
          type="submit"
          className="w-full bg-[#003664] text-white py-2 rounded-full hover:bg-[#003664] hover:bg-opacity-80 transition"
        >
          Add Product
        </button>
      </form>
    </div>
  );
};

export default AddProduct;